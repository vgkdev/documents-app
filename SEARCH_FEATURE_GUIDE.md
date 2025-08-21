# 🔍 Search Feature Guide - Documents App

## 📋 **Tổng quan tính năng Search**

Tính năng Search đã được nâng cấp hoàn toàn để cung cấp trải nghiệm tìm kiếm file mạnh mẽ và thông minh. Người dùng có thể tìm kiếm file theo tên, đường dẫn, loại file và sử dụng các bộ lọc nâng cao.

## 🚀 **Tính năng chính**

### 1. **Tìm kiếm thông minh**

- ✅ **Real-time search** - Tìm kiếm ngay khi gõ
- ✅ **Debounce search** - Tối ưu hiệu suất (500ms delay)
- ✅ **Fuzzy matching** - Tìm kiếm tương tự
- ✅ **Multi-field search** - Tìm theo tên file, đường dẫn, extension

### 2. **Bộ lọc nâng cao**

- ✅ **Filter theo loại file:**
  - 📄 PDF
  - 📝 Word (DOCX/DOC)
  - 📄 Text (TXT)
  - 🖼️ Hình ảnh (JPG/PNG/GIF)
  - 📊 Excel (XLSX/XLS)
  - 📊 PowerPoint (PPTX/PPT)
  - 🌐 Tất cả loại file

### 3. **Lịch sử tìm kiếm**

- ✅ **Lưu trữ 10 từ khóa gần nhất**
- ✅ **Tap để tìm kiếm lại**
- ✅ **Xóa từng item hoặc tất cả**
- ✅ **Giao diện thân thiện**

### 4. **Gợi ý tìm kiếm**

- ✅ **Chip gợi ý** cho từ khóa phổ biến
- ✅ **Tap để tìm kiếm nhanh**
- ✅ **Từ khóa mặc định:** pdf, document, image, report

## 🛠️ **Cách sử dụng**

### **Bước 1: Mở Search Screen**

- Tap vào search bar trên Home Screen
- Hoặc sử dụng navigation để mở Search Screen

### **Bước 2: Nhập từ khóa**

- Gõ từ khóa vào search bar
- Kết quả sẽ hiển thị tự động sau 500ms
- Sử dụng nút clear (×) để xóa từ khóa

### **Bước 3: Sử dụng bộ lọc**

- Tap nút filter (🔽) trên AppBar
- Chọn loại file muốn tìm kiếm
- Filter chip sẽ hiển thị và có thể xóa

### **Bước 4: Xem kết quả**

- Kết quả hiển thị dưới dạng card list
- Tap vào file để mở và xem
- Sử dụng nút refresh để cập nhật

## 🔧 **Kiến trúc kỹ thuật**

### **SearchController** (`lib/controllers/search_controller.dart`)

```dart
class SearchController extends GetxController {
  // Search state
  final RxString searchQuery = ''.obs;
  final RxList<Reference> searchResults = <Reference>[].obs;
  final RxBool isSearching = false.obs;

  // Filter options
  final RxString selectedFileType = 'all'.obs;

  // Search history
  final RxList<String> searchHistory = <String>[].obs;

  // All files cache
  final RxList<Reference> allFiles = <Reference>[].obs;
}
```

### **CustomSearchBar** (`lib/widgets/custom_search_bar.dart`)

```dart
class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function() onClear;
  final Duration debounceDuration;
  final bool autoFocus;
}
```

### **SearchScreen** (`lib/screens/search_screen/search_screen.dart`)

- Sử dụng GetX để quản lý state
- Hiển thị kết quả tìm kiếm
- Xử lý các trạng thái khác nhau

## 📊 **Các trạng thái hiển thị**

### 1. **Initial State**

- Hiển thị lịch sử tìm kiếm (nếu có)
- Hiển thị gợi ý tìm kiếm (nếu không có lịch sử)
- Giao diện thân thiện và hướng dẫn

### 2. **Loading State**

- CircularProgressIndicator
- Text "Đang tìm kiếm..."
- Giao diện loading rõ ràng

### 3. **Search Results**

- Header hiển thị số lượng kết quả
- List các file tìm thấy
- Mỗi file hiển thị icon, tên, đường dẫn, loại

### 4. **No Results**

- Icon search_off
- Thông báo không tìm thấy kết quả
- Gợi ý cải thiện tìm kiếm

### 5. **Error State**

- Icon error_outline
- Thông báo lỗi cụ thể
- Nút "Thử lại" để refresh

## 🔍 **Thuật toán tìm kiếm**

### **1. Tìm kiếm chính xác**

```dart
// Tìm theo tên file
if (fileName.contains(lowerQuery)) {
  results.add(file);
  continue;
}

// Tìm theo đường dẫn
if (filePath.contains(lowerQuery)) {
  results.add(file);
  continue;
}

// Tìm theo extension
if (extension.contains(lowerQuery)) {
  results.add(file);
  continue;
}
```

### **2. Fuzzy Matching**

```dart
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
```

### **3. Sắp xếp kết quả**

- Ưu tiên file có tên bắt đầu bằng query
- Sắp xếp theo thứ tự alphabet
- Hiển thị kết quả có độ chính xác cao nhất trước

## 🎨 **Giao diện người dùng**

### **Search Bar**

- Thiết kế modern với shadow
- Icon search và clear button
- Border radius 20px
- Focus state với màu xanh

### **Filter Button**

- PopupMenuButton với icon filter_list
- Danh sách các loại file
- Hiển thị filter chip khi được chọn

### **Search Results**

- Card design với margin và padding
- Icon theo loại file với màu sắc
- Thông tin file đầy đủ
- Tap để mở file

### **Search History**

- ListTile với icon history
- Nút xóa từng item
- Tap để tìm kiếm lại

## 📱 **Responsive Design**

- **Mobile-first approach**
- **Adaptive layout** cho các kích thước màn hình
- **Touch-friendly** với kích thước button phù hợp
- **Scroll behavior** mượt mà

## 🚀 **Performance Optimization**

### **1. Debounce Search**

```dart
_debounceTimer?.cancel();
_debounceTimer = Timer(widget.debounceDuration, () {
  if (mounted) {
    widget.onSearch(widget.controller.text);
  }
});
```

### **2. File Caching**

- Load tất cả file một lần khi khởi tạo
- Tìm kiếm trong cache thay vì gọi Firebase
- Refresh cache khi cần thiết

### **3. Lazy Loading**

- Chỉ tải dữ liệu khi cần
- Sử dụng GetX để quản lý state hiệu quả
- Dispose resources khi không cần thiết

## 🔧 **Cách mở rộng**

### **Thêm loại file mới**

```dart
case 'new_type':
  return ['ext1', 'ext2'].contains(extension);
```

### **Thêm thuật toán tìm kiếm**

```dart
// Trong _searchInFiles method
if (_newSearchAlgorithm(fileName, lowerQuery)) {
  results.add(file);
}
```

### **Thêm filter mới**

```dart
// Trong PopupMenuButton
const PopupMenuItem(
  value: 'new_filter',
  child: Text('Tên filter mới'),
),
```

## 🧪 **Testing**

### **Test Cases**

1. **Tìm kiếm cơ bản**

   - Nhập từ khóa đơn giản
   - Kiểm tra kết quả hiển thị

2. **Filter theo loại file**

   - Chọn filter khác nhau
   - Kiểm tra kết quả được lọc

3. **Lịch sử tìm kiếm**

   - Thực hiện nhiều lần tìm kiếm
   - Kiểm tra lịch sử được lưu

4. **Error handling**
   - Kiểm tra xử lý lỗi mạng
   - Kiểm tra xử lý lỗi Firebase

## 📞 **Hỗ trợ và báo cáo lỗi**

Nếu gặp vấn đề với tính năng search:

1. **Kiểm tra console** để xem log messages
2. **Kiểm tra kết nối mạng**
3. **Kiểm tra Firebase Storage permissions**
4. **Cung cấp thông tin:**
   - Từ khóa tìm kiếm
   - Loại file filter
   - Error message cụ thể
   - Screenshot lỗi

## 🎯 **Kết quả mong đợi**

Sau khi implement, Search Screen sẽ:

- ✅ Tìm kiếm file nhanh chóng và chính xác
- ✅ Hỗ trợ nhiều loại filter
- ✅ Lưu trữ lịch sử tìm kiếm
- ✅ Giao diện đẹp mắt và dễ sử dụng
- ✅ Performance tối ưu với debounce và caching
- ✅ Xử lý lỗi và edge cases đầy đủ
