import 'dart:convert';

import 'api_service.dart';

Future<dynamic> sendProofRequestById(String presExId) async {
  final api = 'present-proof/records/$presExId/send-request';

  Map<String, dynamic> document = {
    "auto_remove": true,
    "auto_verify": true,
    "trace": false
  };

  try {
    Map<String, dynamic> data =
        await APIService.post(api, json.encode(document));
    return data;
  } catch (e) {
    throw e.toString();
  }
}
