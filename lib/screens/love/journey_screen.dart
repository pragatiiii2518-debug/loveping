import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {

  List<Map<String, dynamic>> milestones = [];

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  //--------------------------------------------------
  // LOAD DATA
  //--------------------------------------------------

  Future<void> _loadMilestones() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("journey_data");

    if (data != null) {
      milestones =
          List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE DATA
  //--------------------------------------------------

  Future<void> _saveMilestones() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "journey_data",
      jsonEncode(milestones),
    );
  }

  //--------------------------------------------------
  // DELETE
  //--------------------------------------------------

  Future<void> _deleteMilestone(int index) async {

    milestones.removeAt(index);

    await _saveMilestones();

    setState(() {});
  }

  //--------------------------------------------------
  // ADD / EDIT
  //--------------------------------------------------

  Future<void> _showMilestoneDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final emoji =
        TextEditingController(
      text: oldData?["emoji"] ?? "❤️",
    );

    final title =
        TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final desc =
        TextEditingController(
      text: oldData?["desc"] ?? "",
    );

    final date =
        TextEditingController(
      text: oldData?["date"] ?? "",
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),

          title: Text(
            oldData == null
                ? "Add Milestone ❤️"
                : "Edit Milestone ❤️",
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
                  controller: emoji,
                  decoration: const InputDecoration(
                    labelText: "Emoji",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: "Milestone Title",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: desc,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: date,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {

                    final picked =
                        await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );

                    if (picked != null) {
                      date.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },
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

                final milestone = {
                  "emoji": emoji.text.isEmpty
                      ? "❤️"
                      : emoji.text,
                  "title": title.text,
                  "desc": desc.text,
                  "date": date.text,
                };

                if (index == null) {
                  milestones.add(milestone);
                } else {
                  milestones[index] = milestone;
                }

                await _saveMilestones();

                if (!mounted) return;

                setState(() {});

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
        label: const Text("Add Milestone"),
        onPressed: () {
          _showMilestoneDialog();
        },
      ),

      body: Stack(
        children: [

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
            bottom: 120,
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "💕 Our Journey",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Every milestone tells another beautiful chapter of our love story ❤️",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: milestones.isEmpty

                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [

                                Icon(
                                  Icons.favorite,
                                  size: 90,
                                  color: Colors.pink.withOpacity(.18),
                                ),

                                const SizedBox(height: 20),

                                Text(
                                  "No Milestones Yet ❤️",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xffC2185B),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Tap the button below\nand create your first memory.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          )

                        : ListView.builder(
                            itemCount: milestones.length,
                            itemBuilder: (context, index) {

                              final item = milestones[index];

                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 18),
                                padding:
                                    const EdgeInsets.all(18),

                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withOpacity(.45),
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
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),

                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item["emoji"],
                                      style: const TextStyle(
                                        fontSize: 34,
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [

                                          Text(
                                            item["title"],
                                            style:
                                                GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold,
                                              color:
                                                  const Color(0xffC2185B),
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            item["date"],
                                            style:
                                                GoogleFonts.poppins(
                                              color: Colors.black45,
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          Text(
                                            item["desc"],
                                            style:
                                                GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              height: 1.6,
                                            ),
                                          ),

                                          const SizedBox(height: 18),

                                          Row(
                                            children: [
                                                                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  _showMilestoneDialog(
                                                    oldData: item,
                                                    index: index,
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit_rounded,
                                                  size: 18,
                                                ),
                                                label: const Text("Edit"),
                                              ),

                                              const SizedBox(width: 12),

                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  _deleteMilestone(index);
                                                },
                                                style:
                                                    OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                icon: const Icon(
                                                  Icons.delete_rounded,
                                                  size: 18,
                                                ),
                                                label:
                                                    const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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