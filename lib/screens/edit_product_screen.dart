import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.product.title);

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    imageController = TextEditingController(text: widget.product.image);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateProduct() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    final updatedData = {
      "title": titleController.text,
      "price": double.tryParse(priceController.text) ?? 0,
      "description": descriptionController.text,
      "image": imageController.text,
    };

    await provider.updateProduct(widget.product.id, updatedData);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),

              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),

              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: updateProduct,
                child: const Text("Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
