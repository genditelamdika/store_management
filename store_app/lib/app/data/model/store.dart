class Store {
  final int id;
  final String name;
  final String code;
  final String address;

  Store({required this.id, required this.name, required this.code, required this.address});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'address': address};
  }
}
