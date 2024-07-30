import 'package:crud_flutter_rest/models/product.dart';
import 'package:crud_flutter_rest/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductUpdateScreen extends StatefulWidget {
  const ProductUpdateScreen({super.key, required this.id});

  final String id;

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController(
    text: "https://loremflickr.com/640/480/animals",
  );
  TextEditingController descriptionController = TextEditingController(
    text: "Andy shoes are designed to keeping "
        "in mind durability as well as trends",
  );
  TextEditingController priceController = TextEditingController(text: "34.90");
  Future<Product>? futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = ProductService.fetchOne(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update Product'),
      ),
      body: buildFutureBuilder(),
    );
  }

  void initController(Product product) {
    titleController.text = product.title;
    imageController.text = product.image;
    descriptionController.text = product.description;
    priceController.text = product.price;
  }

  SingleChildScrollView buildLayout() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: inputTitle(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: inputImage(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: inputDescription(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: inputPrice(),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: buttonSave(),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  TextField inputTitle() {
    OutlineInputBorder outlineInputBorder =
        OutlineInputBorder(borderRadius: BorderRadius.circular(10));
    InputDecoration decoration = InputDecoration(
        helperText: "Please input your product title",
        labelText: "Title",
        border: outlineInputBorder);

    return TextField(
      controller: titleController,
      decoration: decoration,
    );
  }

  TextField inputImage() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    InputDecoration decoration = InputDecoration(
      helperText: "Please input image URL like https://...",
      labelText: "Image (url)",
      border: outlineInputBorder,
    );

    return TextField(
      keyboardType: TextInputType.url,
      controller: imageController,
      decoration: decoration,
    );
  }

  TextField inputDescription() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

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

  TextField inputPrice() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    InputDecoration decoration = InputDecoration(
      helperText: "Please input your product price",
      labelText: "Price",
      border: outlineInputBorder,
    );

    return TextField(
      keyboardType: TextInputType.number,
      controller: priceController,
      decoration: decoration,
    );
  }

  TextButton buttonSave() {
    return TextButton(
      onPressed: () {
        setState(() {
          futureProduct = ProductService.update(
            widget.id,
            titleController.text,
            imageController.text,
            priceController.text,
            descriptionController.text,
          );

          futureProduct?.whenComplete(() {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Success updating product"),
            ));
          });
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 30),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      child: Text("Save",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  FutureBuilder<Product> buildFutureBuilder() {
    return FutureBuilder<Product>(
        future: futureProduct,
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Product product = snapshot.data!;
              initController(product);
              return buildLayout();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
