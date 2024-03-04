import 'dart:convert';

import 'package:aec_verifier_mobile/controllers/message_controller.dart';
import 'package:aec_verifier_mobile/controllers/qr_code_controller.dart';
import 'package:aec_verifier_mobile/widget/scan_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../services/connection_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final QrCodeController qrCodeController =
        Get.put(QrCodeController(), permanent: false);

    final MessageController messageController =
        Get.put(MessageController(), permanent: false);

    return Scaffold(
      appBar: AppBar(title: Text("Verifier")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Obx(
          () => ListView.builder(
            itemCount: messageController.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: _buildXTile(messageController.items[index]),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => ScanQrCode());
          receiveInvitation(qrCodeController.qrData.value);
        },
        //label: const Text('Scan'),
        //icon: const Icon(Symbols.qr_code_2),
        label: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(Symbols.qr_code_2),
            ),
            Text("Scan")
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildXTile(dynamic item) {
    final o = json.decode(item);
    final topic = o["topic"];
    final payload = o["payload"];
    //final state = o["payload"]["state"];
    //final payload =  o["payload"]
    if (topic == "connections") {
      return _buildConnectionTopic(payload);
    } else if (topic == "present_proof") {
      return _buildPresentProofTopic(payload);
    }
    return SizedBox.shrink();
  }

  Widget _buildListView(BuildContext context) {
    return GetBuilder(
      init: MessageController(),
      builder: (GetxController controller) {
        return Container();
      },
    );
  }

  Widget _buildConnectionTopic(dynamic payload) {
    final state = payload["state"];
    return Container(
        decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20)),
        child: Builder(
          builder: (context) {
            if (state == "active") {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You connected with: "),
                    Text(
                      payload["their_label"]!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    )
                  ],
                ),
              );
            } else {
              return Text(
                payload["state"]!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              );
              //return const SizedBox.shrink();
            }
          },
        ));
  }

  Widget _buildPresentProofTopic(dynamic payload) {
    Color color = Colors.purple.shade50;
    final state = payload["state"];
    final verified = payload["verified"];
    final presExId = payload["presentation_exchange_id"];
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Builder(builder: (context) {
        if (state == "presentation_sent") {
          return _buildTile(
            const Text("Requested for Present Proof"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("From ${payload["their_label"]}"),
                Text("Presentation sent automatically."),
              ],
            ),
            color: color,
          );
        } else if (state == "verified") {
          return _buildTile(
              const Text(
                "Present Proof",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Symbols.verified,
                        size: 30,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      const Text("Credential is Verified."),
                    ],
                  ),
                ],
              ),
              color: color);
        }
        return _buildTile(const Text("Present proof"), const Text(""));
      }),
    );
  }

  Widget _buildTile(Widget title, Widget subtitle, {Color? color}) {
    return Container(
      //height: 80,
      decoration: BoxDecoration(
          color: (color != null) ? color : Colors.green.shade50,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(title: title, subtitle: subtitle),
      ),
    );
  }
}
