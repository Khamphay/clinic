import 'package:clinic/admin/management/form/profile_form.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/model/user_model.dart';
import 'package:clinic/page/forgot_password.dart';
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
                    ? CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage('$urlImg/$userImage'))
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
          onTap: () async {
            myProgress(context, null);
            await UserModel.fetchUser(userId: userId).then((user) {
              Navigator.pop(context);
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditProfileFrom(user: user)))
                  .then((value) {
                if (value != null && value) {
                  setState(() {});
                }
              }).catchError((e) {
                Navigator.pop(context);
                showFailDialog(
                    context: context,
                    title: 'ແກ້ໄຂໂປຣໄຟຣ',
                    content: e.toString());
              });
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.edit_note_rounded,
              color: Theme.of(context).iconTheme.color),
          title: const Text("ປ່ຽນລະຫັດຜ່ານ"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FogotPassworldPage()));
          },
        ),
      ]),
    );
  }
}
