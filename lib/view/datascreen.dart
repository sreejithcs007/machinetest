import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responseData = Get.arguments;

    final List<Map<String, dynamic>> dataList = [];
    if (responseData != null && responseData['data'] != null) {
      final List<dynamic> list = responseData['data']['list'];
      list.forEach((item) {
        dataList.add({
          '_name': item['_name'] ?? '',
          '_uid': item['_uid'] ?? '',
          '_docType': item['_docType'] ?? '',
          '_url': item['_url'] ?? '',
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table'),
      ),
      body: dataList.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  child: DataTable2(
                    dataRowHeight: 200,
                    columns: const [
                      DataColumn2(
                          label: Text('_name'),
                          size: ColumnSize.L,
                          fixedWidth: 90),
                      DataColumn2(
                          label: Text('_uid'),
                          size: ColumnSize.L,
                          fixedWidth: 90),
                      DataColumn2(
                          label: Text('_docType'),
                          size: ColumnSize.L,
                          fixedWidth: 90),
                      DataColumn2(
                          label: Text('_url'),
                          size: ColumnSize.L,
                          fixedWidth: 90),
                    ],
                    rows: dataList.map<DataRow>((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data['_name'])),
                          DataCell(Text(data['_uid'].toString())),
                          DataCell(Text(data['_docType'].toString())),
                          DataCell(Image.network(data['_url'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            )
          : Center(
              child: Text('No data available'),
            ),
    );
  }
}
