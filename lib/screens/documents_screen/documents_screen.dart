import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../controllers/documents_controller.dart';
import 'document_viewer_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DocumentsController>(
      init: DocumentsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Documents'),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.isNotEmpty) {
              return Center(
                  child: Text('Error: ${controller.errorMessage.value}'));
            }
            if (controller.files.isEmpty) {
              return const Center(child: Text('No documents found'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.files.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final Reference ref = controller.files[index];
                final String name = ref.name;
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file_outlined),
                  title: Text(name),
                  subtitle: Text(ref.fullPath),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final url = await controller.getDownloadUrl(ref);
                      Get.snackbar('Download URL', url,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 4));
                    },
                  ),
                  onTap: () {
                    Get.to(() => DocumentViewerScreen(ref: ref));
                  },
                );
              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.fetchFiles();
            },
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}
