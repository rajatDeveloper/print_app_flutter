import 'package:flutter/material.dart';
import 'package:print_app/feature/histroy/view/histroy_view.dart';
import 'package:print_app/feature/print_cart/view/print_cart_view.dart';
import 'package:print_app/feature/print_cart/view/product_view.dart';
import 'package:print_app/res/colors.dart';

class MainBarScreen extends StatefulWidget {
  static const String routeName = '/main_bar';
  final int index;
  const MainBarScreen({super.key, required this.index});

  @override
  State<MainBarScreen> createState() => _MainBarScreenState();
}

class _MainBarScreenState extends State<MainBarScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index; // Initialize with the provided index
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Define the widgets for each tab
  final List<Widget> _children = [
    ProductView(),
    PrintCartView(),
    HistroyView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // Display the selected screen
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _currentIndex == 0
                            ? Colors.red.withOpacity(0.5)
                            : Colors.white,
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 7),
                      ),
                    ],
                    color:
                        _currentIndex == 0 ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.production_quantity_limits,
                      color:
                          _currentIndex == 0 ? Colors.white : AppColors.grey)),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _currentIndex == 1
                            ? Colors.red.withOpacity(0.5)
                            : Colors.white,
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 7),
                      ),
                    ],
                    color:
                        _currentIndex == 1 ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.print,
                      color:
                          _currentIndex == 1 ? Colors.white : AppColors.grey)),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _currentIndex == 2
                            ? Colors.red.withOpacity(0.5)
                            : Colors.white,
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 7),
                      ),
                    ],
                    color:
                        _currentIndex == 2 ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.history,
                      color:
                          _currentIndex == 2 ? Colors.white : AppColors.grey)),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainBarScreen(index: 0), // Starting with the Home tab
  ));
}
