import 'package:crud_flutter_rest/models/product.dart';
import 'package:crud_flutter_rest/screens/product_create_screen.dart';
import 'package:crud_flutter_rest/screens/product_update_screen.dart';
import 'package:crud_flutter_rest/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Products'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        tooltip: 'New',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductCreateScreen();
          }));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: buildFutureBuilder(),
    );
  }

  FutureBuilder<List<Product>> buildFutureBuilder() {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return buildLayout(products: products);
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  ElevatedButton(onPressed: onRefresh, child: Text("Refresh"))
                ],
              ),
            );
          }
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  RefreshIndicator buildLayout({required List<Product> products}) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: textFieldSearch(),
            ),
            SizedBox(height: 32),
            Expanded(child: productList(products))
          ],
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    setState(() {
      futureProducts = ProductService.fetchAll();
    });
  }

  TextField textFieldSearch() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    IconButton iconButton = IconButton(
      onPressed: () {
        setState(() {
          futureProducts =
              ProductService.search({"search": searchController.text});
        });
      },
      icon: Icon(Icons.search),
    );

    InputDecoration decoration = InputDecoration(
      labelText: "Search",
      border: outlineInputBorder,
      suffixIcon: iconButton,
    );

    return TextField(
      controller: searchController,
      decoration: decoration,
    );
  }

  ListView productList(List<Product> products) {
    return ListView.separated(
      itemBuilder: (BuildContext build, int index) {
        return productDetail(products[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: products.length,
    );
  }

  ListTile productDetail(Product product) {
    return ListTile(
      title: Text(product.title),
      subtitle: Text(product.description),
      trailing: Text(product.price),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductUpdateScreen(id: product.id);
        }));
      },
    );
  }
}
