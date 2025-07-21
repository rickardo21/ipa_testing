import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project_app/Home/pages/HomePage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('it_IT', null).then((_) {
    // runApp(
    //   DevicePreview(
    //     builder: (context) => MyApp(),
    //   ),
    // );
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        // brightness: Brightness.light,
        primaryColor: CupertinoColors.systemGreen,
        //   textTheme: CupertinoTextThemeData(
        //       textStyle: TextStyle(
        //     fontFamily: 'sfpro',
        //   ))
      ),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const HomePage(),
    const HomePage(),
    const HomePage(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Spending',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_app_fill),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rosette),
            label: 'Achievement',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
        // iconSize: 25.0,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) => _pages[index],
        );
      },
    );
  }
}
