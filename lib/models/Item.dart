class Item {
  int id;
  int invoiceId;
  final String title;
  final double price;
  final double quantity;
  final double amount;
  int taxable;

  Item({
    this.id,
    this.invoiceId,
    this.title,
    this.price,
    this.quantity,
    this.amount,
    this.taxable,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json['id'],
        invoiceId: json['invoice_id'],
        title: json['title'],
        price: json['price'],
        quantity: json['quantity'],
        amount: json['amount'],
        taxable: json['taxable'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoice_id': invoiceId,
        'title': title,
        'price': price,
        'quantity': quantity,
        'amount': amount,
        'taxable': taxable,
      };
}
