import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class ReportReserveDetailPage extends StatefulWidget {
  const ReportReserveDetailPage({Key? key, required this.data})
      : super(key: key);
  final ReserveModel data;

  @override
  State<ReportReserveDetailPage> createState() =>
      _ReportReserveDetailPageState();
}

class _ReportReserveDetailPageState extends State<ReportReserveDetailPage> {
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
                const Text("ລາຍລະອຽດການປິນປົວ", style: title),
                const Divider(color: primaryColor, height: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ລາຍການ: ${data.tooth!.name}'),
                    Text('ລາຄາລວມ: ${fm.format(data.price)} ກິບ'),
                    Text(
                        'ວັນທີ: ${fmdate.format(DateTime.parse(data.startDate))}'),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowHeight: 40,
                        columns: menuDetailsColumn(context),
                        rows: List<DataRow>.generate(data.reserveDetail!.length,
                            (index) {
                          return DataRow(cells: <DataCell>[
                            DataCell(Text('${index + 1}')),
                            DataCell(Text(data.reserveDetail![index].detail,
                                maxLines: 5,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis)),
                            DataCell(Text(
                                '${fm.format(data.reserveDetail![index].price)} ກິບ')),
                            DataCell(Text(fmdate.format(DateTime.parse(
                                data.reserveDetail![index].date)))),
                          ]);
                        }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

List<DataColumn> menuDetailsColumn(BuildContext context) {
  return <DataColumn>[
    const DataColumn(label: Text('ລຳດັບ', style: title)),
    const DataColumn(label: Text('ລາຍລະອຽດ', style: title)),
    const DataColumn(label: Text('ລາຄາ', style: title)),
    const DataColumn(label: Text('ວັນທີ', style: title)),
  ];
}
