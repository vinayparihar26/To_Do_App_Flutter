import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/features/responsive.dart';

import 'package:to_do_app/features/screen/add_task.dart';
import 'package:to_do_app/features/screen/home_page.dart';
import 'package:to_do_app/features/theme_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final List<Widget> pages = [HomePage(), AddTask()];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Add Task",
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/profile.png',
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'To-Do App',
                style: TextStyle(fontSize: 20*getResponsive(context), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [

          Row(
            children: [
              Icon(themeProvider.isDarkMode? Icons.dark_mode: Icons.light_mode, color: Colors.white,size: 20*getResponsive(context),),
              SizedBox(width: 0.04*getWidth(context)),
              Transform.scale(
                scale: getResponsive(context),
child:  Switch(
  value: themeProvider.isDarkMode,
  onChanged: (bool value) {
    themeProvider.toogleTheme();
  },
),
              )

            ],
          ),
        ],
      ),
    );
  }
}
