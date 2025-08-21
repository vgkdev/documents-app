import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/widgets/custom_search_bar.dart';
import 'package:documents_app/controllers/search_controller.dart' as app_search;
import 'package:documents_app/screens/documents_screen/document_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<app_search.SearchController>(
      init: app_search.SearchController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: GlobalColors.background,
          appBar: AppBar(
            backgroundColor: GlobalColors.background,
            shadowColor: GlobalColors.background,
            elevation: 0,
            title: Text(
              'Tìm kiếm',
              style: TextStyle(
                color: GlobalColors.textColor,
              ),
            ),
            actions: [
              // Filter button
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.filter_list,
                  color: GlobalColors.blackIcon,
                ),
                onSelected: (value) {
                  controller.changeFileTypeFilter(value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('Tất cả loại file'),
                  ),
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Text('Chỉ PDF'),
                  ),
                  const PopupMenuItem(
                    value: 'docx',
                    child: Text('Chỉ Word'),
                  ),
                  const PopupMenuItem(
                    value: 'txt',
                    child: Text('Chỉ Text'),
                  ),
                  const PopupMenuItem(
                    value: 'image',
                    child: Text('Chỉ hình ảnh'),
                  ),
                  const PopupMenuItem(
                    value: 'spreadsheet',
                    child: Text('Chỉ Excel'),
                  ),
                  const PopupMenuItem(
                    value: 'presentation',
                    child: Text('Chỉ PowerPoint'),
                  ),
                ],
              ),
              // Refresh button
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: GlobalColors.blackIcon,
                ),
                onPressed: () => controller.refreshSearch(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomSearchBar(
                  controller: _searchController,
                  onSearch: (query) => controller.performSearch(query),
                  onClear: () => controller.clearSearch(),
                  autoFocus: true,
                ),
              ),

              // Filter chip
              if (controller.selectedFileType.value != 'all')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Chip(
                        label: Text(
                          'Loại: ${_getFileTypeDisplayName(controller.selectedFileType.value)}',
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => controller.changeFileTypeFilter('all'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Search results or content
              Expanded(
                child: _buildSearchContent(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchContent(app_search.SearchController controller) {
    // Loading state
    if (controller.isSearching.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tìm kiếm...'),
          ],
        ),
      );
    }

    // Error state
    if (controller.searchError.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.searchError.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshSearch(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // Search results
    if (controller.searchQuery.value.isNotEmpty) {
      if (controller.searchResults.isEmpty) {
        return _buildNoResultsFound(controller);
      }
      return _buildSearchResults(controller);
    }

    // Initial state - show search history or suggestions
    return _buildInitialContent(controller);
  }

  Widget _buildNoResultsFound(app_search.SearchController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Không có file nào phù hợp với "${controller.searchQuery.value}"',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Text(
            'Gợi ý:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Kiểm tra chính tả\n• Thử từ khóa khác\n• Thay đổi filter loại file',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(app_search.SearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'Kết quả tìm kiếm (${controller.searchResults.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Tìm: "${controller.searchQuery.value}"',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final file = controller.searchResults[index];
              return _buildSearchResultItem(controller, file, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(
      app_search.SearchController controller, Reference file, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(controller.getFileColor(file)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              controller.getFileIcon(file),
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          controller.getFileDisplayName(file),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.getFileDisplayPath(file),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(controller.getFileColor(file)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                controller.getFileDisplayType(file),
                style: TextStyle(
                  color: Color(controller.getFileColor(file)),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            Get.to(() => DocumentViewerScreen(ref: file));
          },
          tooltip: 'Mở file',
        ),
        onTap: () {
          Get.to(() => DocumentViewerScreen(ref: file));
        },
      ),
    );
  }

  Widget _buildInitialContent(app_search.SearchController controller) {
    return Column(
      children: [
        // Search history
        if (controller.searchHistory.isNotEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text(
                  'Lịch sử tìm kiếm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => controller.clearSearchHistory(),
                  child: const Text('Xóa tất cả'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.searchHistory.length,
              itemBuilder: (context, index) {
                final query = controller.searchHistory[index];
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => controller.removeFromSearchHistory(query),
                  ),
                  onTap: () {
                    _searchController.text = query;
                    controller.performSearch(query);
                  },
                );
              },
            ),
          ),
        ] else ...[
          // No search history - show suggestions
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bắt đầu tìm kiếm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nhập từ khóa để tìm kiếm file',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Gợi ý tìm kiếm:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSuggestionChip('pdf', controller),
                      _buildSuggestionChip('document', controller),
                      _buildSuggestionChip('image', controller),
                      _buildSuggestionChip('report', controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuggestionChip(
      String suggestion, app_search.SearchController controller) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        _searchController.text = suggestion;
        controller.performSearch(suggestion);
      },
    );
  }

  String _getFileTypeDisplayName(String fileType) {
    switch (fileType) {
      case 'pdf':
        return 'PDF';
      case 'docx':
        return 'Word';
      case 'txt':
        return 'Text';
      case 'image':
        return 'Hình ảnh';
      case 'spreadsheet':
        return 'Excel';
      case 'presentation':
        return 'PowerPoint';
      default:
        return 'Tất cả';
    }
  }
}
