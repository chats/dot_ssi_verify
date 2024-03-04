import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';

Future receiveInvitation(String invitationUrl) async {
  var api = 'connections/receive-invitation';

  //print("qrcode=$invitationUrl");

  var uri = Uri.parse(invitationUrl);

  var invitation = utf8.decode(base64.decode(uri.queryParameters["c_i"]!));
  if (kDebugMode) {
    print('invitation=$invitation');
  }

  try {
    await APIService.post(api, invitation);
  } catch (e) {
    throw e.toString();
  }
}
