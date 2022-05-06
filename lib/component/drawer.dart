import 'package:clinic/source/source.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(children: [
        DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              children: [
                userImage.isNotEmpty
                    ? CircleAvatar(backgroundImage: NetworkImage(userImage))
                    : const Icon(Icons.account_circle_outlined,
                        size: 80, color: iconColor),
                Text('$userFName $userLName',
                    style: const TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ],
            )),
        ListTile(
          leading: Icon(Icons.account_circle_rounded,
              color: Theme.of(context).iconTheme.color),
          title: const Text("ແກ້ໄຂໂປຣໄຟຣ"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.edit_note_rounded,
              color: Theme.of(context).iconTheme.color),
          title: const Text("ຈັດການຂໍ້ມູນ"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.list_alt_rounded,
              color: Theme.of(context).iconTheme.color),
          title: const Text("ປະຫວັດການປິ່ນປົວ"),
          onTap: () {},
        ),
        ListTile(
          leading:
              Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
          title: const Text("ການຕັ້ງຄ່າ"),
          onTap: () {},
        ),
      ]),
    );
  }
}
