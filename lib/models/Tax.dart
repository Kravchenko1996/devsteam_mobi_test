class Tax {
  int id;
  int invoiceId;
  String name;
  String type;
  double amount;
  int included;
  int itemId;

  Tax({
    this.id,
    this.invoiceId,
    this.name,
    this.type,
    this.amount,
    this.included,
    this.itemId,
  });

  factory Tax.fromMap(Map<String, dynamic> json) => Tax(
        id: json['id'],
        invoiceId: json['invoice_id'],
        name: json['name'],
        type: json['type'],
        amount: json['amount'],
        included: json['included'],
        itemId: json['item_id'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoice_id': invoiceId,
        'name': name,
        'type': type,
        'amount': amount,
        'included': included,
        'item_id': itemId,
      };
}
