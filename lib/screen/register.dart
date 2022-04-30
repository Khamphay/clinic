import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child:
                    SvgPicture.asset("assets/images/writer.svg", height: 150),
              ),
              SizedBox(
                  // height: 10,
                  child: Text("ລົງທະບຽນ",
                      style: Theme.of(context).textTheme.headline1)),
              _buildForm(),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 28),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("ລົງທະບຽນ")))
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return Form(
      child: CustomContainer(
          padding: const EdgeInsets.only(top: 20),
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            children: [
              CustomContainer(
                  title: const Text("ຊື່"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ນາມສະກຸນ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ເບີໂທລະສັບ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone_in_talk_outlined),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ບ້ານ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_history_sharp),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ເມືອງ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ແຂວງ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  )),
              CustomContainer(
                  title: const Text("ລະຫັດຜ່ານ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.security_rounded),
                    ),
                  )),
            ],
          )),
    );
  }
}
