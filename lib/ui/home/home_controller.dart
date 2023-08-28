import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0;

  void changeNavIndex(int index) {
    selectedIndex = index;
    update();
  }
}