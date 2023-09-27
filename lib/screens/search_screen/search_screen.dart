import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchBar(
              controller: _searchController,
              onSubmitted: () {},
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Số lượng kết quả tìm kiếm (có thể là động)
              itemBuilder: (context, index) {
                // Hiển thị các kết quả tìm kiếm
                // Ví dụ: Hiển thị danh sách tìm kiếm được
                return ListTile(
                  title: Text('Result ${index + 1}'),
                  subtitle: Text('Description of result ${index + 1}'),
                  onTap: () {
                    // Xử lý khi ấn vào kết quả tìm kiếm
                    // Ví dụ: Mở trang chi tiết của kết quả tìm kiếm
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
