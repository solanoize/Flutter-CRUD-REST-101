import 'package:crud_flutter_rest/models/product.dart';
import 'package:crud_flutter_rest/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController(
    text: "https://loremflickr.com"
        "/640/480/animals",
  );
  TextEditingController descriptionController = TextEditingController(
    text: "Andy shoes are designed to keeping "
        "in mind durability as well as trends",
  );
  TextEditingController priceController = TextEditingController(text: "34.90");
  Future<Product>? futureProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Product'),
      ),
      body: (futureProduct == null) ? buildLayout() : buildFutureBuilder(),
    );
  }

  SingleChildScrollView buildLayout() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _title(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _image(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _description(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _price(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _save(),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  TextField _title() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );
    InputDecoration decoration = InputDecoration(
      helperText: "Please input your product title",
      labelText: "Title",
      border: outlineInputBorder,
    );

    return TextField(
      controller: titleController,
      decoration: decoration,
    );
  }

  TextField _image() {
    OutlineInputBorder outlineInputBorder =
        OutlineInputBorder(borderRadius: BorderRadius.circular(10));
    InputDecoration decoration = InputDecoration(
        helperText: "Please input image URL like https://...",
        labelText: "Image (url)",
        border: outlineInputBorder);

    return TextField(
      keyboardType: TextInputType.url,
      controller: imageController,
      decoration: decoration,
    );
  }

  TextField _description() {
    OutlineInputBorder outlineInputBorder =
        OutlineInputBorder(borderRadius: BorderRadius.circular(10));
    InputDecoration decoration = InputDecoration(
        alignLabelWithHint: true,
        labelText: "Description",
        helperText: "Please input your product description",
        border: outlineInputBorder);

    return TextField(
      maxLines: 4,
      controller: descriptionController,
      decoration: decoration,
    );
  }

  TextField _price() {
    OutlineInputBorder outlineInputBorder =
        OutlineInputBorder(borderRadius: BorderRadius.circular(10));
    InputDecoration decoration = InputDecoration(
        helperText: "Please input your product price",
        labelText: "Price",
        border: outlineInputBorder);

    return TextField(
      keyboardType: TextInputType.number,
      controller: priceController,
      decoration: decoration,
    );
  }

  TextButton _save() {
    return TextButton(
      onPressed: () async {
        setState(() {
          futureProduct = ProductService.create(
            titleController.text,
            imageController.text,
            priceController.text,
            descriptionController.text,
          );

          futureProduct?.then((Product product) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Success creating product"),
            ));
          });
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 30),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(
        "Save",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  FutureBuilder<Product> buildFutureBuilder() {
    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return buildLayout();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
