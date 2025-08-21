import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLogin = false.obs;
  Rx<UserModel>? userModel = UserModel().obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;

  // Dữ liệu tài liệu
  RxList<Reference> recentDocuments = <Reference>[].obs;
  RxList<Reference> popularDocuments = <Reference>[].obs;
  RxList<Reference> newDocuments = <Reference>[].obs;
  RxBool isLoadingDocuments = false.obs;
  RxString documentsError = ''.obs;

  @override
  void onInit() {
    print('🔄 HomeController.onInit() called');
    isLogin.value = Preferences.getBoolean(Preferences.isLogin);
    print('🔐 isLogin value: ${isLogin.value}');

    // Luôn gọi fetchHomeDocuments() để test, không phụ thuộc vào đăng nhập
    fetchHomeDocuments();

    if (isLogin.value == true) {
      getUserData();
    }
    super.onInit();
  }

  getUserData() async {
    try {
      UserModel userModel = Constants.getUserData();
      firstName.value = userModel.data?.firstName ?? "";
      lastName.value = userModel.data?.lastName ?? "";
      email.value = userModel.data?.email ?? "";
      phone.value = userModel.data?.phone ?? "";
      this.userModel?.value = userModel;
      print('👤 User data loaded: ${firstName.value} ${lastName.value}');
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  // Lấy dữ liệu tài liệu cho home screen
  Future<void> fetchHomeDocuments() async {
    print('📁 fetchHomeDocuments() called');
    isLoadingDocuments.value = true;
    documentsError.value = '';

    try {
      print('🔍 Accessing Firebase Storage...');
      // Lấy tất cả tài liệu từ Firebase Storage
      final ListResult result = await _storage.ref('uploads').listAll();
      final List<Reference> allFiles = result.items;

      print('📊 Found ${allFiles.length} files in Firebase Storage');

      // // Log tên các file để debug
      // for (int i = 0; i < allFiles.length; i++) {
      //   print('📄 File $i: ${allFiles[i].name} (${allFiles[i].fullPath})');
      // }

      if (allFiles.isNotEmpty) {
        // Tài liệu mới nhất (5 tài liệu đầu tiên)
        newDocuments.assignAll(allFiles.take(5));
        // print('🆕 New documents: ${newDocuments.length}');

        // Tài liệu xem gần đây (5 tài liệu tiếp theo)
        if (allFiles.length > 5) {
          recentDocuments.assignAll(allFiles.skip(5).take(5));
          // print('🕒 Recent documents: ${recentDocuments.length}');
        }

        // Tài liệu phổ biến (5 tài liệu cuối)
        if (allFiles.length > 10) {
          popularDocuments.assignAll(allFiles.skip(10).take(5));
          // print('⭐ Popular documents: ${popularDocuments.length}');
        }

        // Nếu không đủ tài liệu, lấy từ đầu
        if (recentDocuments.isEmpty && allFiles.length > 5) {
          recentDocuments.assignAll(allFiles.take(5));
          print('🔄 Filled recent documents: ${recentDocuments.length}');
        }
        if (popularDocuments.isEmpty && allFiles.length > 5) {
          popularDocuments.assignAll(allFiles.take(5));
          print('🔄 Filled popular documents: ${popularDocuments.length}');
        }

        print('✅ Documents loaded successfully');
        // print(
        //     '📊 Summary: New=${newDocuments.length}, Recent=${recentDocuments.length}, Popular=${popularDocuments.length}');
      } else {
        print('📭 No files found in Firebase Storage');
        documentsError.value =
            'Không tìm thấy tài liệu nào trong Firebase Storage';
      }
    } catch (e) {
      print('❌ Error in fetchHomeDocuments: $e');
      documentsError.value = 'Lỗi khi tải tài liệu: $e';
    } finally {
      isLoadingDocuments.value = false;
      print(
          '🏁 fetchHomeDocuments completed. Loading: ${isLoadingDocuments.value}, Error: ${documentsError.value}');
    }
  }

  // Lấy URL download cho tài liệu
  Future<String> getDownloadUrl(Reference ref) async {
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Không thể lấy URL download: $e');
    }
  }

  // Lấy thông tin tài liệu
  String getDocumentName(Reference ref) {
    return ref.name;
  }

  String getDocumentPath(Reference ref) {
    return ref.fullPath;
  }

  String getDocumentExtension(Reference ref) {
    return ref.name.split('.').last.toLowerCase();
  }

  // Refresh dữ liệu
  Future<void> refreshDocuments() async {
    print('🔄 refreshDocuments() called');
    await fetchHomeDocuments();
  }

  // Debug function để kiểm tra trạng thái
  void debugStatus() {
    print('🔍 === HomeController Debug Status ===');
    print('🔐 isLogin: ${isLogin.value}');
    print('📱 firstName: ${firstName.value}');
    print('📱 lastName: ${lastName.value}');
    print('📁 isLoadingDocuments: ${isLoadingDocuments.value}');
    print('📁 documentsError: ${documentsError.value}');
    print('📁 newDocuments: ${newDocuments.length}');
    print('📁 recentDocuments: ${recentDocuments.length}');
    print('📁 popularDocuments: ${popularDocuments.length}');
    print('🔍 === End Debug Status ===');
  }
}
