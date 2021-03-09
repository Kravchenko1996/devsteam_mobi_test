class Invoice {
  int id;
  int clientId;
  final String name;
  double total;
  double discount;
  int date;

  Invoice({
    this.id,
    this.clientId,
    this.name,
    this.total,
    this.discount,
    this.date,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
      id: json['id'],
      clientId: json['client_id'],
      name: json['name'],
      total: json['total'],
      discount: json['discount'],
      date: json['date']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'name': name,
        'total': total,
        'discount': discount,
        'date': date,
      };
}
