import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm...',
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
