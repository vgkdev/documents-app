import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../screens/documents_screen/document_viewer_screen.dart';

class DocumentCard extends StatelessWidget {
  final Reference documentRef;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.documentRef,
    this.width = 120,
    this.height = 150,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String fileName = documentRef.name;
    final String extension = _getFileExtension(fileName);

    return GestureDetector(
      onTap: onTap ??
          () {
            // Mở tài liệu để xem
            Get.to(() => DocumentViewerScreen(ref: documentRef));
          },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon theo loại file
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getFileColor(extension).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileIcon(extension),
                size: 32,
                color: _getFileColor(extension),
              ),
            ),
            const SizedBox(height: 12),

            // Tên file (cắt ngắn nếu quá dài)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _getShortFileName(fileName),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // Extension
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getFileColor(extension).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                extension.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: _getFileColor(extension),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  String _getShortFileName(String fileName) {
    if (fileName.length <= 15) return fileName;
    return '${fileName.substring(0, 15)}...';
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
      case 'doc':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'xlsx':
      case 'xls':
        return Icons.table_chart;
      case 'pptx':
      case 'ppt':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red[600]!;
      case 'docx':
      case 'doc':
        return Colors.blue[600]!;
      case 'txt':
        return Colors.green[600]!;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.orange[600]!;
      case 'xlsx':
      case 'xls':
        return Colors.green[700]!;
      case 'pptx':
      case 'ppt':
        return Colors.orange[700]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
