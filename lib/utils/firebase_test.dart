import 'package:firebase_storage/firebase_storage.dart';

class FirebaseTest {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Test kết nối Firebase Storage
  static Future<void> testFirebaseConnection() async {
    try {
      print('🔍 Testing Firebase Storage connection...');

      // Test 1: Kiểm tra kết nối cơ bản
      print('📡 Testing basic connection...');
      final storageRef = _storage.ref();
      print('✅ Basic connection successful');

      // Test 2: Kiểm tra thư mục uploads
      print('📁 Testing uploads folder access...');
      final uploadsRef = _storage.ref('uploads');
      print('✅ Uploads folder accessible');

      // Test 3: Lấy danh sách file
      print('📊 Listing files in uploads folder...');
      final ListResult result = await uploadsRef.listAll();
      print('📄 Found ${result.items.length} files');

      // Test 4: Hiển thị tên các file
      if (result.items.isNotEmpty) {
        print('📋 File list:');
        for (int i = 0; i < result.items.length; i++) {
          final file = result.items[i];
          print('  ${i + 1}. ${file.name} (${file.fullPath})');
        }
      } else {
        print('📭 No files found in uploads folder');
      }

      // Test 5: Kiểm tra thư mục con (nếu có)
      if (result.prefixes.isNotEmpty) {
        print('📁 Found ${result.prefixes.length} subfolders:');
        for (int i = 0; i < result.prefixes.length; i++) {
          final folder = result.prefixes[i];
          print('  ${i + 1}. ${folder.name} (${folder.fullPath})');
        }
      }

      print('✅ Firebase Storage test completed successfully');
    } catch (e) {
      print('❌ Firebase Storage test failed: $e');
      print('🔍 Error details:');
      print('  - Error type: ${e.runtimeType}');
      print('  - Error message: $e');

      // Kiểm tra loại lỗi cụ thể
      if (e.toString().contains('permission-denied')) {
        print('🚫 Permission denied - Check Firebase Security Rules');
      } else if (e.toString().contains('not-found')) {
        print('🔍 Folder not found - Check if uploads folder exists');
      } else if (e.toString().contains('unauthenticated')) {
        print('🔐 User not authenticated - Check Firebase Auth');
      } else if (e.toString().contains('network')) {
        print('🌐 Network error - Check internet connection');
      }
    }
  }

  /// Test tạo file test đơn giản
  static Future<void> testCreateFile() async {
    try {
      print('📝 Testing file creation...');

      // Tạo một file test đơn giản
      final testRef = _storage.ref('uploads/test_file.txt');
      final testData = 'This is a test file created at ${DateTime.now()}';
      final metadata = SettableMetadata(contentType: 'text/plain');

      await testRef.putString(testData,
          format: PutStringFormat.raw, metadata: metadata);
      print('✅ Test file created successfully');

      // Xóa file test
      await testRef.delete();
      print('🗑️ Test file deleted');
    } catch (e) {
      print('❌ File creation test failed: $e');
    }
  }

  /// Kiểm tra quyền truy cập
  static Future<void> checkPermissions() async {
    try {
      print('🔐 Checking Firebase Storage permissions...');

      // Kiểm tra quyền đọc
      final readRef = _storage.ref('uploads');
      await readRef.listAll();
      print('✅ Read permission: OK');

      // Kiểm tra quyền ghi (tạo file test)
      final writeRef = _storage.ref('uploads/permission_test.txt');
      await writeRef.putString('test', format: PutStringFormat.raw);
      print('✅ Write permission: OK');

      // Xóa file test
      await writeRef.delete();
      print('✅ Delete permission: OK');

      print('✅ All permissions check passed');
    } catch (e) {
      print('❌ Permission check failed: $e');
      if (e.toString().contains('permission-denied')) {
        print('🚫 Permission denied - Check Firebase Security Rules');
        print('💡 Make sure your security rules allow read/write access');
      }
    }
  }
}
