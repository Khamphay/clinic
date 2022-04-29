import 'package:clinic/component/drawer.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active_rounded,
                      color: iconColor)),
              Positioned(
                  left: 25,
                  top: 5,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.circular(100)),
                  )),
              const Positioned(
                  left: 30, top: 4, child: Text('4', style: smallText))
            ],
          )
        ],
      ),
      drawer: const Drawer(child: DrawerComponet()),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: const Center(child: Text("Clinic")),
        ),
      ),
    );
  }
}
