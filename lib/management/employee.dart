import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ຂໍ້ມູນພະະນັກງານ"),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) {
            return Column(
              children: [
                ListTile(
                    leading:
                        const Icon(Icons.account_circle_outlined, size: 40),
                    title: const Text("ທ້າວ ໂຄດດິງ ເດບ"),
                    subtitle: const Text('ເບີໂທລະສັບ: 0205XXXXXXX'),
                    trailing: _buildMenu()),
                const Divider(color: primaryColor, height: 2)
              ],
            );
          }),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert_rounded, color: primaryColor),
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.edit, color: primaryColor),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("ແກ້ໄຂ"),
                  )
                ],
              )),
              PopupMenuItem(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.delete_forever_rounded, color: errorColor),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("ລຶບ", style: errorText),
                  )
                ],
              )),
            ]);
  }
}
