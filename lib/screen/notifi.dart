import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) => Column(
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
                )),
      ),
    );
  }
}
