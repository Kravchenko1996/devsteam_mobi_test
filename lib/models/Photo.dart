class Photo {
  int id;
  String file;
  int invoiceId;

  Photo({
    this.id,
    this.file,
    this.invoiceId,
  });

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        id: json['id'],
        file: json['file'],
        invoiceId: json['invoice_id'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'file': file,
        'invoice_id': invoiceId,
      };
}
