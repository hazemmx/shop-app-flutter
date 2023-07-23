import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cartScreen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/ordersScreen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_prod_sc.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(create: (context) => Products()),
          ChangeNotifierProvider(
            create: (context) =>
                Cart(), // create 3shan bnprovide a brand new object
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            }));
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InstaShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (selectedValue) {
                print(selectedValue);
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Favourites"),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: 1,
                    )
                  ],
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Center(
        child: Text('Let\'s build a shop !'),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
