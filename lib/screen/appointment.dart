import 'package:clinic/component/component.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(children: [
        Expanded(
            child: Component(
          width: size.width,
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_month_rounded),
                  Text(
                    'ລາຍການນັດໜາຍກັບລູກຄ້າພາຍໃນມື້ນີ້',
                    style: bodyText2Bold,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 26),
                child: Text('ລວມທັງໝົດ: 10 ລາຍການ', style: bodyText2Bold),
              )
            ],
          ),
        )),
        const Divider(color: primaryColor, height: 2),
        Expanded(
            flex: 7,
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.8),
                            child: Text('${index + 1}')),
                        title: const Text("ທ້າວ ໂຄດດິງ ເດບ"),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ລາຍການຮັດສາ: ຈັດແຂ້ວ'),
                              Text('ເວລານັດໝາຍ: ${DateTime.now()}')
                            ]),
                      ),
                      const Divider(color: primaryColor, height: 2)
                    ],
                  );
                }))
      ]),
    );
  }
}
