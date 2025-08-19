import 'package:store_app/app/data/model/product.dart';

class Promo {
  Product product;
  double normalPrice;
  double promoPrice;

  Promo({
    required this.product,
    required this.normalPrice,
    required this.promoPrice,
  });
  Map<String, dynamic> toJson() {
    return {
      "product": product.toJson(),
      "normalPrice": normalPrice,
      "promoPrice": promoPrice,
    };
  }

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      product: Product.fromJson(Map<String, dynamic>.from(json["product"])),
      normalPrice: (json["normalPrice"] as num).toDouble(),
      promoPrice: (json["promoPrice"] as num).toDouble(),
    );
  }
}