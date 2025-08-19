
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:store_app/app/data/model/product.dart';
import 'package:store_app/app/modules/home/controllers/home_controller.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var productAvailability = <int, bool>{}.obs;
  late Map<String, dynamic> args;
  final controllerProduct = Get.find<HomeController>();


  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as Map<String, dynamic>;
    loadProductsFromHive();
  }

  void loadProductsFromHive() {
    var box = Hive.box('appData');
    final storedProducts = box.get('products', defaultValue: []);
    if (storedProducts is List) {
      products.value = storedProducts
          .where((e) => e != null)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      for (var p in products) {
        productAvailability[p.id] ??= false; 
      }
    }
  }

 

  void setProductAvailability(int productId, bool isAvailable) {
    productAvailability[productId] = isAvailable;

  }

  void addProductPending() {
    var box = Hive.box('PendingProductReport');

    final report = {
      "store_id": args['storeId'],
      "products": productAvailability.entries
          .map((e) => {'product_id': e.key, 'available': e.value})
          .toList(),
    };

    box.put('pendingProductStore${args['storeId']}', report);
    print(' Data laporan disimpan ke Hive (pendingProductReport): $report');
    controllerProduct.sendProductReport(true);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
