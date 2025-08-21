import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function() onClear;
  final String hintText;
  final bool showClearButton;
  final bool autoFocus;
  final Duration debounceDuration;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onClear = _defaultOnClear,
    this.hintText = 'Tìm kiếm...',
    this.showClearButton = true,
    this.autoFocus = false,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  static void _defaultOnClear() {}

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  Timer? _debounceTimer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _hasText = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final bool hasText = widget.controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    // Debounce search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted) {
        widget.onSearch(widget.controller.text);
      }
    });
  }

  void _onClear() {
    widget.controller.clear();
    widget.onClear();
    setState(() {
      _hasText = false;
    });
  }

  void _onSubmitted(String value) {
    _debounceTimer?.cancel();
    widget.onSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autoFocus,
        onSubmitted: _onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 24,
          ),
          suffixIcon: widget.showClearButton && _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: _onClear,
                  tooltip: 'Xóa',
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.blue[400]!,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        inputFormatters: [
          // Giới hạn độ dài tìm kiếm
          LengthLimitingTextInputFormatter(100),
        ],
      ),
    );
  }
}
