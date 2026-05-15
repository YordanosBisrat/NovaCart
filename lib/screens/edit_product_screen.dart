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
  final _formKey = GlobalKey<FormState>();

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

    if (!_formKey.currentState!.validate()) {
      return;
    }

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
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an image URL";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: provider.isLoading ? null : updateProduct,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Update Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
