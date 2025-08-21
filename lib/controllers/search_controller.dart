import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document_display.dart';

class SearchController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Search state
  final RxString searchQuery = ''.obs;
  final RxList<Reference> searchResults = <Reference>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchError = ''.obs;

  // Filter options
  final RxString selectedFileType = 'all'.obs;
  final RxBool showOnlyPdf = false.obs;
  final RxBool showOnlyDocx = false.obs;
  final RxBool showOnlyTxt = false.obs;

  // Search history
  final RxList<String> searchHistory = <String>[].obs;

  // All files cache (for offline search)
  final RxList<Reference> allFiles = <Reference>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load all files when controller initializes
    loadAllFiles();
  }

  /// Load tất cả file từ Firebase Storage để cache
  Future<void> loadAllFiles() async {
    try {
      print('📁 Loading all files for search...');
      final ListResult result = await _storage.ref('uploads').listAll();
      allFiles.assignAll(result.items);
      print('✅ Loaded ${allFiles.length} files for search');
    } catch (e) {
      print('❌ Error loading files for search: $e');
      searchError.value = 'Không thể tải danh sách file: $e';
    }
  }

  /// Thực hiện tìm kiếm
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      searchQuery.value = '';
      return;
    }

    searchQuery.value = query.trim();
    isSearching.value = true;
    searchError.value = '';

    try {
      print('🔍 Searching for: "$query"');

      // Thêm vào lịch sử tìm kiếm
      addToSearchHistory(query);

      // Tìm kiếm trong cache files
      final List<Reference> results = _searchInFiles(query);

      // Áp dụng filter theo loại file
      final List<Reference> filteredResults = _applyFileTypeFilter(results);

      searchResults.assignAll(filteredResults);

      print('✅ Search completed. Found ${searchResults.length} results');
    } catch (e) {
      print('❌ Search error: $e');
      searchError.value = 'Lỗi khi tìm kiếm: $e';
    } finally {
      isSearching.value = false;
    }
  }

  /// Tìm kiếm trong danh sách file
  List<Reference> _searchInFiles(String query) {
    final String lowerQuery = query.toLowerCase();
    final List<Reference> results = <Reference>[];

    for (final Reference file in allFiles) {
      final String fileName = file.name.toLowerCase();
      final String filePath = file.fullPath.toLowerCase();

      // Tìm kiếm theo tên file
      if (fileName.contains(lowerQuery)) {
        results.add(file);
        continue;
      }

      // Tìm kiếm theo đường dẫn
      if (filePath.contains(lowerQuery)) {
        results.add(file);
        continue;
      }

      // Tìm kiếm theo extension
      final String extension = _getFileExtension(fileName);
      if (extension.contains(lowerQuery)) {
        results.add(file);
        continue;
      }

      // Tìm kiếm fuzzy (tương tự)
      if (_isFuzzyMatch(fileName, lowerQuery)) {
        results.add(file);
      }
    }

    // Sắp xếp kết quả theo độ ưu tiên
    results.sort((a, b) {
      final String nameA = a.name.toLowerCase();
      final String nameB = b.name.toLowerCase();

      // Ưu tiên file có tên bắt đầu bằng query
      final bool aStartsWith = nameA.startsWith(lowerQuery);
      final bool bStartsWith = nameB.startsWith(lowerQuery);

      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;

      // Nếu cùng loại, sắp xếp theo tên
      return nameA.compareTo(nameB);
    });

    return results;
  }

  /// Áp dụng filter theo loại file
  List<Reference> _applyFileTypeFilter(List<Reference> files) {
    if (selectedFileType.value == 'all') {
      return files;
    }

    return files.where((file) {
      final String extension = _getFileExtension(file.name);

      switch (selectedFileType.value) {
        case 'pdf':
          return extension == 'pdf';
        case 'docx':
          return extension == 'docx' || extension == 'doc';
        case 'txt':
          return extension == 'txt';
        case 'image':
          return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
        case 'spreadsheet':
          return ['xlsx', 'xls'].contains(extension);
        case 'presentation':
          return ['pptx', 'ppt'].contains(extension);
        default:
          return true;
      }
    }).toList();
  }

  /// Fuzzy matching để tìm kiếm tương tự
  bool _isFuzzyMatch(String fileName, String query) {
    if (query.length < 2) return false;

    int queryIndex = 0;
    for (int i = 0; i < fileName.length && queryIndex < query.length; i++) {
      if (fileName[i] == query[queryIndex]) {
        queryIndex++;
      }
    }

    return queryIndex == query.length;
  }

  /// Lấy extension của file
  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Thêm query vào lịch sử tìm kiếm
  void addToSearchHistory(String query) {
    if (query.trim().isNotEmpty && !searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      // Giới hạn lịch sử tìm kiếm
      if (searchHistory.length > 10) {
        searchHistory.removeLast();
      }
    }
  }

  /// Xóa lịch sử tìm kiếm
  void clearSearchHistory() {
    searchHistory.clear();
  }

  /// Xóa một item khỏi lịch sử
  void removeFromSearchHistory(String query) {
    searchHistory.remove(query);
  }

  /// Thay đổi filter loại file
  void changeFileTypeFilter(String fileType) {
    selectedFileType.value = fileType;
    // Thực hiện tìm kiếm lại với filter mới
    if (searchQuery.value.isNotEmpty) {
      performSearch(searchQuery.value);
    }
  }

  /// Clear kết quả tìm kiếm
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    searchError.value = '';
  }

  /// Refresh search (tải lại file và tìm kiếm lại)
  Future<void> refreshSearch() async {
    await loadAllFiles();
    if (searchQuery.value.isNotEmpty) {
      await performSearch(searchQuery.value);
    }
  }

  /// Lấy thông tin file để hiển thị
  String getFileDisplayName(Reference file) {
    return file.name;
  }

  String getFileDisplayPath(Reference file) {
    return file.fullPath;
  }

  String getFileDisplayType(Reference file) {
    return _getFileExtension(file.name).toUpperCase();
  }

  /// Lấy icon theo loại file
  String getFileIcon(Reference file) {
    final String extension = getFileDisplayType(file);

    switch (extension.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'docx':
      case 'doc':
        return '📝';
      case 'txt':
        return '📄';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return '🖼️';
      case 'xlsx':
      case 'xls':
        return '📊';
      case 'pptx':
      case 'ppt':
        return '📊';
      default:
        return '📁';
    }
  }

  /// Lấy màu theo loại file
  int getFileColor(Reference file) {
    final String extension = getFileDisplayType(file);

    switch (extension.toLowerCase()) {
      case 'pdf':
        return 0xFFE53E3E; // Red
      case 'docx':
      case 'doc':
        return 0xFF3182CE; // Blue
      case 'txt':
        return 0xFF38A169; // Green
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 0xFFDD6B20; // Orange
      case 'xlsx':
      case 'xls':
        return 0xFF2F855A; // Dark Green
      case 'pptx':
      case 'ppt':
        return 0xFFC05621; // Dark Orange
      default:
        return 0xFF718096; // Gray
    }
  }
}
