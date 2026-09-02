import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OurStoryScreen extends StatefulWidget {
  const OurStoryScreen({super.key});

  @override
  State<OurStoryScreen> createState() => _OurStoryScreenState();
}

class _OurStoryScreenState extends State<OurStoryScreen> {

  final TextEditingController _storyController =
      TextEditingController();

  String lastEdited = "Never";

  int wordCount = 0;

  @override
  void initState() {
    super.initState();

    _loadStory();

    _storyController.addListener(() {
      final text = _storyController.text;

      wordCount = text
          .trim()
          .split(RegExp(r'\s+'))
          .where((e) => e.isNotEmpty)
          .length;

      setState(() {});
    });
  }

  Future<void> _loadStory() async {
    final prefs = await SharedPreferences.getInstance();

    _storyController.text =
        prefs.getString("our_story") ?? "";

    lastEdited =
        prefs.getString("story_last_edit") ??
            "Never";

    wordCount = _storyController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .length;

    setState(() {});
  }

  Future<void> _saveStory() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();

    lastEdited =
        "${now.day}/${now.month}/${now.year}  ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    await prefs.setString(
      "our_story",
      _storyController.text,
    );

    await prefs.setString(
      "story_last_edit",
      lastEdited,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //--------------------------------------------------
          // BACKGROUND
          //--------------------------------------------------

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffFFFDFE),
                    Color(0xffFFF2F8),
                    Color(0xffFFE7F2),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 80,
            left: 20,
            child: Icon(
              Icons.favorite,
              size: 90,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          Positioned(
            bottom: 120,
            right: 20,
            child: Icon(
              Icons.favorite,
              size: 110,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //--------------------------------------------------
                  // BACK BUTTON
                  //--------------------------------------------------

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "📖 Our Story",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Every beautiful love story deserves to be written.\nWrite yours here forever ❤️",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),
                                    //--------------------------------------------------
                  // GLASS JOURNAL
                  //--------------------------------------------------

                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 18,
                        sigmaY: 18,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.45),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(.60),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(.10),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Once upon a time... ❤️",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffC2185B),
                              ),
                            ),

                            const SizedBox(height: 18),

                            TextField(
                              controller: _storyController,
                              maxLines: 18,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                height: 1.8,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Write how your story began...\n\nThe first meeting...\nThe first smile...\nThe first time you realised this person was special...",
                                hintStyle:
                                    GoogleFonts.poppins(
                                  color: Colors.black38,
                                  height: 1.8,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                                    //--------------------------------------------------
                  // WORD COUNT
                  //--------------------------------------------------

                  Row(
                    children: [

                      const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xffC2185B),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "$wordCount words",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffC2185B),
                        ),
                      ),

                      const Spacer(),

                      Text(
                        "Last edited:",
                        style: GoogleFonts.poppins(
                          color: Colors.black45,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        lastEdited,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  //--------------------------------------------------
                  // SAVE BUTTON
                  //--------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {

                        await _saveStory();

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xffC2185B),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            content: const Text(
                              "❤️ Your story has been saved.",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_rounded),
                      label: const Text("Save Our Story"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  //--------------------------------------------------
                  // FOOTER
                  //--------------------------------------------------

                  Center(
                    child: Column(
                      children: [

                        const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xffE91E63),
                          size: 30,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Some stories never end.\nThey only become more beautiful.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            color: const Color(0xffC2185B),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
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