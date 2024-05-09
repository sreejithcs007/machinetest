import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      title: 'Your App',
      home: HomeScreen(),

    );
  }
}

class HomeController extends GetxController {
  final Dio dio = Dio();
  final String apiUrl = 'https://ajcjewel.com:4000/api/global-gallery/list';

  final RxBool isLoading = false.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfdXNlcklkXyI6IjYzMDI2ZjIxNWE5ZDVjNDY1NzQ3MTMxYSIsIl9lbXBsb3llZUlkXyI6IjYzMDI2ZjIxYTI1MTZhMTU0YTUxY2YxOSIsIl91c2VyUm9sZV8iOiJzdXBlcl9hZG1pbiIsImlhdCI6MTcxMTQ0NTY1OSwiZXhwIjoxNzQyOTgxNjU5fQ.lE1Gbdm8YZ6Fany4184Pb7kSUg-z6Rk8Ag1irB3fstc';
    final options = Options(headers: {'Authorization': token});
    try {
      final response = await dio.post(apiUrl, data: {
        "statusArray": [1],
        "screenType": [],
        "responseFormat": [],
        "globalGalleryIds": [],
        "categoryIds": [],
        "docTypes": [],
        "types": [],
        "limit": 10,
        "skip": 0,
        "searchingText": ""
      }, options: options);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("success");

        Get.to(DataScreen(),arguments: response.data );
      } else {

        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {

      print('Error fetching data: $e');
      Get.snackbar('Error', 'Failed to fetch data');
    } finally {
      isLoading.value = false;
    }
  }
}

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Obx(() => ElevatedButton(
          onPressed: () => controller.fetchData(),
          child: controller.isLoading.value ? CircularProgressIndicator() : Text('Fetch Data'),
        )),
      ),
    );
  }
}
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
              columns: [
                DataColumn2(label: Text('_name'), size: ColumnSize.L,fixedWidth: 90),
                DataColumn2(label: Text('_uid'), size: ColumnSize.L,fixedWidth: 90),
                DataColumn2(label: Text('_docType'), size: ColumnSize.L,fixedWidth: 90),
                DataColumn2(label: Text('_url'), size: ColumnSize.L,fixedWidth: 90),
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
