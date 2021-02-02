import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tech_comm/User/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'user.dart';

void main() => runApp(ProductScreenDetails());

class ProductScreenDetails extends StatefulWidget {
  final Product product;
  final User user;

  const ProductScreenDetails({Key key, this.product, this.user})
      : super(key: key);
  @override
  _ProductScreenDetailsState createState() => _ProductScreenDetailsState();
}

class _ProductScreenDetailsState extends State<ProductScreenDetails> {
  double screenHeight, screenWidth;
  List productList;
  String titlecenter = "Loading Product...";
  int selectedQty;
  final TextEditingController _remcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var productQty =
        Iterable<int>.generate(int.parse(widget.product.productqty) + 1)
            .toList();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.product.productname),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: screenHeight / 3,
                  width: screenWidth / 0.3,
                  child: CachedNetworkImage(
                      imageUrl:
                          "http://steadybongbibi.com/techcomm/images/productimages/${widget.product.productimg}.jpg",
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(
                            Icons.broken_image,
                            size: screenWidth / 3,
                          ))),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(children: [
                  SvgPicture.asset("assets/icons/Cart Icon.svg", height: 25),
                  SizedBox(width: 25),
                  Container(
                      height: 40,
                      child: DropdownButton(
                          hint: Text(
                            'Quantity',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: selectedQty,
                          onChanged: (newValue) {
                            setState(() {
                              selectedQty = newValue;
                              print(selectedQty);
                            });
                          },
                          items: productQty.map((selectedQty) {
                            return DropdownMenuItem(
                                child: new Text(selectedQty.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                value: selectedQty);
                          }).toList())),
                ]),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: TextFormField(
                  controller: _remcontroller,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    hintText: "Your Remark",
                    hintStyle: TextStyle(fontSize: (12)),
                    labelStyle: TextStyle(color: Color(0XFF8B8B8B)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 20,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Color(0XFF8B8B8B), width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                      gapPadding: 10,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        right: 25.0,
                      ),
                      child: SvgPicture.asset(
                          "assets/icons/Chat bubble Icon.svg",
                          height: 30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Text('Add to Cart', style: TextStyle(fontSize: (16))),
                color: Colors.amber,
                textColor: Colors.black,
                elevation: 10,
                onPressed: _openOrderDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Add " + widget.product.productname + " into cart?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity " + selectedQty.toString(),
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

                _orderProduct();
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

  void _orderProduct() {
    http.post("https://steadybongbibi.com/techcomm/php/insert_cart.php", body: {
      "email": widget.user.email,
      "productid": widget.product.productid,
      "productqty": selectedQty.toString(),
      "remarks": _remcontroller.text,
      "mercid": widget.product.mercid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
