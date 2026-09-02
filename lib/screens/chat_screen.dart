import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/chat_bubble.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {

  //---------------------------------------------------------
  // FIREBASE
  //---------------------------------------------------------

  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  //---------------------------------------------------------
  // CONTROLLERS
  //---------------------------------------------------------

  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final FocusNode messageFocus =
      FocusNode();

  final ImagePicker picker =
      ImagePicker();

  //---------------------------------------------------------
  // USER DETAILS
  //---------------------------------------------------------

  late String currentUserId;

  // Replace later with Nishant's UID
  String partnerId = "sE55sxTjYIgCNP7UUvlJPiK56Th2";

  late String chatRoomId;

  //---------------------------------------------------------
  // STATES
  //---------------------------------------------------------

  bool partnerOnline = false;

  bool partnerTyping = false;

  bool isSending = false;

  bool showEmojiPicker = false;

  bool showLoveActions = false;

  //---------------------------------------------------------
  // LOVE ACTIONS
  //---------------------------------------------------------

  final List<Map<String, dynamic>> loveActions = [

    {
      "emoji": "❤️",
      "title": "Heart",
      "type": "heart",
    },

    {
      "emoji": "🤗",
      "title": "Hug",
      "type": "hug",
    },

    {
      "emoji": "😘",
      "title": "Kiss",
      "type": "kiss",
    },

    {
      "emoji": "🦋",
      "title": "Butterflies",
      "type": "butterfly",
    },

    {
      "emoji": "🎁",
      "title": "Gift",
      "type": "gift",
    },

  ];

  //---------------------------------------------------------
  // INIT
  //---------------------------------------------------------

  @override
  void initState() {
    super.initState();

    currentUserId =
        auth.currentUser!.uid;
        debugPrint("MY UID: $currentUserId");

    chatRoomId =
        generateChatRoom(
          currentUserId,
          partnerId,
        );
        debugPrint("MY UID: $currentUserId");
debugPrint("PARTNER UID: $partnerId");
debugPrint("CHAT ROOM ID: $chatRoomId");

    listenPartnerStatus();

    listenTypingStatus();

    messageFocus.addListener(() {

      if (!messageFocus.hasFocus) {

        updateTyping(false);

      }

    });

  }

  //---------------------------------------------------------
  // GENERATE CHAT ROOM
  //---------------------------------------------------------

  String generateChatRoom(
      String id1,
      String id2,
      ) {

    if (id1.compareTo(id2) < 0) {

      return "${id1}_$id2";

    }

    return "${id2}_$id1";

  }

  //---------------------------------------------------------
  // ONLINE STATUS
  //---------------------------------------------------------

  void listenPartnerStatus() {

    firestore
        .collection("users")
        .doc(partnerId)
        .snapshots()
        .listen((snapshot) {

      if (!snapshot.exists) return;

      setState(() {

        partnerOnline =
            snapshot["online"] ?? false;

      });

    });

  }

  //---------------------------------------------------------
  // TYPING STATUS
  //---------------------------------------------------------

  void listenTypingStatus() {

    firestore
        .collection("typing")
        .doc(chatRoomId)
        .snapshots()
        .listen((snapshot) {

      if (!snapshot.exists) return;

      final data = snapshot.data();

      setState(() {

        partnerTyping =
            data?[partnerId] ?? false;

      });

    });

  }

  //---------------------------------------------------------
  // UPDATE TYPING
  //---------------------------------------------------------

  void updateTyping(bool value) {

    firestore
        .collection("typing")
        .doc(chatRoomId)
        .set({

      currentUserId: value,

    }, SetOptions(merge: true));

  }

  //---------------------------------------------------------
  // DISPOSE
  //---------------------------------------------------------

  @override
  void dispose() {

    messageController.dispose();

    scrollController.dispose();

    messageFocus.dispose();

    super.dispose();

  } 
    //---------------------------------------------------------
  // SEND MESSAGE
  //---------------------------------------------------------

  Future<void> sendMessage() async {

    if (messageController.text.trim().isEmpty) return;

    final text = messageController.text.trim();

    messageController.clear();

    updateTyping(false);

    await firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .add({

      "senderId": currentUserId,

      "receiverId": partnerId,

      "text": text,

      "type": "text",

      "timestamp": FieldValue.serverTimestamp(),

      "seen": false,

      "reaction": "",

    });

    scrollToBottom();

  }

  //---------------------------------------------------------
  // SEND LOVE ACTION
  //---------------------------------------------------------

  Future<void> sendLoveAction(String type) async {

    await firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .add({

      "senderId": currentUserId,

      "receiverId": partnerId,

      "text": "",

      "type": type,

      "timestamp": FieldValue.serverTimestamp(),

      "seen": false,

      "reaction": "",

    });

    setState(() {

      showLoveActions = false;

    });

    scrollToBottom();

  }

  //---------------------------------------------------------
  // AUTO SCROLL
  //---------------------------------------------------------

  void scrollToBottom() {

    Future.delayed(
      const Duration(milliseconds: 250),
      () {

        if (!scrollController.hasClients) return;

        scrollController.animateTo(

          scrollController.position.maxScrollExtent,

          duration: const Duration(milliseconds: 400),

          curve: Curves.easeOut,

        );

      },
    );

  }

  //---------------------------------------------------------
  // MESSAGE REACTION
  //---------------------------------------------------------

  Future<void> reactToMessage(
      String messageId,
      String emoji,
      ) async {

    await firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({

      "reaction": emoji,

    });

  }

  //---------------------------------------------------------
  // MARK AS READ
  //---------------------------------------------------------

  Future<void> markAsSeen(
      String messageId,
      ) async {

    await firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({

      "seen": true,

    });

  }
    //---------------------------------------------------------
  // CHAT MESSAGE BUBBLE
  //---------------------------------------------------------

  
    //---------------------------------------------------------
  // INPUT AREA
  //---------------------------------------------------------

  Widget buildInputArea() {

    return SafeArea(

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),

        decoration: const BoxDecoration(

          color: Colors.white,

          boxShadow: [

            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),

          ],

        ),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            //-------------------------------------------------
            // LOVE ACTION PANEL
            //-------------------------------------------------

            if (showLoveActions)

              Container(

                margin: const EdgeInsets.only(
                  bottom: 10,
                ),

                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(

                  color: Colors.pink.shade50,

                  borderRadius:
                      BorderRadius.circular(18),

                ),

                child: Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                  children: loveActions.map((item) {

                    return GestureDetector(

                      onTap: () {

                        sendLoveAction(
                          item["type"],
                        );

                      },

                      child: Column(

                        mainAxisSize: MainAxisSize.min,

                        children: [

                          Text(

                            item["emoji"],

                            style: const TextStyle(
                              fontSize: 32,
                            ),

                          ),

                          const SizedBox(height: 5),

                          Text(

                            item["title"],

                            style: GoogleFonts.poppins(
                              fontSize: 11,
                            ),

                          ),

                        ],

                      ),

                    );

                  }).toList(),

                ),

              ),

            //-------------------------------------------------
            // MESSAGE ROW
            //-------------------------------------------------

            Row(

              children: [

                //-------------------------------------------------
                // LOVE BUTTON
                //-------------------------------------------------

                IconButton(

                  onPressed: () {

                    setState(() {

                      showLoveActions =
                          !showLoveActions;

                    });

                  },

                  icon: const Icon(

                    Icons.favorite,

                    color: Colors.pink,

                  ),

                ),

                //-------------------------------------------------
                // EMOJI
                //-------------------------------------------------

                IconButton(

                  onPressed: () {

                    setState(() {

                      showEmojiPicker =
                          !showEmojiPicker;

                    });

                  },

                  icon: const Icon(

                    Icons.emoji_emotions,

                    color: Colors.orange,

                  ),

                ),

                //-------------------------------------------------
                // TEXT FIELD
                //-------------------------------------------------

                Expanded(

                  child: TextField(

                    controller:
                        messageController,

                    focusNode:
                        messageFocus,

                    onChanged: (value) {

                      updateTyping(

                        value.trim().isNotEmpty,

                      );

                    },

                    decoration: InputDecoration(

                      hintText:
                          "Message your love...",

                      filled: true,

                      fillColor:
                          Colors.grey.shade100,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(30),

                        borderSide:
                            BorderSide.none,

                      ),

                      contentPadding:
                          const EdgeInsets.symmetric(

                        horizontal: 18,

                        vertical: 12,

                      ),

                    ),

                  ),

                ),

                //-------------------------------------------------
                // CAMERA
                //-------------------------------------------------

                IconButton(

                  icon: const Icon(

                    Icons.camera_alt,

                    color: Colors.grey,

                  ),

                  onPressed: () async {

                    await picker.pickImage(

                      source:
                          ImageSource.camera,

                    );

                  },

                ),

                //-------------------------------------------------
                // GALLERY
                //-------------------------------------------------

                IconButton(

                  icon: const Icon(

                    Icons.photo,

                    color: Colors.grey,

                  ),

                  onPressed: () async {

                    await picker.pickImage(

                      source:
                          ImageSource.gallery,

                    );

                  },

                ),

                //-------------------------------------------------
                // MIC
                //-------------------------------------------------

                IconButton(

                  icon: const Icon(

                    Icons.mic,

                    color: Colors.grey,

                  ),

                  onPressed: () {

                    // Voice notes in next update

                  },

                ),

                //-------------------------------------------------
                // SEND BUTTON
                //-------------------------------------------------

                GestureDetector(

                  onTap: sendMessage,

                  child: Container(

                    height: 48,

                    width: 48,

                    decoration: const BoxDecoration(

                      color: Color(0xffFF5E9C),

                      shape: BoxShape.circle,

                    ),

                    child: const Icon(

                      Icons.send,

                      color: Colors.white,

                    ),

                  ),

                ),

              ],

            ),

          ],

        ),

      ),

    );

  }
    //---------------------------------------------------------
  // BUILD
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffFFF7FB),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.white,

        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),

          onPressed: () {

            Navigator.pop(context);

          },

        ),

        titleSpacing: 0,

        title: Row(

          children: [

            const CircleAvatar(

              radius: 22,

              backgroundImage: AssetImage(
                "assets/images/nishant.jpg",
              ),

            ),

            const SizedBox(width: 12),

            Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  "Nishant ❤️",

                  style: GoogleFonts.poppins(

                    fontWeight: FontWeight.bold,

                    fontSize: 18,

                    color: Colors.black,

                  ),

                ),

                Text(

                  partnerTyping
                      ? "Typing..."
                      : partnerOnline
                          ? "Online"
                          : "Offline",

                  style: GoogleFonts.poppins(

                    fontSize: 12,

                    color: partnerTyping
                        ? Colors.pink
                        : partnerOnline
                            ? Colors.green
                            : Colors.grey,

                  ),

                ),

              ],

            ),

          ],

        ),

      ),

      body: Column(

        children: [

          //-------------------------------------------------
          // CHAT LIST
          //-------------------------------------------------

          Expanded(

            child: StreamBuilder<QuerySnapshot>(

              stream: firestore

                  .collection("chats")

                  .doc(chatRoomId)

                  .collection("messages")

                  .orderBy(
                    "timestamp",
                    descending: false,
                  )

                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {

                  return const Center(

                    child:
                        CircularProgressIndicator(),

                  );

                }

                final docs =
                    snapshot.data!.docs;

                if (docs.isEmpty) {

                  return Center(

                    child: Text(

                      "Start your love conversation ❤️",

                      style:
                          GoogleFonts.poppins(

                        color: Colors.grey,

                        fontSize: 16,

                      ),

                    ),

                  );

                }

                return ListView.builder(

                  controller: scrollController,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 10,
                  ),

                  itemCount: docs.length,

                  itemBuilder:
                      (context, index) {

                   return ChatBubble(
  doc: docs[index],
  currentUserId: currentUserId,
  onReact: reactToMessage,
);

                  },

                );

              },

            ),

          ),

          //-------------------------------------------------
          // INPUT AREA
          //-------------------------------------------------

          buildInputArea(),

        ],

      ),

    );

  }

}