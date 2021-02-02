import 'dart:convert';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tech_comm/User/mercscreendetails.dart';
import 'package:toast/toast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'loginscreen.dart';
import 'merchant.dart';
import 'shoppingcartscreen.dart';
import 'user.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List mercList;
  List cartList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Profile...";
  String titlecenter1 = "Loading Cart...";
  int _currentIndex = 0;
  String _title = 'Main Page';
  double totalPrice = 0.0;
  String _homeloc = "searching...";
  String gmaploc = "";
  double latitude, longitude, merclat, merclon;
  Position _currentPosition;
  var locList = {"Kuala Terengganu", "Dungun", "Kemaman"};
  var ratingList = {"Highest", "Lowest"};
  String selectedLoc = "Kuala Terengganu";
  String selectedRating = "Highest";
  @override
  void initState() {
    super.initState();
    _loadCart();
    _loadMerchant(selectedLoc, selectedRating);
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Muli",
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.amberAccent,
          elevation: 0,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  _title,
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 5,
              ),
            ),
            bottomNavigationBar: FFNavigationBar(
                theme: FFNavigationBarTheme(
                  barBackgroundColor: Colors.white,
                  selectedItemBorderColor: Colors.amber,
                  selectedItemBackgroundColor: Colors.green,
                  selectedItemIconColor: Colors.white,
                  selectedItemLabelColor: Colors.black,
                ),
                selectedIndex: _currentIndex,
                // type: BottomNavigationBarType.fixed,
                //  selectedFontSize: 16,
                items: [
                  FFNavigationBarItem(
                    iconData: Icons.home,
                    // ignore: deprecated_member_use
                    label: 'Home',
                  ),
                  FFNavigationBarItem(
                    iconData: Icons.shopping_cart,
                    // ignore: deprecated_member_use
                    label: 'Cart',
                  ),
                  FFNavigationBarItem(
                    iconData: Icons.house,
                    // ignore: deprecated_member_use
                    label: 'Merchant',
                  ),
                  FFNavigationBarItem(
                    iconData: Icons.person,
                    // ignore: deprecated_member_use
                    label: 'Profile',
                  ),
                ],
                onSelectTab: (index) {
                  setState(() {
                    _changeTitle(index);
                  });
                }),
            body: (_currentIndex == 0)
                ? SingleChildScrollView(
                    child: Column(children: <Widget>[
                      SizedBox(
                          height: 220.0,
                          width: 400.0,
                          child: Carousel(
                            images: [
                              ExactAssetImage("assets/slide/slide1.jfif"),
                              Image.asset("assets/slide/slide6.jpg",
                                  fit: BoxFit.fitHeight),
                              ExactAssetImage("assets/slide/slide2.jpg"),
                              ExactAssetImage("assets/slide/slide3.jpg"),
                              ExactAssetImage("assets/slide/slide4.jpg"),
                              ExactAssetImage("assets/slide/slide5.jpg"),
                            ],
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 1000),
                            dotIncreasedColor: Color(0xFFFF335C),
                            dotBgColor: Colors.transparent,
                            autoplay: true,
                            indicatorBgPadding: 7.0,
                            dotSize: 4,
                            dotPosition: DotPosition.topRight,
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Hi," + widget.user.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "You have a great choice \nof sellers near you.",
                                style: TextStyle(fontSize: 16)),
                          )
                        ]),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Container(
                                  height: 300,
                                  width: 220,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: () => _onItemTapped(),
                                      child: Image.asset(
                                          "assets/slide/tap1.jpg",
                                          fit: BoxFit.cover),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Positioned(
                                  child: Text("Merchants",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  bottom: 250,
                                  right: 60,
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 300,
                                  width: 220,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: () => _onItemTapped1(),
                                      child: Image.asset(
                                          "assets/slide/tap2.jpg",
                                          fit: BoxFit.cover),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Positioned(
                                  child: Text("Shopping Carts",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  bottom: 250,
                                  right: 40,
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 300,
                                  width: 220,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: () => _onItemTapped2(),
                                      child: Image.asset(
                                          "assets/slide/tap3.jpg",
                                          fit: BoxFit.cover),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Positioned(
                                  child: Text("Profile",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  bottom: 250,
                                  right: 80,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )
                : (_currentIndex == 1)
                    ? Column(
                        children: [
                          cartList == null
                              ? Flexible(
                                  child: Container(
                                      child: Center(
                                  child: Text(
                                    titlecenter1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )))
                              : Flexible(
                                  child: GridView.count(
                                      crossAxisCount: 1,
                                      childAspectRatio:
                                          (screenWidth / screenHeight) / 0.35,
                                      children: List.generate(cartList.length,
                                          (index) {
                                        return Padding(
                                          padding: EdgeInsets.all(1),
                                          child: FlipCard(
                                            direction: FlipDirection.VERTICAL,
                                            front: Column(children: [
                                              Container(
                                                  height: screenHeight / 6.8,
                                                  width: screenWidth / 3.0,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "http://steadybongbibi.com/techcomm/images/productimages/${cartList[index]['productimg']}.jpg",
                                                      fit: BoxFit.fill,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                            Icons.broken_image,
                                                            size:
                                                                screenWidth / 3,
                                                          ))),
                                              Text(
                                                  "[" +
                                                      cartList[index]
                                                          ['mercname'] +
                                                      "] " +
                                                      cartList[index]
                                                          ['productname'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text("RM " +
                                                  cartList[index]
                                                      ['productprice'] +
                                                  "/unit"),
                                              Text("Quantity: " +
                                                  cartList[index]
                                                      ['productqty']),
                                              Text("Total RM " +
                                                  ((double.parse(cartList[index]
                                                              [
                                                              'productprice']) *
                                                          int.parse(cartList[
                                                                  index]
                                                              ['productqty']))
                                                      .toStringAsFixed(2)))
                                            ]),
                                            back: Card(
                                              child: Container(
                                                height: 50,
                                                child: FractionallySizedBox(
                                                  heightFactor: 0.2,
                                                  widthFactor: 0.8,
                                                  child: MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                    child: Center(
                                                      child: Text('Delete Item',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    textColor: Colors.black,
                                                    elevation: 10,
                                                    color: Colors.amber,
                                                    onPressed: () =>
                                                        _deleteOrderDialog(
                                                            index),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }))),
                          SizedBox(
                            height: 45,
                            width: 150,
                            child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: new Text('Check Out',
                                  style: TextStyle(
                                      fontSize: (18),
                                      fontWeight: FontWeight.bold)),
                              color: Colors.amber,
                              onPressed: () {
                                _shoppingCartScreen();
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                    : (_currentIndex == 2)
                        ? Column(
                            children: [
                              Container(
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Select Location"),
                                          Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.red),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5.0) //                 <--- border radius here
                                                    ),
                                              ),
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'Select Location',
                                                  style: TextStyle(
                                                      //color: Color.fromRGBO(101, 255, 218, 50),
                                                      ),
                                                ), // Not necessary for Option 1
                                                value: selectedLoc,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedLoc = newValue;
                                                    print(selectedLoc);
                                                    _loadMerchant(selectedLoc,
                                                        selectedRating);
                                                  });
                                                },
                                                items:
                                                    locList.map((selectedLoc) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedLoc.toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    value: selectedLoc,
                                                  );
                                                }).toList(),
                                              )),
                                        ],
                                      ),

                                      SizedBox(width: 10),
                                      //dropdown for sort by
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Rating"),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      5.0) //                 <--- border radius here
                                                  ),
                                            ),
                                            child: DropdownButton(
                                              //sorting dropdownoption
                                              hint: Text(
                                                'Rating',
                                                style: TextStyle(
                                                    //color: Color.fromRGBO(101, 255, 218, 50),
                                                    ),
                                              ), // Not necessary for Option 1
                                              value: selectedRating,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedRating = newValue;
                                                  print(selectedRating);
                                                  _loadMerchant(selectedLoc,
                                                      selectedRating);
                                                });
                                              },
                                              items: ratingList
                                                  .map((selectedRating) {
                                                return DropdownMenuItem(
                                                  child: new Text(
                                                      selectedRating.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  value: selectedRating,
                                                );
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 10),
                              mercList == null
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
                                          childAspectRatio:
                                              (screenWidth / screenHeight) /
                                                  0.8,
                                          children: List.generate(
                                              mercList.length, (index) {
                                            return Padding(
                                              padding: EdgeInsets.all(2),
                                              child: FlipCard(
                                                direction:
                                                    FlipDirection.VERTICAL,
                                                front: Column(children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                          height: screenHeight /
                                                              3.8,
                                                          width:
                                                              screenWidth / 1.2,
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl:
                                                                      "http://steadybongbibi.com/techcomm/images/merchantimages/${mercList[index]['mercimage']}.jpg",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      new CircularProgressIndicator(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      new Icon(
                                                                        Icons
                                                                            .broken_image,
                                                                        size: screenWidth /
                                                                            3,
                                                                      ))),
                                                      Positioned(
                                                        child: Container(
                                                            //color: Colors.white,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    mercList[
                                                                            index]
                                                                        [
                                                                        'mercrating'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                                Icon(Icons.star,
                                                                    color: Colors
                                                                        .black),
                                                              ],
                                                            )),
                                                        bottom: 10,
                                                        right: 10,
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                      mercList[index]
                                                          ['mercname'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(mercList[index]
                                                      ['mercphone']),
                                                  Text(mercList[index]
                                                      ['merclocation']),
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
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                        child: Center(
                                                          child: Text(
                                                              'Visit Profile',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        textColor: Colors.black,
                                                        elevation: 10,
                                                        color: Colors.amber,
                                                        onPressed: () =>
                                                            _loadMerchantDetail(
                                                                index),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                                  color: Colors.brown[300],
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            margin: EdgeInsets.all(10),
                                            width: 300,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: ExactAssetImage(
                                                  'assets/slide/tap3.jpg',
                                                ),
                                              ),
                                            )),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Text("User Name: ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(widget.user.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            children: [
                                              Text("User Email: ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(widget.user.email,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            children: [
                                              Text("User Phone: ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(widget.user.phone,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Wrap(
                                            children: [
                                              Text("User Current Location: ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(_homeloc,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  height: 50,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.9,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      child: new Text('Log Out',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      color: Colors.amber[700],
                                      onPressed: () {
                                        _onLogout();
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          )),
      ),
    );
  }

  void _loadMerchant(String loc, String rat) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://steadybongbibi.com/techcomm/php/load_merchant.php",
        body: {
          "rating": rat,
          "location": loc,
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        mercList = null;
        setState(() {
          titlecenter = "No Seller Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          mercList = jsondata["merc"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadMerchantDetail(int index) {
    print(mercList[index]["mercname"]);
    Merchant merchant = new Merchant(
      mercid: mercList[index]["mercid"],
      mercname: mercList[index]["mercname"],
      mercphone: mercList[index]["mercphone"],
      merclocation: mercList[index]["merclocation"],
      mercimage: mercList[index]["mercimage"],
      mercradius: mercList[index]["mercradius"],
      merclatitude: mercList[index]["mercrlatitude"],
      merclongitude: mercList[index]["merclongitude"],
      mercdelivery: mercList[index]["mercdelivery"],
      mercrating: mercList[index]["mercrating"],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MercScreenDetails(merc: merchant, user: widget.user)),
    );
  }

  void _loadCart() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://steadybongbibi.com/techcomm/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cartList = null;
        setState(() {
          titlecenter1 = "No Item Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _changeTitle(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Main Page';
            setState(() {});
          }
          break;
        case 1:
          {
            _title = "Your Cart";

            setState(() {
              _loadCart();
            });
          }
          break;
        case 2:
          {
            _title = 'Seller Available';
            setState(() {
              _loadMerchant(selectedLoc, selectedRating);
            });
          }
          break;
        case 3:
          {
            _title = 'Profile';
            setState(() {
              _getLocation();
            });
          }
          break;
      }
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['productname']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Item " + cartList[index]['productname'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure? ",
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
                _deleteCart(index);
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

  void _shoppingCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
          builder: (context) => ShoppingCartScreen(user: widget.user)),
    ).then((bool res) {
      if (res != null && res == true) {
        setState(() {
          _loadCart();
        });
      }
    });
  }

  void _deleteCart(int index) {
    http.post("https://steadybongbibi.com/techcomm/php/delete_cart.php", body: {
      "email": widget.user.email,
      "productid": cartList[index]['productid'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadCart();
        Toast.show(
          "Successfully Deleted",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onLogout() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onItemTapped() {
    setState(() => _currentIndex = 2);
  }

  _onItemTapped1() {
    setState(() => _currentIndex = 1);
  }

  _onItemTapped2() {
    setState(() => _currentIndex = 3);
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        if (_currentPosition != null) {
          final coordinates = new Coordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          setState(() {
            var first = addresses.first;
            _homeloc = first.addressLine;
            if (_homeloc != null) {
              latitude = _currentPosition.latitude;
              longitude = _currentPosition.longitude;

              return;
            }
          });
        }
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }
}
