import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/components/messageTile.dart';
import 'package:etuloc/controllers/public_controller/chat_page.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MessagersPage extends StatelessWidget {
  MessagersPage({super.key});
  FireStoreService _firestoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Messages",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestoreService
                .listMessages(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 15,
                              ),
                          itemBuilder: (context, index) {
                            String otherUserID = data[index]["ids"][0] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? data[index]["ids"][0]
                                : data[index]["ids"][1];
                            return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(otherUserID)
                                    .get(),
                                builder: (context, snapshot) {
                                  final data = snapshot.data;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                      senderName: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .displayName!,
                                                      receiverID: otherUserID,
                                                      receiverName:
                                                          data["name"],
                                                    )));
                                      },
                                      child: MessageTile(
                                        name: data!["name"],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ],
                );
              }
              return const Center(
                  child: Text("You don't have any messages yet"));
            }),
      ),
    );
  }
}
