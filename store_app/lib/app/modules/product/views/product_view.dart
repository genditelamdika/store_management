import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/app/data/model/product.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  @override
  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:  Text(
          '📦 Daftar Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        elevation: 4,
      ),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada produk tersedia',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final Product product = controller.products[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Obx(() {
                final checked =
                    controller.productAvailability[product.id] ?? false;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    controller.setProductAvailability(product.id, !checked);
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header produk
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Checkbox custom
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: checked
                                      ?  Colors.green
                                      : Colors.transparent,
                                  border: Border.all(
                                    color:  Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: checked
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Volume: ${product.volume}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 12),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.grey[50],
                              padding: const EdgeInsets.all(6),
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: product.barcode,
                                width: double.infinity,
                                height: 60,
                                drawText: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        
        child: SizedBox(
          height: 55,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:  Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
            ),
            onPressed: ()  {
             controller.addProductPending();
            },
            icon: const Icon(Icons.send, size: 20),
            label: const Text(
              'Kirim Laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
