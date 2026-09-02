import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoveNotesScreen extends StatefulWidget {
  const LoveNotesScreen({super.key});

  @override
  State<LoveNotesScreen> createState() =>
      _LoveNotesScreenState();
}

class _LoveNotesScreenState
    extends State<LoveNotesScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> notes = [];

  List<Map<String, dynamic>> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();

    searchController.addListener(searchNotes);
  }

  //--------------------------------------------------
  // LOAD NOTES
  //--------------------------------------------------

  Future<void> loadNotes() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString("love_notes");

    if (data != null) {

      notes = List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    filteredNotes = List.from(notes);

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE NOTES
  //--------------------------------------------------

  Future<void> saveNotes() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "love_notes",
      jsonEncode(notes),
    );
  }

  //--------------------------------------------------
  // SEARCH
  //--------------------------------------------------

  void searchNotes() {

    final query =
        searchController.text.toLowerCase();

    filteredNotes = notes.where((note) {

      return note["title"]
              .toLowerCase()
              .contains(query) ||
          note["note"]
              .toLowerCase()
              .contains(query);

    }).toList();

    setState(() {});
  }
    //--------------------------------------------------
  // ADD / EDIT NOTE
  //--------------------------------------------------

  Future<void> showNoteDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final title = TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final note = TextEditingController(
      text: oldData?["note"] ?? "",
    );

    bool pinned = oldData?["pinned"] ?? false;

    await showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25),
              ),

              title: Text(
                oldData == null
                    ? "New Love Note ❤️"
                    : "Edit Love Note ❤️",
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffC2185B),
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: title,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: note,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Write your love note...",
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        const Text(
                          "📌 Pin this note",
                        ),

                        const Spacer(),

                        Switch(
                          value: pinned,
                          activeColor:
                              const Color(0xffE91E63),
                          onChanged: (value) {

                            setDialogState(() {
                              pinned = value;
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
                    backgroundColor:
                        const Color(0xffC2185B),
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () async {

                    final data = {
                      "title": title.text,
                      "note": note.text,
                      "pinned": pinned,
                      "date":
                          DateTime.now()
                              .toString(),
                    };

                    if (index == null) {
                      notes.insert(0, data);
                    } else {
                      notes[index] = data;
                    }

                    await saveNotes();

                    filteredNotes = List.from(notes);

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
  // DELETE NOTE
  //--------------------------------------------------

  Future<void> deleteNote(int index) async {

    notes.removeAt(index);

    await saveNotes();

    filteredNotes = List.from(notes);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xffC2185B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("New Note"),
        onPressed: () {
          showNoteDialog();
        },
      ),

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
            top: 90,
            left: 20,
            child: Icon(
              Icons.favorite,
              size: 90,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          Positioned(
            bottom: 130,
            right: 15,
            child: Icon(
              Icons.favorite,
              size: 120,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "💌 Love Notes",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Write little love letters, reminders and beautiful memories for each other ❤️",
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 22),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search notes...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withOpacity(.70),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Expanded(
                    child: filteredNotes.isEmpty
                        ? Center(
                            child: Text(
                              "No Love Notes Yet ❤️",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredNotes.length,
                            itemBuilder: (context, index) {

                              final note = filteredNotes[index];
                                                            return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(24),

                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 16,
                                    sigmaY: 16,
                                  ),

                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(
                                            bottom: 18),

                                    padding:
                                        const EdgeInsets.all(18),

                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(.45),

                                      borderRadius:
                                          BorderRadius.circular(
                                              24),

                                      border: Border.all(
                                        color: Colors.white
                                            .withOpacity(.60),
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink
                                              .withOpacity(.08),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        Row(
                                          children: [

                                            if (note["pinned"])
                                              const Icon(
                                                Icons.push_pin_rounded,
                                                color: Color(
                                                    0xffE91E63),
                                              ),

                                            if (note["pinned"])
                                              const SizedBox(
                                                  width: 8),

                                            Expanded(
                                              child: Text(
                                                note["title"],
                                                style:
                                                    GoogleFonts
                                                        .poppins(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: const Color(
                                                      0xffC2185B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        Text(
                                          note["note"],
                                          style:
                                              GoogleFonts.poppins(
                                            fontSize: 15,
                                            color:
                                                Colors.black87,
                                            height: 1.6,
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        Text(
                                          note["date"],
                                          style:
                                              GoogleFonts.poppins(
                                            fontSize: 12,
                                            color:
                                                Colors.black45,
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        Row(
                                          children: [

                                            OutlinedButton.icon(
                                              onPressed: () {
                                                showNoteDialog(
                                                  oldData:
                                                      note,
                                                  index: index,
                                                );
                                              },

                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),

                                              label: const Text(
                                                  "Edit"),
                                            ),

                                            const SizedBox(
                                                width: 12),

                                            OutlinedButton.icon(
                                              onPressed: () {
                                                deleteNote(
                                                    index);
                                              },

                                              style:
                                                  OutlinedButton
                                                      .styleFrom(
                                                foregroundColor:
                                                    Colors.red,
                                              ),

                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                              ),

                                              label: const Text(
                                                  "Delete"),
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