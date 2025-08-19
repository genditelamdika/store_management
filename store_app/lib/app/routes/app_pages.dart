import 'package:get/get.dart';

import '../modules/attedance/bindings/attedance_binding.dart';
import '../modules/attedance/views/attedance_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/store_detail/bindings/store_detail_binding.dart';
import '../modules/store_detail/views/store_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ATTEDANCE,
      page: () => AttedanceView(),
      binding: AttedanceBinding(),
    ),
    GetPage(
      name: _Paths.STORE_DETAIL,
      page: () => StoreDetailView(),
      binding: StoreDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () =>  ProductView(),
      binding: ProductBinding(),
    ),
  ];
}
