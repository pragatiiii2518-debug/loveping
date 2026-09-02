import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenWhenScreen extends StatefulWidget {
  const OpenWhenScreen({super.key});

  @override
  State<OpenWhenScreen> createState() =>
      _OpenWhenScreenState();
}

class _OpenWhenScreenState
    extends State<OpenWhenScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> letters = [];

  List<Map<String, dynamic>> filteredLetters = [];

  @override
  void initState() {
    super.initState();

    loadLetters();

    searchController.addListener(searchLetters);
  }

  //--------------------------------------------------
  // LOAD LETTERS
  //--------------------------------------------------

  Future<void> loadLetters() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString("open_when_letters");

    if (data != null) {

      letters =
          List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    filteredLetters = List.from(letters);

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE LETTERS
  //--------------------------------------------------

  Future<void> saveLetters() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "open_when_letters",
      jsonEncode(letters),
    );
  }

  //--------------------------------------------------
  // SEARCH
  //--------------------------------------------------

  void searchLetters() {

    final query =
        searchController.text.toLowerCase();

    filteredLetters = letters.where((letter) {

      return letter["title"]
              .toLowerCase()
              .contains(query) ||

          letter["message"]
              .toLowerCase()
              .contains(query);

    }).toList();

    setState(() {});
  }
    //--------------------------------------------------
  // ADD / EDIT LETTER
  //--------------------------------------------------

  Future<void> showLetterDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final title = TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final message = TextEditingController(
      text: oldData?["message"] ?? "",
    );

    bool locked = oldData?["locked"] ?? true;

    final List<String> suggestions = [

      "Open when you're sad 😢",
      "Open when you miss me ❤️",
      "Open when you can't sleep 🌙",
      "Open on your birthday 🎂",
      "Open after our first fight 🥺",
      "Open when you're stressed 🤍",
      "Open when you need motivation 💪",
      "Open when you feel lonely 🫂",
      "Open after a long day 🌇",
      "Open before an exam 📚",
      "Open after your result 🎉",
      "Open when you feel like giving up 🌈",
      "Open when you're sick 🤒",
      "Open when you're angry 😤",
      "Open when you need a hug 🤗",
      "Open when you feel insecure 🌸",
      "Open when we're apart ✈️",
      "Open on New Year's Eve 🎆",
      "Open on Valentine's Day 🌹",
      "Open on our anniversary 💍",
      "Open when you need to smile 😊",
      "Open when you're overthinking 🌙",
      "Open when you feel unloved ❤️",
      "Open whenever you just want to hear from me 💌",
    ];

    await showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              title: Text(
                oldData == null
                    ? "New Letter 💌"
                    : "Edit Letter 💌",
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xffC2185B),
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: SingleChildScrollView(

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  DropdownButtonFormField<String>(
  isExpanded: true,

                      value: suggestions.contains(title.text)
                          ? title.text
                          : null,

                      decoration: const InputDecoration(
                        labelText: "Open When...",
                      ),

                      items: suggestions.map((item) {

                        return DropdownMenuItem(
                          value: item,
                          child: Text(
  item,
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
),
                        );

                      }).toList(),

                      onChanged: (value) {
                        title.text = value!;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
  controller: message,
  minLines: 6,
  maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: "Your Letter ❤️",
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        const Text("🔒 Locked"),

                        const Spacer(),

                        Switch(
                          value: locked,
                          activeColor: const Color(0xffE91E63),
                          onChanged: (value) {

                            setDialogState(() {
                              locked = value;
                            });

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC2185B),
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () async {

                    final letter = {

                      "title": title.text,
                      "message": message.text,
                      "locked": locked,
                      "opened": false,
                      "date": DateTime.now().toString(),

                    };

                    if (index == null) {
                      letters.insert(0, letter);
                    } else {
                      letters[index] = letter;
                    }

                    await saveLetters();

                    filteredLetters = List.from(letters);

                    setState(() {});

                    if (!mounted) return;

                    Navigator.pop(context);
                  },

                  child: Text(
                    oldData == null
                        ? "Save"
                        : "Update",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
    //--------------------------------------------------
  // DELETE LETTER
  //--------------------------------------------------

  Future<void> deleteLetter(int index) async {

    letters.removeAt(index);

    await saveLetters();

    filteredLetters = List.from(letters);

    setState(() {});
  }

  //--------------------------------------------------
  // OPEN LETTER
  //--------------------------------------------------

  Future<void> openLetter(int index) async {

    letters[index]["opened"] = true;

    await saveLetters();

    filteredLetters = List.from(letters);

    setState(() {});

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),

          title: Text(
            letters[index]["title"],
            style: GoogleFonts.playfairDisplay(
              color: const Color(0xffC2185B),
              fontWeight: FontWeight.bold,
            ),
          ),

         content: SizedBox(
  width: double.maxFinite,
  child: SingleChildScrollView(
    child: Text(
              letters[index]["message"],
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.8,
              ),
            ),
          ),
         ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            const Color(0xffC2185B),

        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),

        label: const Text("New Letter"),

        onPressed: () {
          showLetterDialog();
        },
      ),

      body: Stack(
        children: [

          //------------------------------------
          // BACKGROUND
          //------------------------------------

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
            bottom: 100,
            right: 20,
            child: Icon(
              Icons.favorite,
              size: 120,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "💌 Open When...",
                    style:
                        GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color:
                          const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Letters written with love, waiting for the perfect moment ❤️",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search letters...",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          Colors.white.withOpacity(.70),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: filteredLetters.isEmpty
                        ? Center(
                            child: Text(
                              "No letters yet ❤️",
                              textAlign:
                                  TextAlign.center,
                              style:
                                  GoogleFonts.poppins(
                                fontSize: 18,
                                color:
                                    Colors.black54,
                              ),
                            ),
                          )
                                                  : ListView.builder(
                            itemCount: filteredLetters.length,
                            itemBuilder: (context, index) {

                              final letter =
                                  filteredLetters[index];

                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 18,
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.45),
                                      borderRadius:
                                          BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(.60),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(.08),
                                          blurRadius: 18,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [

                                            Icon(
                                              letter["opened"]
                                                  ? Icons.mark_email_read_rounded
                                                  : Icons.mark_email_unread_rounded,
                                              color: const Color(0xffE91E63),
                                              size: 34,
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: Text(
                                                letter["title"],
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: const Color(
                                                      0xffC2185B),
                                                ),
                                              ),
                                            ),

                                            if (letter["locked"])
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.pink.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                ),
                                                child: Text(
                                                  "🔒 Locked",
                                                  style:
                                                      GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          letter["opened"]
                                              ? letter["message"]
                                              : "Tap to open this letter ❤️",
                                          maxLines: 3,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style:
                                              GoogleFonts.poppins(
                                            color: Colors.black54,
                                            height: 1.6,
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        Row(
                                          children: [

                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  openLetter(index);
                                                },
                                                icon: const Icon(
                                                  Icons.mail_outline,
                                                ),
                                                label: const Text(
                                                  "Open",
                                                ),
                                                style:
                                                    ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(
                                                          0xffFF6F9D),
                                                  foregroundColor:
                                                      Colors.white,
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            IconButton(
                                              onPressed: () {
                                                showLetterDialog(
                                                  oldData: letter,
                                                  index: index,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit_rounded,
                                                color:
                                                    Color(0xffC2185B),
                                              ),
                                            ),

                                            IconButton(
                                              onPressed: () {
                                                deleteLetter(index);
                                              },
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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