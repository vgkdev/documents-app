class DocumentDisplay {
  final String name;
  final bool isPdf;
  final String? pdfUrl;
  final String? text;
  final String? error;

  DocumentDisplay({
    required this.name,
    required this.isPdf,
    this.pdfUrl,
    this.text,
    this.error,
  });
}
