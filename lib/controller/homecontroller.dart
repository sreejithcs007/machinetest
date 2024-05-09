import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../view/datascreen.dart';

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
      final response = await dio.post(apiUrl,
          data: {
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
          },
          options: options);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("success");

        Get.to(DataScreen(), arguments: response.data);
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
