# 🐛 Debug Guide - Home Screen "Chưa có dữ liệu"

## 🔍 **Vấn đề hiện tại:**

Home Screen hiển thị "Chưa có dữ liệu" thay vì danh sách tài liệu từ Firebase Storage.

## 🛠️ **Các bước debug đã thực hiện:**

### 1. **Thêm logging vào HomeController**

- ✅ Thêm `print()` statements để theo dõi luồng thực thi
- ✅ Log trạng thái của các biến quan sát
- ✅ Log số lượng file tìm thấy trong Firebase Storage

### 2. **Thêm Debug UI vào HomeScreen**

- ✅ Nút `🐛` (bug_report) để gọi `controller.debugStatus()`
- ✅ Nút `☁️` (cloud_upload) để test Firebase Storage
- ✅ Widget Debug Info hiển thị trạng thái real-time (chỉ trong debug mode)

### 3. **Tạo FirebaseTest utility**

- ✅ `testFirebaseConnection()` - Kiểm tra kết nối Firebase Storage
- ✅ `checkPermissions()` - Kiểm tra quyền truy cập
- ✅ `testCreateFile()` - Test tạo file

## 🚀 **Cách sử dụng để debug:**

### **Bước 1: Chạy ứng dụng và kiểm tra console**

1. Chạy app trong debug mode
2. Mở Home Screen
3. Kiểm tra console output để xem các log messages

### **Bước 2: Sử dụng nút Debug trên AppBar**

1. Tap nút `🐛` (bug_report) - sẽ hiển thị thông tin debug
2. Tap nút `☁️` (cloud_upload) - sẽ test Firebase Storage
3. Kiểm tra console để xem kết quả

### **Bước 3: Kiểm tra Debug Info widget**

Widget màu xanh sẽ hiển thị:

- Loading state
- Error messages
- Số lượng documents trong mỗi danh mục
- Tổng số documents

## 🔍 **Các nguyên nhân có thể:**

### 1. **Vấn đề đăng nhập**

```
🔐 isLogin value: false
```

- User chưa đăng nhập
- `Preferences.isLogin` trả về `false`
- Cần kiểm tra login flow

### 2. **Vấn đề Firebase Storage**

```
❌ Error in fetchHomeDocuments: [error message]
```

- Không có quyền truy cập thư mục `uploads`
- Thư mục `uploads` không tồn tại
- Vấn đề về Firebase Security Rules

### 3. **Vấn đề kết nối mạng**

```
❌ Firebase Storage test failed: [network error]
```

- Không có internet
- Firebase project chưa được cấu hình đúng
- Vấn đề về Firebase configuration

### 4. **Thư mục uploads trống**

```
📭 No files found in Firebase Storage
```

- Thư mục `uploads` tồn tại nhưng không có file nào
- Cần upload một số file test

## 🧪 **Test cases để thực hiện:**

### **Test 1: Kiểm tra đăng nhập**

1. Đăng nhập vào app
2. Kiểm tra console: `🔐 isLogin value: true`
3. Kiểm tra Debug Info widget

### **Test 2: Kiểm tra Firebase Storage**

1. Tap nút `☁️` (cloud_upload)
2. Kiểm tra console output
3. Xem có lỗi gì không

### **Test 3: Kiểm tra quyền truy cập**

1. Tap nút `☁️` (cloud_upload)
2. Nếu có lỗi permission, kiểm tra Firebase Security Rules

### **Test 4: Upload file test**

1. Vào Documents Screen
2. Upload một file test
3. Quay lại Home Screen
4. Kiểm tra xem có hiển thị file không

## 🔧 **Cách khắc phục:**

### **Nếu vấn đề là đăng nhập:**

1. Kiểm tra login flow
2. Kiểm tra `Preferences.isLogin` value
3. Đảm bảo user đã đăng nhập thành công

### **Nếu vấn đề là Firebase Storage:**

1. Kiểm tra Firebase project configuration
2. Kiểm tra Firebase Security Rules
3. Đảm bảo thư mục `uploads` tồn tại

### **Nếu vấn đề là quyền truy cập:**

1. Kiểm tra Firebase Security Rules
2. Đảm bảo rules cho phép read access
3. Kiểm tra user authentication

### **Nếu thư mục uploads trống:**

1. Upload một số file test
2. Kiểm tra xem Home Screen có hiển thị không
3. Kiểm tra Documents Screen có hiển thị file không

## 📊 **Expected Output khi hoạt động đúng:**

```
🔄 HomeController.onInit() called
🔐 isLogin value: true
📁 fetchHomeDocuments() called
🔍 Accessing Firebase Storage...
📊 Found 3 files in Firebase Storage
📄 File 0: document1.pdf (uploads/document1.pdf)
📄 File 1: document2.docx (uploads/document2.docx)
📄 File 2: document3.txt (uploads/document3.txt)
🆕 New documents: 3
✅ Documents loaded successfully
📊 Summary: New=3, Recent=0, Popular=0
🏁 fetchHomeDocuments completed. Loading: false, Error:
```

## 🚨 **Nếu vẫn có vấn đề:**

1. **Kiểm tra Firebase Console:**

   - Storage > Rules
   - Storage > Files
   - Authentication > Users

2. **Kiểm tra app configuration:**

   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
   - Firebase initialization trong `main.dart`

3. **Kiểm tra network:**
   - Internet connection
   - Firebase project status
   - App permissions

## 📞 **Cần hỗ trợ thêm:**

Nếu vẫn không thể giải quyết, hãy cung cấp:

1. Console output từ các test trên
2. Screenshot của Debug Info widget
3. Firebase project configuration
4. Error messages cụ thể
