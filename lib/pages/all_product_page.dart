import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_to_card_controller.dart';
import '../controller/product_controller.dart';
import '../widgets/product_gridview.dart';

class AllProductPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  AddToCartController addToCartController = Get.put(AddToCartController());
  ScrollController scrollController = ScrollController();

  AllProductPage() {
    // Constructor - Fetch data when the widget is created
    productController.getProducts();

    // loading new data when the user scrolls down
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        productController.loadMore();
        print("load more successful");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Products")),
      body: Obx(() {
        if (productController.isLoading.value &&
            productController.currentPage == 1) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GridView.builder(
            controller: scrollController,
            itemCount: productController.products.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) {
              if (index < productController.products.length) {
                var product = productController.products[index];
                return ProductGridView(
                    product: product, addToCartController: addToCartController);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
      }),
    );
  }
}
