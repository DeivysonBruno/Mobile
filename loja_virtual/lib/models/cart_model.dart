import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  String couponCode;
  int discountPercentage = 0;

  List<CartProduct> products = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItem();
    }
  }

  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();
    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection('user')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection('user')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItem() async {
    QuerySnapshot query = await Firestore.instance
        .collection('user')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;

    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) {
      return null;
    }
    isLoading = true;
    notifyListeners();

   DocumentReference refOrder = await  Firestore.instance.collection('orders').add(
      {
        "clientId": user.firebaseUser.uid,
        "products": products.map((cartProducts)=> cartProducts.toMap()).toList(),
        "shipPrice": getShipPrice(),
        "productsPrice": getProductsPrice(),
        "discount": getDiscount(),
        "total": getShipPrice()+getProductsPrice()-getDiscount(),
        "status": 1
      }
    );
   Firestore.instance.collection('user').document(user.firebaseUser.uid)
    .collection('orders').document(refOrder.documentID).setData({
     "orderId": refOrder.documentID
   });

   QuerySnapshot query = await Firestore.instance.collection('user').document(user.firebaseUser.uid)
    .collection('cart').getDocuments();

   for(DocumentSnapshot doc in query.documents){
     doc.reference.delete();
   }

   products.clear();
   couponCode = null;
   discountPercentage =0;

   isLoading = false;
   notifyListeners();

   return refOrder.documentID;
  }
}
