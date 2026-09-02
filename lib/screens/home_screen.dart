import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loveping/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("messages");

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LovePing ❤️"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: dbRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(
                    child: Text(
                      "No messages yet ❤️",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final data = snapshot.data!.snapshot.value
                    as Map<dynamic, dynamic>;

                final messages = data.entries.toList();

                messages.sort((a, b) {
                  final ta = a.value["time"] ?? 0;
                  final tb = b.value["time"] ?? 0;
                  return ta.compareTo(tb);
                });

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].value;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(msg["text"] ?? ""),
                        subtitle: Text(msg["sender"] ?? ""),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Logged in as",
            style: TextStyle(color: Colors.grey[700]),
          ),

          Text(
            user?.email ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Open Chat ❤️",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}