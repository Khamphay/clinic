import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';

class DrawerComponet extends StatefulWidget {
  const DrawerComponet({Key? key}) : super(key: key);

  @override
  State<DrawerComponet> createState() => _DrawerComponetState();
}

class _DrawerComponetState extends State<DrawerComponet> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      DrawerHeader(
          decoration: const BoxDecoration(color: primaryColor),
          child: Column(
            children: const [
              Icon(Icons.account_circle_outlined, size: 80, color: iconColor),
              Text("Mr. KP Dev",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
            ],
          )),
      ListTile(
        leading: const Icon(Icons.account_circle_rounded),
        title: const Text("ແກ້ໄຂໂປຣໄຟຣ"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.edit_note_rounded),
        title: const Text("ຈັດການຂໍ້ມູນ"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.list_alt_rounded),
        title: const Text("ປະຫວັດການປິ່ນປົວ"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("ການຕັ້ງຄ່າ"),
        onTap: () {},
      ),
    ]);
  }
}
