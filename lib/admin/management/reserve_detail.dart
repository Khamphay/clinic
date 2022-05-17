import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class ReserveDetailPage extends StatefulWidget {
  const ReserveDetailPage({Key? key, required this.data}) : super(key: key);
  final ReserveModel data;

  @override
  State<ReserveDetailPage> createState() => _ReserveDetailPageState();
}

class _ReserveDetailPageState extends State<ReserveDetailPage> {
  late ReserveModel data;
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('ລາຍລະອຽດການນັດໝາຍ')),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
              child: Component(
            width: size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("ຂໍ້ມູນລູກຄ້າ", style: title),
                const Divider(color: primaryColor, height: 2),
                Text(
                    'ຊື່ ແລະ ນາມສະກຸນ: ${data.user!.profile.firstname} ${data.user!.profile.lastname}'),
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ເບິໂທ: ${data.user!.phone}'),
                          Text('ບ້ານ: ${data.user!.profile.village}'),
                          Text('ເມືອງ: ${data.user!.profile.district!.name}'),
                          Text('ແຂວງ: ${data.user!.profile.province!.name}'),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Center(
                        child: data.user!.profile.image!.isNotEmpty
                            ? CircleAvatar(
                                maxRadius: 50,
                                backgroundImage: NetworkImage(
                                    "$urlImg/${data.user!.profile.image!}"))
                            : const Icon(Icons.account_circle_outlined,
                                size: 80, color: primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("ຂໍ້ມູນການຈອງ", style: title),
                const Divider(color: primaryColor, height: 2),
              ],
            ),
          ))),
    );
  }
}
