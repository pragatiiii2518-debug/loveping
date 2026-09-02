import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BucketListScreen extends StatefulWidget {
  const BucketListScreen({super.key});

  @override
  State<BucketListScreen> createState() =>
      _BucketListScreenState();
}

class _BucketListScreenState
    extends State<BucketListScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> dreams = [];

  List<Map<String, dynamic>> filteredDreams = [];

  @override
  void initState() {
    super.initState();

    loadDreams();

    searchController.addListener(searchDreams);
  }

  //--------------------------------------------------
  // LOAD
  //--------------------------------------------------

  Future<void> loadDreams() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString("bucket_list");

    if (data != null) {

      dreams =
          List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    filteredDreams = List.from(dreams);

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE
  //--------------------------------------------------

  Future<void> saveDreams() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "bucket_list",
      jsonEncode(dreams),
    );
  }

  //--------------------------------------------------
  // SEARCH
  //--------------------------------------------------

  void searchDreams() {

    final query =
        searchController.text.toLowerCase();

    filteredDreams = dreams.where((dream) {

      return dream["title"]
              .toLowerCase()
              .contains(query) ||

          dream["description"]
              .toLowerCase()
              .contains(query);

    }).toList();

    setState(() {});
  }
  //--------------------------------------------------
  // ADD / EDIT DREAM
  //--------------------------------------------------

  Future<void> showDreamDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final title = TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final description = TextEditingController(
      text: oldData?["description"] ?? "",
    );

    final targetDate = TextEditingController(
      text: oldData?["date"] ?? "",
    );

    String priority =
        oldData?["priority"] ?? "Medium";

    bool completed =
        oldData?["completed"] ?? false;

    await showDialog(
      context: context,
      builder: (_) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),

              title: Text(
                oldData == null
                    ? "New Dream ❤️"
                    : "Edit Dream ❤️",
                style:
                    GoogleFonts.playfairDisplay(
                  color: const Color(0xffC2185B),
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: title,
                      decoration:
                          const InputDecoration(
                        labelText: "Dream Title",
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: description,
                      maxLines: 4,
                      decoration:
                          const InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration:
                          const InputDecoration(
                        labelText: "Priority",
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "Low",
                          child: Text("⭐ Low"),
                        ),

                        DropdownMenuItem(
                          value: "Medium",
                          child: Text("⭐⭐ Medium"),
                        ),

                        DropdownMenuItem(
                          value: "High",
                          child: Text("⭐⭐⭐ High"),
                        ),
                      ],
                      onChanged: (value) {

                        setDialogState(() {
                          priority = value!;
                        });

                      },
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: targetDate,
                      readOnly: true,
                      decoration:
                          const InputDecoration(
                        labelText: "Target Date",
                        suffixIcon:
                            Icon(Icons.calendar_today),
                      ),
                      onTap: () async {

                        final picked =
                            await showDatePicker(
                          context: context,
                          firstDate:
                              DateTime(2024),
                          lastDate:
                              DateTime(2100),
                          initialDate:
                              DateTime.now(),
                        );

                        if (picked != null) {

                          targetDate.text =
                              "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        const Text(
                          "Completed",
                        ),

                        const Spacer(),

                        Switch(
                          value: completed,
                          activeColor:
                              const Color(0xffE91E63),
                          onChanged: (value) {

                            setDialogState(() {
                              completed = value;
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

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffC2185B),
                    foregroundColor:
                        Colors.white,
                  ),

                  onPressed: () async {

                    final dream = {

                      "title": title.text,

                      "description":
                          description.text,

                      "priority": priority,

                      "date": targetDate.text,

                      "completed": completed,

                      "created":
                          DateTime.now()
                              .toIso8601String(),
                    };

                    if (index == null) {

                      dreams.insert(0, dream);

                    } else {

                      dreams[index] = dream;
                    }

                    await saveDreams();

                    filteredDreams =
                        List.from(dreams);

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
  // DELETE DREAM
  //--------------------------------------------------

  Future<void> deleteDream(int index) async {

    dreams.removeAt(index);

    await saveDreams();

    filteredDreams = List.from(dreams);

    setState(() {});
  }

  //--------------------------------------------------
  // TOGGLE COMPLETED
  //--------------------------------------------------

  Future<void> toggleCompleted(int index) async {

    dreams[index]["completed"] =
        !(dreams[index]["completed"] as bool);

    await saveDreams();

    filteredDreams = List.from(dreams);

    setState(() {});
  }

  //--------------------------------------------------
  // STATISTICS
  //--------------------------------------------------

  int get completedDreams =>
      dreams.where((e) => e["completed"]).length;

  int get pendingDreams =>
      dreams.length - completedDreams;

  double get progress {

    if (dreams.isEmpty) return 0;

    return completedDreams / dreams.length;
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

        icon: const Icon(Icons.add),

        label: const Text("New Dream"),

        onPressed: () {
          showDreamDialog();
        },
      ),

      body: Stack(
        children: [

          //----------------------------------------
          // BACKGROUND
          //----------------------------------------

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

                  const SizedBox(height: 5),

                  Text(
                    "✨ Future Bucket List",
                    style:
                        GoogleFonts.playfairDisplay(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color:
                          const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Dream together. Achieve together. ❤️",
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
                      hintText: "Search dreams...",
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

                  Row(
                    children: [

                      Expanded(
                        child: _statCard(
                          "✨",
                          dreams.length.toString(),
                          "Dreams",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _statCard(
                          "✅",
                          completedDreams.toString(),
                          "Completed",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _statCard(
                          "⏳",
                          pendingDreams.toString(),
                          "Pending",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius:
                        BorderRadius.circular(20),
                    backgroundColor:
                        Colors.pink.shade100,
                    color:
                        const Color(0xffE91E63),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% Completed",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color:
                          const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: filteredDreams.isEmpty
                        ? Center(
                            child: Text(
                              "No dreams yet ❤️",
                              style:
                                  GoogleFonts.poppins(
                                fontSize: 18,
                                color:
                                    Colors.black54,
                              ),
                            ),
                          )
                                                  : ListView.builder(
                            itemCount: filteredDreams.length,
                            itemBuilder: (context, index) {

                              final dream =
                                  filteredDreams[index];

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
                                                dream["title"],
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize: 19,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color:
                                                      const Color(
                                                          0xffC2185B),
                                                ),
                                              ),
                                            ),

                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration:
                                                  BoxDecoration(
                                                color: dream[
                                                            "priority"] ==
                                                        "High"
                                                    ? Colors.red
                                                        .shade100
                                                    : dream["priority"] ==
                                                            "Medium"
                                                        ? Colors.orange
                                                            .shade100
                                                        : Colors.green
                                                            .shade100,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        18),
                                              ),
                                              child: Text(
                                                "⭐ ${dream["priority"]}",
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
                                          dream["description"],
                                          style:
                                              GoogleFonts.poppins(
                                            color:
                                                Colors.black54,
                                            height: 1.6,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        Row(
                                          children: [

                                            const Icon(
                                              Icons.calendar_today,
                                              size: 17,
                                              color: Color(
                                                  0xffC2185B),
                                            ),

                                            const SizedBox(width: 6),

                                            Text(
                                              dream["date"],
                                              style:
                                                  GoogleFonts
                                                      .poppins(
                                                color: Colors
                                                    .black54,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        Row(
                                          children: [

                                            Checkbox(
                                              value: dream[
                                                  "completed"],
                                              activeColor:
                                                  const Color(
                                                      0xffE91E63),
                                              onChanged: (_) {
                                                toggleCompleted(
                                                    index);
                                              },
                                            ),

                                            Text(
                                              dream["completed"]
                                                  ? "Completed ❤️"
                                                  : "Pending",
                                              style:
                                                  GoogleFonts
                                                      .poppins(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                                color: dream[
                                                        "completed"]
                                                    ? Colors.green
                                                    : Colors
                                                        .black54,
                                              ),
                                            ),

                                            const Spacer(),

                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_rounded,
                                                color: Color(
                                                    0xffC2185B),
                                              ),
                                              onPressed: () {
                                                showDreamDialog(
                                                  oldData:
                                                      dream,
                                                  index:
                                                      index,
                                                );
                                              },
                                            ),

                                            IconButton(
                                              icon: const Icon(
                                                Icons
                                                    .delete_rounded,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                deleteDream(
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
  // STAT CARD
  //--------------------------------------------------

  Widget _statCard(
    String emoji,
    String value,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(.60),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(.08),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [

          Text(
            emoji,
            style: const TextStyle(
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xffC2185B),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
