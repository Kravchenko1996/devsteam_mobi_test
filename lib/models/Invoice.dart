import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Item.dart';

class Invoice {
  final String name;
  final Client client;
  final Item item;

  Invoice({
    this.name,
    this.client,
    this.item,
  });

  factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        name: json['name'],
        client: json['client'],
        item: json['item'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'client': client,
        'item': item,
      };
}
