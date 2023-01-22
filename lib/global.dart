import 'package:intl/intl.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';

final moneyFormat = NumberFormat("##,##0.00");

String deviceId = "";
//String webServiceUrl =  "http://192.168.1.4:8084";
//String webServiceUrl = "http://smldemo.smlsoft.com:8000";
String webServiceUrl = "http://smlsupport.smldatacenter.com";
String webServiceVersion = "/SMLJavaWebService/webresources/rest/";
String providerName = "SMLSUPPORT";
String databaseName = "sml1"; // "DATA1 or DEMO";
List<Product> productDetail = [];
List<Product> productScan = [];

enum SoundEnum { Beep, Fail, ButtonTing }

void playSound(SoundEnum soundEnum) {
/*  final _assetsAudioPlayer = AssetsAudioPlayer();
  String _soundName = "";
  switch (soundEnum) {
    case SoundEnum.ButtonTing:
      _soundName = "button_ting";
      break;
    case SoundEnum.Beep:
      _soundName = "scan_success";
      break;
    case SoundEnum.Fail:
      _soundName = "scan_fail";
      break;
  }
  if (_soundName.length > 0) {
    _assetsAudioPlayer.open(
      Audio("assets/audios/" + _soundName + ".wav"),
    );
  }*/
}

String imageUrl(String guid) {
  return webServiceUrl +
      '/SMLJavaWebService/webresources/image/' +
      guid +
      '?p=' +
      providerName +
      '&d=' +
      databaseName;
}

enum menuId { packingSO, packbox, packcar, send, signout }
