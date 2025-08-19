import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/app/modules/store_detail/views/store_detail_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
   final controller = Get.put(HomeController() ,permanent: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Toko'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: ()  {
              controller.logout();
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.stores.isEmpty) {
          return const Center(
            child: Text('Tidak ada data toko', style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.stores.length,
          itemBuilder: (context, index) {
            final store = controller.stores[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: const Icon(Icons.store, size: 36, color:  Colors.blueAccent),
                title: Text(
                  store.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('${store.code} - ${store.address}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(
                    () => StoreDetailView(),
                    arguments: {
                      'id': store.id,
                      'name': store.name,
                      'address': store.address,
                    },
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
