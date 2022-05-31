import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class CustomerReserveDetailPage extends StatefulWidget {
  const CustomerReserveDetailPage({Key? key, required this.data})
      : super(key: key);
  final ReserveModel data;

  @override
  State<CustomerReserveDetailPage> createState() =>
      _CustomerReserveDetailPageState();
}

class _CustomerReserveDetailPageState extends State<CustomerReserveDetailPage> {
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
                            DataCell(Text(data.reserveDetail![index].detail)),
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
    const DataColumn(label: Text('ລາຍການ', style: title)),
    const DataColumn(label: Text('ລາຄາ', style: title)),
    const DataColumn(label: Text('ວັນທີ', style: title)),
  ];
}
