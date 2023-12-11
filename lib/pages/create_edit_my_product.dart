import 'dart:io';
import 'package:best_buy/controller/my_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'my_pruduct_page.dart';

class ProductEditPage extends StatefulWidget {
  final Map? product;

  const ProductEditPage({Key? key, this.product}) : super(key: key);

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  MyProductController myProductController = Get.put(MyProductController());
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  File? image;

  @override
  void initState() {
    ProductEditPage();
    super.initState();
    myProductController.isLoading.value;
    myProductController.myProduct.value;
    myProductController.getMyProducts();
    // Initialize controllers with existing product data if available
    if (widget.product != null) {
      nameController.text = widget.product!['name'];
      priceController.text = widget.product!['price'].toString();
      priceController.text = widget.product!['stock_quantity'].toString();
      widget.product!['id'];
      // Initialize image if applicable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 350,
                        color: Colors.grey,
                        child: image == null
                            ? const Text("Select image")
                            : Center(
                                child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              )),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: getImage,
                  icon: const Center(child: Icon(Icons.image)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                fillColor: Colors.white70,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                filled: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                  labelText: 'Quantity',
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.to(MyProductPage());
                        },
                        child: Text("Cencel")),
                    TextButton(
                        onPressed: () async {
                          if (widget.product == null) {
                            await myProductController.createProductWithImage({
                              'name': nameController.text,
                              'price': double.parse(priceController.text),
                              "stock_quantity":
                                  double.parse(quantityController.text)
                            }, image);
                            Navigator.pop(context);
                          } else {
                            await myProductController.updateProduct(
                              widget.product!["id"],
                              {
                                'name': nameController.text,
                                'price': double.parse(priceController.text),
                                "stock_quantity":
                                    double.parse(quantityController.text)
                              },
                              image,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save")),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final picImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (picImage != null) {
        image = File(picImage.path);
      } else {
        print("You have no image");
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
