import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_to_text/docx_to_text.dart' show docxToText;
import '../models/document_display.dart';

class DocumentsController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxBool isLoading = false.obs;
  final RxList<Reference> files = <Reference>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final ListResult result = await _storage.ref('uploads').listAll();
      files.assignAll(result.items);
    } catch (e) {
      final String msg = 'fetchFiles thất bại: $e';
      errorMessage.value = msg;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getDownloadUrl(Reference ref) async {
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      final String msg = 'getDownloadUrl thất bại (${ref.fullPath}): $e';
      errorMessage.value = msg;
      rethrow;
    }
  }

  Future<String> extractTextFromRef(Reference ref) async {
    final String extension = ref.name.split('.').last.toLowerCase();
    try {
      if (extension == 'txt') {
        final Uint8List? data = await ref.getData(20 * 1024 * 1024);
        if (data == null) return '';
        return utf8.decode(data, allowMalformed: true);
      }
      if (extension == 'pdf') {
        final Uint8List? data = await ref.getData(20 * 1024 * 1024);
        if (data == null || data.isEmpty) return '';
        final PdfDocument document = PdfDocument(inputBytes: data);
        final PdfTextExtractor extractor = PdfTextExtractor(document);
        final String text = extractor.extractText();
        document.dispose();
        return text;
      }
      if (extension == 'docx') {
        final Uint8List? data = await ref.getData(20 * 1024 * 1024);
        if (data == null) return '';
        return docxToText(data);
      }
      return 'Định dạng .$extension chưa được hỗ trợ. Hãy dùng TXT/PDF/DOCX.';
    } catch (e) {
      final String msg = 'extractTextFromRef thất bại (${ref.fullPath}): $e';
      errorMessage.value = msg;
      return 'Lỗi đọc nội dung: $msg';
    }
  }

  Future<DocumentDisplay> buildDisplay(Reference ref) async {
    final String ext = ref.name.split('.').last.toLowerCase();
    try {
      if (ext == 'pdf') {
        final String url = await getDownloadUrl(ref);
        return DocumentDisplay(name: ref.name, isPdf: true, pdfUrl: url);
      }
      final String text = await extractTextFromRef(ref);
      return DocumentDisplay(name: ref.name, isPdf: false, text: text);
    } catch (e) {
      final String message = 'buildDisplay thất bại (${ref.fullPath}): $e';
      errorMessage.value = message;
      return DocumentDisplay(
          name: ref.name, isPdf: false, text: '', error: message);
    }
  }
}
