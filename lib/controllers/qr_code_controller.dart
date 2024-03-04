import 'package:get/get.dart';

class QrCodeController extends GetxController {
  var qrData = "".obs;

  void setQrData(String data) {
    qrData.value = data;
  }
}
