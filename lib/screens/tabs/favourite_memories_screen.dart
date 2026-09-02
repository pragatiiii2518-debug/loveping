import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../services/memory_service.dart';

class FavouriteMemoriesScreen extends StatelessWidget {
  const FavouriteMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ==================================================
          // BACKGROUND
          // ==================================================

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

          // ==================================================
          // FLOATING HEARTS
          // ==================================================

          Positioned(
            top: 80,
            right: 20,
            child: Icon(
              Icons.favorite,
              size: 110,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          Positioned(
            bottom: 100,
            left: 20,
            child: Icon(
              Icons.favorite,
              size: 90,
              color: Colors.pink.withOpacity(.05),
            ),
          ),

          // ==================================================
          // CONTENT
          // ==================================================

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // BACK BUTTON
                  // ==================================================

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

                  // ==================================================
                  // HEADER
                  // ==================================================

                  Text(
                    "❤️ Favourite Memories",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffC2185B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "The little moments that mean the most to us.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // FIRESTORE FAVOURITES
                  // ==================================================

                  StreamBuilder<
                      QuerySnapshot<Map<String, dynamic>>>(
                    stream:
                        MemoryService.getFavouriteMemories(),
                    builder: (context, snapshot) {
                      // ------------------------------------------------
                      // LOADING
                      // ------------------------------------------------

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return _loadingBox();
                      }

                      // ------------------------------------------------
                      // ERROR
                      // ------------------------------------------------

                      if (snapshot.hasError) {
                        return _emptyBox(
                          icon: Icons.error_outline,
                          title: "Something went wrong",
                          subtitle:
                              "We couldn't load your favourite memories.",
                        );
                      }

                      final docs =
                          snapshot.data?.docs ?? [];

                      // ------------------------------------------------
                      // EMPTY
                      // ------------------------------------------------

                      if (docs.isEmpty) {
                        return _emptyBox(
                          icon: Icons.favorite_border_rounded,
                          title:
                              "No Favourite Memories Yet",
                          subtitle:
                              "Tap the ❤️ icon on any memory to save it here.",
                        );
                      }

                      // ------------------------------------------------
                      // FAVOURITE MEMORIES
                      // ------------------------------------------------

                      return Column(
                        children: docs.map((doc) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: _FavouriteMemoryCard(
                              document: doc,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // FOOTER
                  // ==================================================

                  Center(
                    child: Text(
                      "Some moments deserve to stay forever. 💕",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        color: const Color(0xffC2185B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // EMPTY BOX
  // ==================================================

  Widget _emptyBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.45),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(.60),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.pink.shade300,
              ),

              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffC2185B),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // LOADING BOX
  // ==================================================

  Widget _loadingBox() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(.60),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xffC2185B),
        ),
      ),
    );
  }
}

// ==========================================================
// FAVOURITE MEMORY CARD
// ==========================================================

class _FavouriteMemoryCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  const _FavouriteMemoryCard({
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final data = document.data();

    final String type =
        data['type']?.toString() ?? 'photo';

    final String url =
        data['url']?.toString() ?? '';

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: double.infinity,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // MEDIA
              // ==================================================

              if (type == 'photo')
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  child: Image.network(
                    url,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 280,
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
                )
              else
                _FavouriteVideoPreview(
                  url: url,
                ),

              // ==================================================
              // DETAILS
              // ==================================================

              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Text(
                      "❤️",
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            type == 'photo'
                                ? "Favourite Photo"
                                : "Favourite Video",
                            style:
                                GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  const Color(0xffC2185B),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            dateText,
                            style:
                                GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // REMOVE FAVOURITE
                    // ==================================================

                    IconButton(
                      tooltip:
                          "Remove from favourites",
                      onPressed: () async {
                        await MemoryService
                            .removeFromFavourite(
                          document.id,
                        );
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Color(0xffE91E63),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// VIDEO PREVIEW
// ==========================================================

class _FavouriteVideoPreview extends StatefulWidget {
  final String url;

  const _FavouriteVideoPreview({
    required this.url,
  });

  @override
  State<_FavouriteVideoPreview> createState() =>
      _FavouriteVideoPreviewState();
}

class _FavouriteVideoPreviewState
    extends State<_FavouriteVideoPreview> {
  VideoPlayerController? _controller;

  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );

      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        height: 220,
        width: double.infinity,
        color: const Color(0xffFFE6F2),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xffC2185B),
          ),
        ),
      );
    }

    if (_error || _controller == null) {
      return Container(
        height: 220,
        width: double.infinity,
        color: const Color(0xffFFE6F2),
        child: const Center(
          child: Icon(
            Icons.video_library_outlined,
            size: 65,
            color: Color(0xffC2185B),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller!.value.isPlaying) {
            _controller!.pause();
          } else {
            _controller!.play();
          }
        });
      },
      child: Container(
        height: 220,
        width: double.infinity,
        color: Colors.black12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width:
                      _controller!.value.size.width,
                  height:
                      _controller!.value.size.height,
                  child: VideoPlayer(
                    _controller!,
                  ),
                ),
              ),
            ),

            if (!_controller!.value.isPlaying)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius:
                      BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.all(10),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 45,
                ),
              ),
          ],
        ),
      ),
    );
  }
}