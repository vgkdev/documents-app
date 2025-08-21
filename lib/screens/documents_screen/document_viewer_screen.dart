import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../controllers/documents_controller.dart';
import '../../models/document_display.dart';

class DocumentViewerScreen extends StatelessWidget {
  final Reference ref;
  const DocumentViewerScreen({super.key, required this.ref});

  Future<DocumentDisplay> _prepare() async {
    final DocumentsController controller =
        Get.isRegistered<DocumentsController>()
            ? Get.find<DocumentsController>()
            : Get.put(DocumentsController());
    return await controller.buildDisplay(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ref.name)),
      body: FutureBuilder<DocumentDisplay>(
        future: _prepare(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Không có dữ liệu để hiển thị'));
          }
          if (data.error != null && data.error!.isNotEmpty) {
            return Center(child: Text(data.error!));
          }
          if (data.isPdf) {
            final url = data.pdfUrl ?? '';
            if (url.isEmpty) {
              return const Center(child: Text('Không lấy được URL PDF'));
            }
            return SfPdfViewer.network(
              url,
              onDocumentLoadFailed: (details) {
                Get.find<DocumentsController>().errorMessage.value =
                    'PDF load failed: \\n${details.error}';
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              (data.text ?? '').isEmpty
                  ? 'Không có nội dung hoặc không hỗ trợ định dạng này.'
                  : data.text!,
            ),
          );
        },
      ),
    );
  }
}
