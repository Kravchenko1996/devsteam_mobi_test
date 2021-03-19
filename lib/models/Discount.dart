class Discount {
  int id;
  int invoiceId;
  final int itemId;
  final double percentage;
  final double amount;
  final int isPercentageLast;

  Discount({
    this.id,
    this.invoiceId,
    this.itemId,
    this.percentage,
    this.amount,
    this.isPercentageLast,
  });

  factory Discount.fromMap(Map<String, dynamic> json) => Discount(
        id: json['id'],
        invoiceId: json['invoice_id'],
        itemId: json['item_id'],
        percentage: json['percentage'],
        amount: json['amount'],
        isPercentageLast: json['is_percentage_last'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoice_id': invoiceId,
        'item_id': itemId,
        'percentage': percentage,
        'amount': amount,
        'is_percentage_last': isPercentageLast,
      };
}
