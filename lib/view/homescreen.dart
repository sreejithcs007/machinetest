import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontroller.dart';

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
              child: controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Text('Fetch Data'),
            )),
      ),
    );
  }
}
