import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tech_comm/Admin/adminmerchant.dart';

void main() => runApp(ShowOrder());

class ShowOrder extends StatefulWidget {
  final AdminMerchant order;

  const ShowOrder({Key key, this.order}) : super(key: key);
  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  List orderList;
  String titlecenter = "Loading Orders...";
  String type = "Orders";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Order List'),
      ),
      body: Center(
        child: Column(children: [
          orderList == null
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
                        _loadOrder();
                      },
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: (screenWidth / screenHeight) / 0.2,
                        children: List.generate(orderList.length, (index) {
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
                                color: Colors.amber,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        "Buyer Email: " +
                                                orderList[index]
                                                    ['orderemail'] ??
                                            'Loading',
                                      ),
                                      Text("Ordered Product ID: " +
                                              orderList[index]
                                                  ['orderproductid'] ??
                                          'Loading'),
                                      Text("Ordered Quantity: " +
                                              orderList[index]
                                                  ['orderproductquantity'] ??
                                          'Loading'),
                                      Text("Remarks: " +
                                              orderList[index]
                                                  ['orderremarks'] ??
                                          'Loading'),
                                      Text("Order DateTime: " +
                                              orderList[index]['ordertime'] ??
                                          'Loading'),
                                    ],
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

  void _loadOrder() {
    http.post("https://steadybongbibi.com/techcomm/php/show_order.php", body: {
      "mercid": widget.order.mercid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        orderList = null;
        setState(() {
          titlecenter = "No $type Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          orderList = jsondata["order"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
