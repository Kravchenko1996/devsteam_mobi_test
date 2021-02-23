class Invoice {
  int id;
  int clientId;
  final String name;
  static final columns = ["id", "client_id", "name"];

  Invoice({
    this.id,
    this.clientId,
    this.name,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        id: json['id'],
        clientId: json['client_id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'name': name,
      };
}
