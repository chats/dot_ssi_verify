import 'dart:convert';

import 'package:aec_verifier_mobile/services/proof_service.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';

class MessageController extends GetxController {
  late final WebSocketChannel? channel;
  List<dynamic> items = [].obs;
  RxInt itemCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    channel = WebSocketChannel.connect(Uri.parse(Constants.agentWss));
    channel!.stream.listen((event) {
      final o = json.decode(event);

      final topic = o["topic"];
      final state = (o["payload"] != null) ? o["payload"]["state"] : "";
      if (topic == "connections" && state == "active") {
        items.add(event);
      } else if (topic == "present_proof") {
        final state = o["payload"]["state"];
        if (state == "proposal_received") {
          final presExId = o["payload"]["presentation_exchange_id"];
          sendProofRequestById(presExId)
              .then((value) => {print("Sent proof request")});
        }
        if (state == "verified") {
          items.add(event);
        }
      }
    });
  }

  @override
  void dispose() {
    channel!.sink.close();
    super.dispose();
  }
}
