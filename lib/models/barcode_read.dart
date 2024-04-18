import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future lerMaisCodigoBarras(List<dynamic> enderecos) async {
  String barcodeRet = '';
  try {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancelar', true, ScanMode.BARCODE)!
        .listen((barcode) => barcodeRet = barcode);
  } on PlatformException {
    barcodeRet = 'Failed to get platform version.';
  }

  return barcodeRet;
}

String procCodBar(barcode, List<dynamic> enderecos) {
  String c;
  c = barcode;
  return c;
}

Future<void> scanQR(List<dynamic> enderecos) async {
  String barcodeScanRes;

  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
}
