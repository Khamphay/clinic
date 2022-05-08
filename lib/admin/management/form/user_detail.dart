import 'package:clinic/component/component.dart';
import 'package:clinic/model/user_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late UserModel user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('ລາຍລະອຽດ')),
      body: Component(
          width: size.width,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: user.profile.image!.isNotEmpty
                    ? CircleAvatar(
                        maxRadius: 50,
                        backgroundImage:
                            NetworkImage("$urlImg/${user.profile.image!}"))
                    : const Icon(Icons.account_circle_outlined,
                        size: 80, color: primaryColor),
              ),
              const SizedBox(height: 20),
              Text("ຊື່ ແລະ ນາມສະກຸນ: ${user.profile.firstname}"),
              Text("ເພດ: ${user.profile.gender == 'M' ? 'ຍິງ' : 'ຊາຍ'}"),
              Text(
                  "ວັນເດືອນປີເກີດ: ${fmdate.format(DateTime.parse(user.profile.birthDate))}"),
              Text("ເບີໂທລະສັບ: ${user.phone}"),
              Text("ບ້ານ: ${user.profile.village}"),
              Text("ເມືອງ: ${user.profile.district}"),
              Text("ແຂວງ: ${user.profile.province}"),
            ],
          ))),
    );
  }
}
