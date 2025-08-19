class Product {
  final int id;
  final String name;
  final String barcode;
  final String volume;

  Product({required this.id, required this.name, required this.barcode, required this.volume});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      volume: json['volume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'barcode': barcode, 'volume': volume};
  }
}
