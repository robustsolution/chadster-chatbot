import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String id;
  String docId;
  String title;
  String imageUrl;
  Category({
    required this.id,
    required this.docId,
    required this.title,
    required this.imageUrl,
  });

  // String toJson() => json.encode(toMap());

  // factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Categories {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Future<List<Category>> fetchAndSetCats() async {
    var cats = FirebaseFirestore.instance
        .collection('categories')
        .orderBy("order", descending: false);
    QuerySnapshot response = await cats.get();
    response.docs.forEach((doc) {
      _categories.add(Category(
          docId: doc.id,
          id: doc['category_id'].toString(),
          title: doc['name'],
          imageUrl: doc['category_image_url']));
    });
    log('total cats: ${_categories.length}');
    return _categories;
  }
}
