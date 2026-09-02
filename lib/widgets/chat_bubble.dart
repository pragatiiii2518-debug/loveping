import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final DocumentSnapshot doc;
  final String currentUserId;

  final Function(String messageId, String emoji) onReact;

  const ChatBubble({
    super.key,
    required this.doc,
    required this.currentUserId,
    required this.onReact,
  });

  //---------------------------------------------------------
  // REACTION WIDGET
  //---------------------------------------------------------

  Widget reactionButton(
    BuildContext context,
    String emoji,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        onReact(
          doc.id,
          emoji,
        );
      },
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 34,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    final bool mine =
        data["senderId"] == currentUserId;

    final String type =
        data["type"] ?? "text";

    final Timestamp? ts =
        data["timestamp"];

    final DateTime time =
        ts?.toDate() ?? DateTime.now();

    final hour =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    //---------------------------------------------------------
    // MESSAGE TYPE
    //---------------------------------------------------------

    Widget messageWidget;

    if (type == "heart") {
      messageWidget = const Text(
        "❤️",
        style: TextStyle(fontSize: 72),
      );
    } else if (type == "hug") {
      messageWidget = const Text(
        "🤗",
        style: TextStyle(fontSize: 72),
      );
    } else if (type == "kiss") {
      messageWidget = const Text(
        "😘",
        style: TextStyle(fontSize: 72),
      );
    } else if (type == "gift") {
      messageWidget = const Text(
        "🎁",
        style: TextStyle(fontSize: 72),
      );
    } else if (type == "butterfly") {
      messageWidget = const Text(
        "🦋",
        style: TextStyle(fontSize: 72),
      );
    } else {
      messageWidget = Text(
        data["text"] ?? "",
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
      );
    }

    //---------------------------------------------------------
    // CHAT BUBBLE
    //---------------------------------------------------------

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          GestureDetector(
            //---------------------------------------------------------
            // LONG PRESS FOR REACTIONS
            //---------------------------------------------------------

            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                builder: (_) {
                  return SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        reactionButton(context, "❤️"),
                        reactionButton(context, "😘"),
                        reactionButton(context, "🥹"),
                        reactionButton(context, "🤗"),
                        reactionButton(context, "🦋"),
                      ],
                    ),
                  );
                },
              );
            },

            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 280,
              ),
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: mine
                    ? const Color(0xffFFE4EF)
                    : Colors.white,

                borderRadius: BorderRadius.only(
                  topLeft:
                      const Radius.circular(22),
                  topRight:
                      const Radius.circular(22),
                  bottomLeft:
                      Radius.circular(
                          mine ? 22 : 5),
                  bottomRight:
                      Radius.circular(
                          mine ? 5 : 22),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Center(
                    child: messageWidget,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Text(
                        hour,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),

                      if (mine)
                        Padding(
                          padding:
                              const EdgeInsets.only(
                                  left: 5),
                          child: Icon(
                            data["seen"]
                                ? Icons.done_all
                                : Icons.done,
                            color: data["seen"]
                                ? Colors.blue
                                : Colors.grey,
                            size: 16,
                          ),
                        ),
                    ],
                  ),

                  if ((data["reaction"] ?? "") != "")
                    Padding(
                      padding:
                          const EdgeInsets.only(
                              top: 6),
                      child: Text(
                        data["reaction"],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}