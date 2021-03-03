class Invoice {
  int id;
  int clientId;
  final String name;
  double total;
  double discount;
  double balanceDue;

  Invoice({
    this.id,
    this.clientId,
    this.name,
    this.total,
    this.discount,
    this.balanceDue,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
      id: json['id'],
      clientId: json['client_id'],
      name: json['name'],
      total: json['total'],
      discount: json['discount'],
      balanceDue: json['balance_due']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'name': name,
        'total': total,
        'discount': discount,
        'balance_due': balanceDue,
      };
}
