import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tech_comm/Admin/showorder.dart';
import 'package:tech_comm/Admin/updateproductscreen.dart';
import 'addnewproduct.dart';
import 'adminproduct.dart';
import 'adminmerchant.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  final AdminMerchant merc;

  const MainScreen({Key key, this.merc}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  double screenHeight, screenWidth;
  List productList;
  List cartList;
  String titlecenter = "Loading Products...";
  String type = "Products";

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
        body: Column(children: [
          Stack(
            children: [
              Opacity(
                opacity: 0.7,
                child: Container(
                    height: screenHeight / 4,
                    width: screenWidth / 0.3,
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://steadybongbibi.com/techcomm/images/merchantimages/${widget.merc.mercimage}.jpg",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(
                        Icons.broken_image,
                        size: screenWidth / 2,
                      ),
                    )),
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    children: [
                      Text(
                        "Merchant:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pinkAccent,
                              )
                            ]),
                      ),
                      Text(
                        widget.merc.mercname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.pinkAccent,
                              )
                            ]),
                      ),
                    ],
                  )),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(children: [
                        Tooltip(
                            message: 'New Product',
                            child: IconButton(
                              icon: Icon(Icons.add_business),
                              iconSize: 32,
                              onPressed: () {
                                _newProductScreen();
                              },
                            )),
                        Text(
                          "Add Product",
                          style: TextStyle(fontSize: 8),
                        ),
                      ]),
                      Column(children: [
                        Tooltip(
                            message: 'Show Orders',
                            child: IconButton(
                              icon: Icon(Icons.receipt_long_rounded),
                              iconSize: 32,
                              onPressed: () {
                                setState(() {
                                  _showOrder();
                                });
                              },
                            )),
                        Text(
                          "Orders",
                          style: TextStyle(fontSize: 8),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(children: [
                  Tooltip(
                      message: 'Log Out',
                      child: IconButton(
                        icon: Icon(Icons.exit_to_app),
                        iconSize: 32,
                        onPressed: () {
                          _logOut();
                        },
                      )),
                  Text(
                    "Log Out",
                    style: TextStyle(fontSize: 8),
                  ),
                ]),
              ],
            ))
          ]),
          Center(
              child: Container(
                  child: Text(
            "Your Current $type ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
          Divider(
            color: Colors.grey,
          ),
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
                ))))
              : Flexible(
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Color.fromRGBO(101, 255, 218, 50),
                      onRefresh: () async {
                        _loadProduct();
                      },
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.75,
                        children: List.generate(productList.length, (index) {
                          return Padding(
                            padding: EdgeInsets.all(3),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                                color: Colors.amberAccent,
                                child: InkWell(
                                  onTap: () => _loadProductDetails(index),
                                  onLongPress: () => _deleteFoodDialog(index),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            height: screenHeight / 5.5,
                                            width: screenWidth / 2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "http://steadybongbibi.com/techcomm/images/productimages/${productList[index]['productimg']}.jpg",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: screenWidth / 2,
                                              ),
                                            )),
                                        SizedBox(height: 5),
                                        Text(
                                          productList[index]['productname'] ??
                                              'Loading',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("RM " +
                                                productList[index]
                                                    ['productprice'] ??
                                            'Loading'),
                                        Text("Quantity: " +
                                                productList[index]
                                                    ['productqty'] ??
                                            'Loading'),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }),
                      )),
                )
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
          titlecenter = "No $type Available";
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

  _loadProductDetails(int index) async {
    Product product = new Product(
        productid: productList[index]['productid'],
        productname: productList[index]['productname'],
        productprice: productList[index]['productprice'],
        productqty: productList[index]['productqty'],
        productimg: productList[index]['productimg'],
        mercid: widget.merc.mercid);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateProductScreen(
                  product: product,
                )));
    _loadProduct();
  }

  Future<void> _newProductScreen() async {
    print(widget.merc.mercid);
    AdminMerchant merc = new AdminMerchant(mercid: widget.merc.mercid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddNewProduct(addmerc: merc)));
    _loadProduct();
  }

  void _logOut() {
    Navigator.of(context).pop();
  }

  _deleteFoodDialog(int index) {
    print("Delete " + productList[index]['productname']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete " + productList[index]['productname'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFood(index);
                _loadProduct();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFood(int index) {
    http.post("https://steadybongbibi.com/techcomm/php/delete_product.php",
        body: {
          "id": productList[index]['productid'],
          "image": productList[index]['productimg'],
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        _loadProduct();
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _showOrder() async {
    print(widget.merc.mercid);
    AdminMerchant merc = new AdminMerchant(mercid: widget.merc.mercid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShowOrder(order: merc)));
  }
}
