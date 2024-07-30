import 'dart:convert';

import 'package:crud_flutter_rest/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static String url = "https://66a5de6523b29e17a1a123c0.mockapi.io";

  static Future<List<Product>> fetchAll() async {
    final response = await http
        .get(Uri.parse('$url/products'))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((product) => Product.fromJson(product as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load products. ${response.statusCode}");
    }
  }

  static Future<Product> fetchOne(String id) async {
    final response = await http
        .get(Uri.parse('$url/products/$id'))
        .timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load product. ${response.statusCode}");
    }
  }

  static Future<List<Product>> search(Map<String, String> query) async {
    final response = await http
        .get(Uri.parse('$url/products').replace(queryParameters: query))
        .timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((product) => Product.fromJson(product as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load products. ${response.statusCode}");
    }
  }

  static Future<Product> create(
      String title, String image, String price, String description) async {
    Map<String, String> headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };

    String payload = jsonEncode(<String, dynamic>{
      "title": title,
      "image": image,
      "price": price,
      "description": description
    });

    final response = await http
        .post(Uri.parse("$url/products"), headers: headers, body: payload)
        .timeout(Duration(seconds: 20));

    if (response.statusCode == 201) {
      return Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create product. ${response.statusCode}');
    }
  }

  static Future<Product> update(String id, String title, String image,
      String price, String description) async {
    Map<String, String> headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };

    String payload = jsonEncode(<String, dynamic>{
      "title": title,
      "image": image,
      "price": price,
      "description": description
    });

    final response = await http
        .put(Uri.parse("$url/products/$id"), headers: headers, body: payload)
        .timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create product. ${response.statusCode}');
    }
  }
}
