import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() =>
      _PlaylistScreenState();
}

class _PlaylistScreenState
    extends State<PlaylistScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> songs = [];

  List<Map<String, dynamic>> filteredSongs = [];

  @override
  void initState() {
    super.initState();

    loadSongs();

    searchController.addListener(searchSongs);
  }

  //--------------------------------------------------
  // LOAD PLAYLIST
  //--------------------------------------------------

  Future<void> loadSongs() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString("playlist");

    if (data != null) {

      songs =
          List<Map<String, dynamic>>.from(
        jsonDecode(data),
      );
    }

    filteredSongs = List.from(songs);

    setState(() {});
  }

  //--------------------------------------------------
  // SAVE PLAYLIST
  //--------------------------------------------------

  Future<void> saveSongs() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "playlist",
      jsonEncode(songs),
    );
  }

  //--------------------------------------------------
  // SEARCH SONGS
  //--------------------------------------------------

  void searchSongs() {

    final query =
        searchController.text.toLowerCase();

    filteredSongs = songs.where((song) {

      return song["title"]
              .toLowerCase()
              .contains(query) ||

          song["artist"]
              .toLowerCase()
              .contains(query);

    }).toList();

    setState(() {});
  }
    //--------------------------------------------------
  // ADD / EDIT SONG
  //--------------------------------------------------

  Future<void> showSongDialog({
    Map<String, dynamic>? oldData,
    int? index,
  }) async {

    final title = TextEditingController(
      text: oldData?["title"] ?? "",
    );

    final artist = TextEditingController(
      text: oldData?["artist"] ?? "",
    );

    final link = TextEditingController(
      text: oldData?["link"] ?? "",
    );

    final caption = TextEditingController(
      text: oldData?["caption"] ?? "",
    );

    bool favourite =
        oldData?["favourite"] ?? false;

    await showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),

              title: Text(
                oldData == null
                    ? "Add Song 🎵"
                    : "Edit Song 🎵",
                style: GoogleFonts.playfairDisplay(
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
                      decoration: const InputDecoration(
                        labelText: "Song Name",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: artist,
                      decoration: const InputDecoration(
                        labelText: "Artist",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: link,
                      decoration: const InputDecoration(
                        labelText:
                            "Spotify / YouTube Link",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: caption,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText:
                            "Caption (Our Song ❤️)",
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        const Text(
                          "❤️ Favourite",
                        ),

                        const Spacer(),

                        Switch(
                          value: favourite,
                          activeColor:
                              const Color(0xffE91E63),
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
                    backgroundColor:
                        const Color(0xffC2185B),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {

                    final data = {

                      "title": title.text,

                      "artist": artist.text,

                      "link": link.text,

                      "caption": caption.text,

                      "favourite": favourite,

                      "date":
                          DateTime.now().toString(),
                    };

                    if (index == null) {
                      songs.insert(0, data);
                    } else {
                      songs[index] = data;
                    }

                    await saveSongs();

                    filteredSongs =
                        List.from(songs);

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
  // DELETE SONG
  //--------------------------------------------------

  Future<void> deleteSong(int index) async {

    songs.removeAt(index);

    await saveSongs();

    filteredSongs = List.from(songs);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xffC2185B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Song"),
        onPressed: () {
          showSongDialog();
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
              Icons.music_note_rounded,
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
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "🎵 Our Playlist",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Every song reminds us of another beautiful memory together ❤️",
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search songs...",
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

                  const SizedBox(height: 24),

                  Expanded(
                    child: filteredSongs.isEmpty

                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [

                                Icon(
                                  Icons.library_music_rounded,
                                  size: 85,
                                  color: Colors.pink.withOpacity(.18),
                                ),

                                const SizedBox(height: 18),

                                Text(
                                  "No Songs Yet ❤️",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        const Color(0xffC2185B),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Tap 'Add Song' and\nstart creating your love playlist.",
                                  textAlign:
                                      TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          )

                        : ListView.builder(
                            itemCount:
                                filteredSongs.length,
                            itemBuilder:
                                (context, index) {

                              final song =
                                  filteredSongs[index];
                                                             return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 16,
                                    sigmaY: 16,
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
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [

                                            const Icon(
                                              Icons.music_note_rounded,
                                              color: Color(0xffE91E63),
                                            ),

                                            const SizedBox(width: 8),

                                            Expanded(
                                              child: Text(
                                                song["title"],
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

                                            if (song["favourite"])
                                              const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          "🎤 ${song["artist"]}",
                                          style:
                                              GoogleFonts.poppins(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          song["caption"],
                                          style:
                                              GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            height: 1.6,
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        InkWell(
                                          onTap: () {
                                            // Firebase phase:
                                            // launch Spotify/YouTube link
                                          },
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                      0xffFFE7F2)
                                                  .withOpacity(.8),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16),
                                            ),
                                            child: Row(
                                              children: [

                                                const Icon(
                                                  Icons.link_rounded,
                                                  color:
                                                      Color(0xffC2185B),
                                                ),

                                                const SizedBox(width: 8),

                                                Expanded(
                                                  child: Text(
                                                    song["link"],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                    style:
                                                        GoogleFonts
                                                            .poppins(
                                                      color: const Color(
                                                          0xffC2185B),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        Row(
                                          children: [

                                            OutlinedButton.icon(
                                              onPressed: () {
                                                showSongDialog(
                                                  oldData: song,
                                                  index: index,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              label:
                                                  const Text("Edit"),
                                            ),

                                            const SizedBox(width: 12),

                                            OutlinedButton.icon(
                                              onPressed: () {
                                                deleteSong(index);
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
                                              label:
                                                  const Text("Delete"),
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