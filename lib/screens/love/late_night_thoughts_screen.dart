import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LateNightThoughtsScreen extends StatefulWidget {
  const LateNightThoughtsScreen({super.key});

  @override
  State<LateNightThoughtsScreen> createState() =>
      _LateNightThoughtsScreenState();
}

class _LateNightThoughtsScreenState
    extends State<LateNightThoughtsScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> thoughts = [];

  List<Map<String, dynamic>> filteredThoughts = [];

  @override
  void initState() {
    super.initState();

    loadThoughts();

    searchController.addListener(searchThoughts);
  }

  //--------------------------------------------------
  // LOAD
  //--------------------------------------------------

  Future<void> loadThoughts() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString("late_night_thoughts");

    if (data != null) {

      thoughts =
          List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    filteredThoughts = List.from(thoughts);

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE
  //--------------------------------------------------

  Future<void> saveThoughts() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "late_night_thoughts",
      jsonEncode(thoughts),
    );
  }

  //--------------------------------------------------
  // SEARCH
  //--------------------------------------------------

  void searchThoughts() {

    final query =
        searchController.text.toLowerCase();

    filteredThoughts = thoughts.where((thought) {

      return thought["text"]
              .toLowerCase()
              .contains(query) ||

          thought["mood"]
              .toLowerCase()
              .contains(query);

    }).toList();

    setState(() {});
  }
    //--------------------------------------------------
  // ADD / EDIT THOUGHT
  //--------------------------------------------------

  Future<void> showThoughtDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final title = TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final thought = TextEditingController(
      text: oldData?["text"] ?? "",
    );

    final location = TextEditingController(
      text: oldData?["location"] ?? "",
    );

    String mood = oldData?["mood"] ?? "🥰 Happy";

    String category =
        oldData?["category"] ?? "Love";

    bool favourite =
        oldData?["favourite"] ?? false;

    await showDialog(
      context: context,
      builder: (_) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),

              title: Text(
                oldData == null
                    ? "🌙 New Thought"
                    : "✍ Edit Thought",
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

                    const SizedBox(height: 14),

                    TextField(
                      controller: thought,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "What's on your heart?",
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: mood,
                      decoration: const InputDecoration(
                        labelText: "Mood",
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "🥰 Happy",
                          child: Text("🥰 Happy"),
                        ),

                        DropdownMenuItem(
                          value: "❤️ In Love",
                          child: Text("❤️ In Love"),
                        ),

                        DropdownMenuItem(
                          value: "🥺 Missing You",
                          child: Text("🥺 Missing You"),
                        ),

                        DropdownMenuItem(
                          value: "😔 Sad",
                          child: Text("😔 Sad"),
                        ),

                        DropdownMenuItem(
                          value: "🤗 Grateful",
                          child: Text("🤗 Grateful"),
                        ),

                        DropdownMenuItem(
                          value: "🥹 Emotional",
                          child: Text("🥹 Emotional"),
                        ),

                        DropdownMenuItem(
                          value: "😍 Excited",
                          child: Text("😍 Excited"),
                        ),

                        DropdownMenuItem(
                          value: "😴 Sleepy",
                          child: Text("😴 Sleepy"),
                        ),
                      ],
                      onChanged: (value) {

                        setDialogState(() {
                          mood = value!;
                        });

                      },
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: "Category",
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "Love",
                          child: Text("❤️ Love"),
                        ),

                        DropdownMenuItem(
                          value: "Missing You",
                          child: Text("🥺 Missing You"),
                        ),

                        DropdownMenuItem(
                          value: "Gratitude",
                          child: Text("🤗 Gratitude"),
                        ),

                        DropdownMenuItem(
                          value: "Dream",
                          child: Text("🌙 Dream"),
                        ),

                        DropdownMenuItem(
                          value: "Fight",
                          child: Text("💔 Fight"),
                        ),

                        DropdownMenuItem(
                          value: "Random",
                          child: Text("✨ Random"),
                        ),
                      ],
                      onChanged: (value) {

                        setDialogState(() {
                          category = value!;
                        });

                      },
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: location,
                      decoration: const InputDecoration(
                        labelText: "Location (Optional)",
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [

                        const Text(
                          "⭐ Favourite",
                        ),

                        const Spacer(),

                        Switch(
                          value: favourite,
                          activeColor: const Color(0xffE91E63),
                          onChanged: (value) {

                            setDialogState(() {
                              favourite = value;
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

                    final item = {

                      "title": title.text,

                      "text": thought.text,

                      "mood": mood,

                      "category": category,

                      "location": location.text,

                      "favourite": favourite,

                      "date":
                          DateTime.now().toString(),
                    };

                    if (index == null) {
                      thoughts.insert(0, item);
                    } else {
                      thoughts[index] = item;
                    }

                    await saveThoughts();

                    filteredThoughts =
                        List.from(thoughts);

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
  // DELETE THOUGHT
  //--------------------------------------------------

  Future<void> deleteThought(int index) async {

    thoughts.removeAt(index);

    await saveThoughts();

    filteredThoughts = List.from(thoughts);

    setState(() {});
  }

  //--------------------------------------------------
  // TOGGLE FAVOURITE
  //--------------------------------------------------

  Future<void> toggleFavourite(int index) async {

    thoughts[index]["favourite"] =
        !(thoughts[index]["favourite"] as bool);

    await saveThoughts();

    filteredThoughts = List.from(thoughts);

    setState(() {});
  }

  //--------------------------------------------------
  // UI
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            const Color(0xffC2185B),

        foregroundColor: Colors.white,

        icon: const Icon(Icons.nightlight_round),

        label: const Text("New Thought"),

        onPressed: () {
          showThoughtDialog();
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
                    Color(0xffFFE6F2),
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
            bottom: 100,
            right: 25,
            child: Icon(
              Icons.favorite,
              size: 110,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),

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

                  const SizedBox(height: 8),

                  Text(
                    "🌙 Late Night Thoughts",
                    style:
                        GoogleFonts.playfairDisplay(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Write everything your heart wants to say ❤️",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText:
                          "Search your thoughts...",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          Colors.white.withOpacity(.75),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Expanded(
                    child: filteredThoughts.isEmpty
                        ? Center(
                            child: Text(
                              "No thoughts yet ❤️",
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
                            itemCount: filteredThoughts.length,
                            itemBuilder: (context, index) {

                              final thought =
                                  filteredThoughts[index];

                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(
                                      bottom: 18,
                                    ),
                                    padding:
                                        const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(.45),
                                      borderRadius:
                                          BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white
                                            .withOpacity(.60),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink
                                              .withOpacity(.08),
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

                                            Expanded(
                                              child: Text(
                                                thought["title"],
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize: 19,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: const Color(
                                                      0xffC2185B),
                                                ),
                                              ),
                                            ),

                                            if (thought["favourite"])
                                              const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [

                                            Chip(
                                              label: Text(
                                                  thought["mood"]),
                                              backgroundColor:
                                                  Colors.pink.shade50,
                                            ),

                                            Chip(
                                              label: Text(
                                                  thought["category"]),
                                              backgroundColor:
                                                  Colors.purple
                                                      .shade50,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          thought["text"],
                                          style:
                                              GoogleFonts.poppins(
                                            color: Colors.black87,
                                            height: 1.7,
                                          ),
                                        ),

                                        if (thought["location"]
                                            .toString()
                                            .isNotEmpty) ...[

                                          const SizedBox(height: 12),

                                          Row(
                                            children: [

                                              const Icon(
                                                Icons.location_on,
                                                size: 18,
                                                color: Color(
                                                    0xffC2185B),
                                              ),

                                              const SizedBox(width: 6),

                                              Expanded(
                                                child: Text(
                                                  thought[
                                                      "location"],
                                                  style:
                                                      GoogleFonts
                                                          .poppins(
                                                    color: Colors
                                                        .black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],

                                        const SizedBox(height: 12),

                                        Row(
                                          children: [

                                            const Icon(
                                              Icons.access_time,
                                              size: 18,
                                              color: Color(
                                                  0xffC2185B),
                                            ),

                                            const SizedBox(width: 6),

                                            Expanded(
                                              child: Text(
                                                thought["date"],
                                                style:
                                                    GoogleFonts
                                                        .poppins(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .black45,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        Row(
                                          children: [

                                            IconButton(
                                              icon: Icon(
                                                thought["favourite"]
                                                    ? Icons.favorite
                                                    : Icons
                                                        .favorite_border,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                toggleFavourite(
                                                    index);
                                              },
                                            ),

                                            const Spacer(),

                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Color(
                                                    0xffC2185B),
                                              ),
                                              onPressed: () {
                                                showThoughtDialog(
                                                  oldData:
                                                      thought,
                                                  index: index,
                                                );
                                              },
                                            ),

                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                deleteThought(
                                                    index);
                                              },
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
    //--------------------------------------------------
  // DISPOSE
  //--------------------------------------------------

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
