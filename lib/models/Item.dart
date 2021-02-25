class Item {
  int id;
  int invoiceId;
  final String title;
  final int price;
  final int quantity;
  final int amount;
  static final columns = ["id", "title", "price", "quantity", "amount"];

  Item({
    this.id,
    this.invoiceId,
    this.title,
    this.price,
    this.quantity,
    this.amount,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json['id'],
        invoiceId: json['invoice_id'],
        title: json['title'],
        price: json['price'],
        quantity: json['quantity'],
        amount: json['amount'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoice_id': invoiceId,
        'title': title,
        'price': price,
        'quantity': quantity,
        'amount': amount,
      };
}
