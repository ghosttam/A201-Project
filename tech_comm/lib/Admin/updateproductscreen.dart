import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_comm/Admin/adminproduct.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(UpdateProductScreen());

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  const UpdateProductScreen({Key key, this.product}) : super(key: key);
  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _qtycontroller = TextEditingController();

  String _name = "";
  String _price = "";
  String _qty = "";
  double screenHeight, screenWidth;

  String pathAsset = 'assets/images/camera.png';

  @override
  void initState() {
    super.initState();
    _namecontroller.text = (widget.product.productname);
    _pricecontroller.text = (widget.product.productprice);
    _qtycontroller.text = (widget.product.productqty);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Product'),
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                          // onTap: () => {_onPictureSelection()},
                          child: CachedNetworkImage(
                        imageUrl:
                            "http://steadybongbibi.com/techcomm/images/productimages/${widget.product.productimg}.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          Icons.broken_image,
                          size: screenWidth / 2,
                        ),
                      )),
                      SizedBox(height: 5),
                      // Text("Click image to take food picture",
                      //     style: TextStyle(fontSize: 10.0, color: Colors.black)),
                      SizedBox(height: 5),

                      IntrinsicHeight(
                        child: TextField(
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: _namecontroller,
                            decoration: InputDecoration(
                                labelText: 'Product Name',
                                hintText: 'Enter product name',
                                icon: Icon(Icons.chrome_reader_mode_rounded))),
                      ),
                      IntrinsicHeight(
                        child: TextField(
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: _pricecontroller,
                            decoration: InputDecoration(
                              labelText: 'Product Price',
                              hintText: 'Enter product price',
                              icon: Icon(Icons.money_rounded),
                            )),
                      ),
                      IntrinsicHeight(
                        child: TextField(
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: _qtycontroller,
                            decoration: InputDecoration(
                              labelText: 'Product Quantity',
                              hintText: 'Enter product quantity',
                              icon: Icon(Icons.format_list_numbered_rounded),
                            )),
                      ),
                      SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Update'),
                        color: Colors.amber,
                        textColor: Colors.black,
                        elevation: 15,
                        onPressed: editFoodDialog,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ))),
      ),
    );
  }

  void editFoodDialog() {
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    _qty = _qtycontroller.text;

    if (_name == "" || _price == "" || _qty == "") {
      Toast.show(
        "Please fill all required fields",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Update " + widget.product.productname,
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
                _onEditFood();
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

  void _onEditFood() {
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    _qty = _qtycontroller.text;

    http.post("https://steadybongbibi.com/techcomm/php/update_product.php",
        body: {
          "id": widget.product.productid,
          "name": _name,
          "price": _price,
          "qty": _qty,
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
