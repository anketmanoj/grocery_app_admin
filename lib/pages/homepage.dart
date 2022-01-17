import 'package:flutter/material.dart';
import 'package:grocery_app_admin/pages/categories/categories_list.dart';
import 'package:grocery_app_admin/services/shared_services.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class NavBarModel {
  late String title;
  late IconData icon;
  late Color color;

  NavBarModel({
    required this.color,
    required this.icon,
    required this.title,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NavBarModel> _titleList = [
    NavBarModel(color: Colors.cyan, icon: Icons.home, title: "Dashboard"),
    NavBarModel(color: Colors.red, icon: Icons.category, title: "Categories"),
    NavBarModel(color: Colors.orange, icon: Icons.image, title: "Products"),
    NavBarModel(color: Colors.green, icon: Icons.group, title: "Customers"),
    NavBarModel(
        color: Colors.purple, icon: Icons.shopping_bag, title: "Orders"),
  ];

  List<Widget> _widgetList = [
    const Center(
      child: Text("Dashboard"),
    ),
    CategoriesList(),
    const Center(
      child: Text("Products"),
    ),
    const Center(
      child: Text("Customers"),
    ),
    const Center(
      child: Text("Orders"),
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: _titleList.map((NavBarModel model) {
          return BottomNavigationBarItem(
            icon: Icon(
              model.icon,
              color: model.color,
            ),
            label: model.title,
          );
        }).toList(),
      ),
      body: _widgetList[_index],
    );
  }
}
