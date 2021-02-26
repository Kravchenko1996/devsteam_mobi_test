class Invoice {
  int id;
  int clientId;
  final String name;
  int total;

  static final columns = [
    "id",
    "client_id",
    "name",
    "total",
  ];

  Invoice({
    this.id,
    this.clientId,
    this.name,
    this.total,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        id: json['id'],
        clientId: json['client_id'],
        name: json['name'],
        total: json['total'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'name': name,
        'total': total,
      };
}
