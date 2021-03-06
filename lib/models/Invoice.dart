class Invoice {
  int id;
  int clientId;
  final String name;
  double total;
  double discount;
  int date;
  String dueDate;
  String dueOption;
  int companyId;
  String signature;
  String comment;

  Invoice({
    this.id,
    this.clientId,
    this.name,
    this.total,
    this.discount,
    this.date,
    this.dueDate,
    this.dueOption,
    this.companyId,
    this.signature,
    this.comment,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        id: json['id'],
        clientId: json['client_id'],
        name: json['name'],
        total: json['total'],
        discount: json['discount'],
        date: json['date'],
        dueDate: json['due_date'],
        dueOption: json['due_option'],
        companyId: json['company_id'],
        signature: json['signature'],
        comment: json['comment'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'name': name,
        'total': total,
        'discount': discount,
        'date': date,
        'due_date': dueDate,
        'due_option': dueOption,
        'company_id': companyId,
        'signature': signature,
        'comment': comment,
      };
}
