import 'dart:ui';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../services/memory_service.dart';
import '../love_welcome_screen.dart';
import 'favourite_memories_screen.dart';

class MemoriesTab extends StatefulWidget {
  const MemoriesTab({super.key});

  @override
  State<MemoriesTab> createState() => _MemoriesTabState();
}

class _MemoriesTabState extends State<MemoriesTab> {
  final ImagePicker _picker = ImagePicker();

  bool _uploadingPhoto = false;
  bool _uploadingVideo = false;

  // ============================================================
  // PICK + UPLOAD PHOTO
  // ============================================================

  Future<void> _pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return;

      setState(() {
        _uploadingPhoto = true;
      });

      final String? result = await MemoryService.uploadPhoto(
        File(image.path),
      );

      if (!mounted) return;

      setState(() {
        _uploadingPhoto = false;
      });

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xffC2185B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            content: const Text(
              "❤️ Photo saved to your memories.",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to upload photo. Please try again.",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _uploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Photo upload error: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // PICK + UPLOAD VIDEO
  // ============================================================

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video == null) return;

      setState(() {
        _uploadingVideo = true;
      });

      final String? result = await MemoryService.uploadVideo(
        File(video.path),
      );

      if (!mounted) return;

      setState(() {
        _uploadingVideo = false;
      });

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xffC2185B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            content: const Text(
              "❤️ Video saved to your memories.",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to upload video. Please try again.",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _uploadingVideo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Video upload error: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ========================================================
        // BACKGROUND
        // ========================================================

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

        // ========================================================
        // FLOATING HEARTS
        // ========================================================

        Positioned(
          top: 80,
          left: 25,
          child: Icon(
            Icons.favorite,
            size: 90,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        Positioned(
          top: 240,
          right: 20,
          child: Icon(
            Icons.favorite,
            size: 70,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        Positioned(
          bottom: 90,
          left: 30,
          child: Icon(
            Icons.favorite,
            size: 110,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        // ========================================================
        // CONTENT
        // ========================================================

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                // ==================================================

                Text(
                  "📸 Memories",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Every smile, every laugh and every moment we've shared deserves to be remembered forever.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // ANIMATED LOVE STORIES
                // ==================================================

                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoveWelcomeScreen(),
                      ),
                    );
                  },
                  child: ClipRRect(
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
                        child: Row(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFE0EC),
                                borderRadius:
                                    BorderRadius.circular(22),
                              ),
                              child: const Center(
                                child: Text(
                                  "🎬",
                                  style: TextStyle(
                                    fontSize: 34,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Animated Love Stories",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color(0xffC2185B),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "Relive every animated chapter of our story together ❤️",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xffC2185B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // COLLECTION
                // ==================================================

                Text(
                  "Our Collection ❤️",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                _memoryCard(
                  emoji: "📸",
                  title: "Photo Gallery",
                  subtitle:
                      "Every picture we've captured together in one beautiful place.",
                  onTap: _pickPhoto,
                  loading: _uploadingPhoto,
                ),

                const SizedBox(height: 18),

                _memoryCard(
                  emoji: "🎥",
                  title: "Video Memories",
                  subtitle:
                      "Relive every laugh, smile and unforgettable moment.",
                  onTap: _pickVideo,
                  loading: _uploadingVideo,
                ),

                const SizedBox(height: 18),

                _memoryCard(
                  emoji: "❤️",
                  title: "Favourite Memories",
                  subtitle:
                      "The moments we never want to forget.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FavouriteMemoriesScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // MEMORY STATISTICS
                // ==================================================

                Text(
                  "Memory Statistics",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  stream: MemoryService.getMemories(),
                  builder: (context, snapshot) {
                    int photos = 0;
                    int videos = 0;
                    int favourites = 0;

                    if (snapshot.hasData) {
                      for (final doc in snapshot.data!.docs) {
                        final data = doc.data();

                        if (data['type'] == 'photo') {
                          photos++;
                        }

                        if (data['type'] == 'video') {
                          videos++;
                        }

                        if (data['isFavourite'] == true) {
                          favourites++;
                        }
                      }
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                emoji: "📸",
                                value: photos.toString(),
                                title: "Photos",
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: _statCard(
                                emoji: "🎥",
                                value: videos.toString(),
                                title: "Videos",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                emoji: "❤️",
                                value: favourites.toString(),
                                title: "Favourites",
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: _statCard(
                                emoji: "✨",
                                value:
                                    (photos + videos).toString(),
                                title: "Memories",
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // RECENT MEMORIES
                // ==================================================

                Text(
                  "Recent Memories",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  stream: MemoryService.getMemories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _loadingMemoryBox();
                    }

                    if (snapshot.hasError) {
                      return _emptyMemoryBox(
                        icon: Icons.error_outline,
                        title: "Something went wrong",
                        subtitle:
                            "We couldn't load your memories.",
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return _emptyMemoryBox(
                        icon: Icons.photo_library_outlined,
                        title: "No Memories Yet",
                        subtitle:
                            "Upload your first photo or video together ❤️",
                      );
                    }

                    return Column(
                      children: docs.map(
                        (doc) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 18),
                            child: _memoryItem(
                              doc,
                              docs,
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // CREATE NEW MEMORY
                // ==================================================

                Text(
                  "Create New Memory",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.45),
                    borderRadius: BorderRadius.circular(28),
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
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color(0xffE91E63),
                        size: 52,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Capture Another Beautiful Moment",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffC2185B),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Upload photos or videos and keep every beautiful memory safe forever.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _uploadingPhoto
                                  ? null
                                  : _pickPhoto,
                              icon: const Icon(
                                Icons.photo_camera,
                              ),
                              label: const Text("Photo"),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xffFF6F9D),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(22),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _uploadingVideo
                                  ? null
                                  : _pickVideo,
                              icon: const Icon(
                                Icons.videocam,
                              ),
                              label: const Text("Video"),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xffC2185B),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(22),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // FOOTER
                // ==================================================

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
                        "Every memory deserves forever ❤️",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffC2185B),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEMORY ITEM
  // ============================================================

  Widget _memoryItem(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs,
  ) {
    final data = doc.data();

    final String type =
        data['type']?.toString() ?? 'photo';

    final String url =
        data['url']?.toString() ?? '';

    final bool isFavourite =
        data['isFavourite'] == true;

    final Timestamp? timestamp =
        data['createdAt'] is Timestamp
            ? data['createdAt'] as Timestamp
            : null;

    String dateText = "Recently added";

    if (timestamp != null) {
      final date = timestamp.toDate();

      dateText =
          "${date.day}/${date.month}/${date.year}";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(26),
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
        children: [
          // ========================================================
          // PHOTO
          // ========================================================

          if (type == 'photo')
            GestureDetector(
              onTap: () {
                _openFullScreenGallery(
                  allDocs,
                  allDocs.indexOf(doc),
                );
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      url,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          height: 260,
                          color: const Color(0xffFFE6F2),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 55,
                              color: Color(0xffC2185B),
                            ),
                          ),
                        );
                      },
                    ),

                    // Gallery icon
                    Positioned(
                      right: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withOpacity(.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )

          // ========================================================
          // VIDEO
          // ========================================================

          else
            GestureDetector(
              onTap: () {
                _openFullScreenGallery(
                  allDocs,
                  allDocs.indexOf(doc),
                );
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffFFE6F2),
                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      size: 70,
                      color: Color(0xffC2185B),
                    ),

                    Positioned(
                      right: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withOpacity(.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ========================================================
          // DETAILS
          // ========================================================

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        type == 'photo'
                            ? "Photo Memory ❤️"
                            : "Video Memory 🎥",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              const Color(0xffC2185B),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        dateText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // FAVOURITE BUTTON
                // ==================================================

                IconButton(
                  tooltip: isFavourite
                      ? "Remove from favourites"
                      : "Add to favourites",
                  onPressed: () async {
                    await MemoryService.toggleFavourite(
                      doc.id,
                      isFavourite,
                    );
                  },
                  icon: Icon(
                    isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: const Color(0xffE91E63),
                  ),
                ),

                // ==================================================
                // DELETE BUTTON
                // ==================================================

                IconButton(
                  tooltip: "Delete",
                  onPressed: () {
                    _confirmDelete(doc.id);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FULL SCREEN GALLERY
  // ============================================================

  void _openFullScreenGallery(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    int initialIndex,
  ) {
    if (docs.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenMemoryGallery(
          memories: docs,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  Future<void> _confirmDelete(
    String documentId,
  ) async {
    final bool? result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete memory?",
          ),
          content: const Text(
            "This memory will be removed from LovePing.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xffC2185B),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await MemoryService.deleteMemory(
        documentId,
      );
    }
  }

  // ============================================================
  // MEMORY CARD
  // ============================================================

  Widget _memoryCard({
    required String emoji,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(26),
      onTap: loading ? null : onTap,
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(.45),
          borderRadius:
              BorderRadius.circular(26),
          border: Border.all(
            color:
                Colors.white.withOpacity(.60),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.pink.withOpacity(.08),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xffFFE0EC),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 3,
                          color:
                              Color(0xffC2185B),
                        ),
                      )
                    : Text(
                        emoji,
                        style:
                            const TextStyle(
                          fontSize: 30,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    loading
                        ? "Uploading..."
                        : title,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          const Color(
                        0xffC2185B,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 13,
                      color:
                          Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color:
                  Color(0xffC2185B),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required String emoji,
    required String value,
    required String title,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 22,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.45),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              Colors.white.withOpacity(.60),
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style:
                const TextStyle(
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style:
                GoogleFonts.poppins(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
              color:
                  const Color(
                0xffC2185B,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style:
                GoogleFonts.poppins(
              color:
                  Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY MEMORY BOX
  // ============================================================

  Widget _emptyMemoryBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.45),
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color:
              Colors.white.withOpacity(.60),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.pink.withOpacity(.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 55,
            color:
                Colors.pink.shade300,
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style:
                GoogleFonts.poppins(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
              color:
                  const Color(
                0xffC2185B,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              subtitle,
              textAlign:
                  TextAlign.center,
              style:
                  GoogleFonts.poppins(
                fontSize: 14,
                color:
                    Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING MEMORY BOX
  // ============================================================

  Widget _loadingMemoryBox() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration:
          BoxDecoration(
        color:
            Colors.white.withOpacity(.45),
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color:
              Colors.white.withOpacity(.60),
        ),
      ),
      child: const Center(
        child:
            CircularProgressIndicator(
          color:
              Color(0xffC2185B),
        ),
      ),
    );
  }
}

// =================================================================
// FULL SCREEN MEMORY GALLERY
// =================================================================

class FullScreenMemoryGallery extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> memories;
  final int initialIndex;

  const FullScreenMemoryGallery({
    super.key,
    required this.memories,
    required this.initialIndex,
  });

  @override
  State<FullScreenMemoryGallery> createState() =>
      _FullScreenMemoryGalleryState();
}

class _FullScreenMemoryGalleryState
    extends State<FullScreenMemoryGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex <= 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNext() {
    if (_currentIndex >= widget.memories.length - 1) return;

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ======================================================
            // PAGE VIEW
            // ======================================================

            PageView.builder(
              controller: _pageController,
              itemCount: widget.memories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final data =
                    widget.memories[index].data();

                final String type =
                    data['type']?.toString() ?? 'photo';

                final String url =
                    data['url']?.toString() ?? '';

                if (type == 'video') {
                  return FullScreenVideoPlayer(
                    key: ValueKey(url),
                    url: url,
                  );
                }

                return FullScreenPhotoViewer(
                  key: ValueKey(url),
                  url: url,
                );
              },
            ),

            // ======================================================
            // TOP BAR
            // ======================================================

            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.45),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_currentIndex + 1} / ${widget.memories.length}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // PREVIOUS BUTTON
            // ======================================================

            if (_currentIndex > 0)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _galleryArrowButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: _goToPrevious,
                  ),
                ),
              ),

            // ======================================================
            // NEXT BUTTON
            // ======================================================

            if (_currentIndex <
                widget.memories.length - 1)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _galleryArrowButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: _goToNext,
                  ),
                ),
              ),

            // ======================================================
            // BOTTOM GALLERY INDICATOR
            // ======================================================

            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Swipe to view memories ❤️",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.40),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

// =================================================================
// FULL SCREEN PHOTO VIEWER
// =================================================================

class FullScreenPhotoViewer extends StatelessWidget {
  final String url;

  const FullScreenPhotoViewer({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 5.0,
        panEnabled: true,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder:
              (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
          errorBuilder:
              (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 70,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Unable to load photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =================================================================
// FULL SCREEN VIDEO PLAYER
// =================================================================

class FullScreenVideoPlayer extends StatefulWidget {
  final String url;

  const FullScreenVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  State<FullScreenVideoPlayer> createState() =>
      _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState
    extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  bool _initializing = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _initializing = false;
      });

      await _controller.setLooping(false);

      // Start automatically when opened.
      await _controller.play();
    } catch (e) {
      debugPrint(
        "Full screen video error: $e",
      );

      if (!mounted) return;

      setState(() {
        _initializing = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    setState(() {});
  }

  String _formatDuration(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.video_library_outlined,
              color: Colors.white,
              size: 70,
            ),

            const SizedBox(height: 15),

            Text(
              "Unable to play this video",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Please check the video URL.",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (_initializing) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),

            // ======================================================
            // PLAY / PAUSE
            // ======================================================

            GestureDetector(
              onTap: _togglePlayPause,
              child: AnimatedOpacity(
                opacity:
                    _controller.value.isPlaying ? 0.0 : 1.0,
                duration:
                    const Duration(milliseconds: 200),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),

            // ======================================================
            // VIDEO CONTROLS
            // ======================================================

            Positioned(
              left: 14,
              right: 14,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.45),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    ValueListenableBuilder<
                        VideoPlayerValue>(
                      valueListenable: _controller,
                      builder: (
                        context,
                        value,
                        child,
                      ) {
                        return Text(
                          _formatDuration(
                            value.position,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),

                    Expanded(
                      child: ValueListenableBuilder<
                          VideoPlayerValue>(
                        valueListenable: _controller,
                        builder: (
                          context,
                          value,
                          child,
                        ) {
                          final total =
                              value.duration.inMilliseconds;

                          final position =
                              value.position.inMilliseconds;

                          final double sliderMax =
                              total <= 0
                                  ? 1
                                  : total.toDouble();

                          final double sliderValue =
                              position
                                  .clamp(
                                    0,
                                    total <= 0
                                        ? 1
                                        : total,
                                  )
                                  .toDouble();

                          return Slider(
                            min: 0,
                            max: sliderMax,
                            value: sliderValue,
                            activeColor:
                                const Color(0xffFF6F9D),
                            inactiveColor:
                                Colors.white30,
                            onChanged: (newValue) {
                              _controller.seekTo(
                                Duration(
                                  milliseconds:
                                      newValue.round(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    ValueListenableBuilder<
                        VideoPlayerValue>(
                      valueListenable: _controller,
                      builder: (
                        context,
                        value,
                        child,
                      ) {
                        return Text(
                          _formatDuration(
                            value.duration,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}