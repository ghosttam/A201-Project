import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tech_comm/User/product.dart';
import 'package:tech_comm/User/productscreendetails.dart';
import 'merchant.dart';
import 'package:http/http.dart' as http;

import 'user.dart';

class MercScreenDetails extends StatefulWidget {
  final Merchant merc;
  final User user;
  const MercScreenDetails({Key key, this.merc, this.user}) : super(key: key);
  @override
  _MercScreenDetailsState createState() => _MercScreenDetailsState();
}

class _MercScreenDetailsState extends State<MercScreenDetails> {
  double screenHeight, screenWidth;
  List productList;
  String titlecenter = "Loading Product...";

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.merc.mercname),
        ),
        body: Column(children: [
          Container(
              height: screenHeight / 4,
              width: screenWidth / 0.3,
              child: CachedNetworkImage(
                  imageUrl:
                      "http://steadybongbibi.com/techcomm/images/merchantimages/${widget.merc.mercimage}.jpg",
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(
                        Icons.broken_image,
                        size: screenWidth / 3,
                      ))),
          productList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                  child: Text(
                    titlecenter,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                )))
              : Flexible(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.75,
                      children: List.generate(productList.length, (index) {
                        return Padding(
                          padding: EdgeInsets.all(1),
                          child: FlipCard(
                            direction: FlipDirection.HORIZONTAL,
                            front: Column(children: [
                              Container(
                                  height: screenHeight / 5.5,
                                  width: screenWidth / 2,
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          "http://steadybongbibi.com/techcomm/images/productimages/${productList[index]['productimg']}.jpg",
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 3,
                                          ))),
                              Text(productList[index]['productname'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("RM " + productList[index]['productprice']),
                              Text("Quantity: " +
                                  productList[index]['productqty']),
                            ]),
                            back: Card(
                              child: Container(
                                height: 50,
                                child: FractionallySizedBox(
                                  heightFactor: 0.2,
                                  widthFactor: 0.8,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Center(
                                      child: Text('View Product',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    textColor: Colors.black,
                                    elevation: 10,
                                    color: Colors.amber,
                                    onPressed: () => _loadProductDetails(index),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }))),
        ]),
      ),
    );
  }

  void _loadProduct() {
    http.post("https://steadybongbibi.com/techcomm/php/load_product.php",
        body: {
          "mercid": widget.merc.mercid,
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        productList = null;
        setState(() {
          titlecenter = "No Product Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          productList = jsondata["product"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadProductDetails(int index) {
    Product curproduct = new Product(
        productid: productList[index]['productid'],
        productname: productList[index]['productname'],
        productprice: productList[index]['productprice'],
        productqty: productList[index]['productqty'],
        productimg: productList[index]['productimg'],
        mercid: widget.merc.mercid);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductScreenDetails(product: curproduct, user: widget.user)));
  }
}
