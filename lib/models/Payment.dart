class Payment {
  int id;
  int invoiceId;
  final String method;
  final double amount;

  Payment({
    this.id,
    this.invoiceId,
    this.method,
    this.amount,
  });

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        id: json['id'],
        invoiceId: json['invoice_id'],
        method: json['method'],
        amount: json['amount'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'invoice_id': invoiceId,
        'method': method,
        'amount': amount,
      };
}
