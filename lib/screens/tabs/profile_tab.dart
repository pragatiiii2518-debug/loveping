import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  // --------------------------------------------------
  // SIMPLE MESSAGE DIALOG
  // --------------------------------------------------

  void _showMessage(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xffC2185B),
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffE91E63),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // ANNIVERSARY
  // --------------------------------------------------

  Future<void> _selectAnniversary(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    _showMessage(
      context,
      "Anniversary 💕",
      "Your special date is ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}.",
    );
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            "Logout 💕",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xffC2185B),
            ),
          ),
          content: Text(
            "Are you sure you want to logout from LovePing?",
            style: GoogleFonts.poppins(
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE91E63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    // We don't force a new screen here.
    // Your existing authentication/navigation flow
    // can handle the signed-out state.
  }

  // --------------------------------------------------
  // INFO CARD TAP
  // --------------------------------------------------

  void _infoCardTap(
    BuildContext context,
    String title,
    String value,
  ) {
    if (title == "Love ID") {
      _showMessage(
        context,
        "Your Love ID 💗",
        "Your Love ID is:\n\n$value\n\nShare this ID with your partner so they can connect with you.",
      );
    } else if (title == "Partner") {
      _showMessage(
        context,
        "Your Person ❤️",
        "Your lovely and handsome partner is:\n\n$value",
      );
    } else if (title == "Relationship Status") {
      _showMessage(
        context,
        "Relationship Status 💕",
        "Your current relationship status is:\n\n$value",
      );
    }
  }

  // --------------------------------------------------
  // SETTINGS TAP
  // --------------------------------------------------

  void _settingsTap(
    BuildContext context,
    String title,
  ) {
    switch (title) {
      case "Privacy":
        _showMessage(
          context,
          "Privacy 🔒",
          "Your LovePing memories and connection are designed to stay private between you and your partner.",
        );
        break;

      case "Notifications":
        _showMessage(
          context,
          "Notifications 🔔",
          "Notification settings will be available here for LovePing reminders, heartbeats and partner activity.",
        );
        break;

      case "Appearance":
        _showMessage(
          context,
          "Appearance 🎨",
          "Appearance customization will be available here.",
        );
        break;

      case "Help & Support":
        _showMessage(
          context,
          "Help & Support 💕",
          "Need help with LovePing?\n\nYou can manage your account, connection and memories from the app.",
        );
        break;

      case "Logout":
        _logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //------------------------------------------
        // BACKGROUND
        //------------------------------------------

        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFFFDFE),
                  Color(0xffFFF2F8),
                  Color(0xffFFE5F1),
                ],
              ),
            ),
          ),
        ),

        //------------------------------------------
        // FLOATING HEARTS
        //------------------------------------------

        Positioned(
          top: 70,
          left: 20,
          child: Icon(
            Icons.favorite,
            size: 90,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        Positioned(
          bottom: 140,
          right: 25,
          child: Icon(
            Icons.favorite,
            size: 110,
            color: Colors.pink.withOpacity(.05),
          ),
        ),

        //------------------------------------------
        // MAIN CONTENT
        //------------------------------------------

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------------------------------
                // HEADER
                //------------------------------------------

                Text(
                  "👤 Profile",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Everything about you and your special connection lives here.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                //------------------------------------------
                // PROFILE CARD
                //------------------------------------------

                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 18,
                      sigmaY: 18,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor:
                                const Color(0xffFFE0EC),
                            child: const Icon(
                              Icons.person,
                              size: 52,
                              color: Color(0xffE91E63),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "Pragati ❤️",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffC2185B),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Hopeless Romantic ✨",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFFF4F8),
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            child: Text(
                              "❤️ Connected",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffC2185B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                //------------------------------------------
                // LOVE ID
                //------------------------------------------

                _infoCard(
                  context: context,
                  icon: Icons.favorite_rounded,
                  title: "Love ID",
                  value: "LOVE-PRAGATI-001",
                  onTap: () {
                    _infoCardTap(
                      context,
                      "Love ID",
                      "LOVE-PRAGATI-001",
                    );
                  },
                ),

                const SizedBox(height: 18),

                //------------------------------------------
                // PARTNER
                //------------------------------------------

                _infoCard(
                  context: context,
                  icon: Icons.favorite,
                  title: "Partner",
                  value: "Nishant ❤️",
                  onTap: () {
                    _infoCardTap(
                      context,
                      "Partner",
                      "Nishant ❤️",
                    );
                  },
                ),

                const SizedBox(height: 18),

                //------------------------------------------
                // RELATIONSHIP STATUS
                //------------------------------------------

                _infoCard(
                  context: context,
                  icon: Icons.favorite_border_rounded,
                  title: "Relationship Status",
                  value: "🤨 💕",
                  onTap: () {
                    _infoCardTap(
                      context,
                      "Relationship Status",
                      "🤨 💕",
                    );
                  },
                ),

                const SizedBox(height: 18),

                //------------------------------------------
                // ANNIVERSARY
                //------------------------------------------

                _infoCard(
                  context: context,
                  icon: Icons.calendar_month_rounded,
                  title: "Anniversary",
                  value: "Add Your Special Date",
                  onTap: () {
                    _selectAnniversary(context);
                  },
                ),

                const SizedBox(height: 30),

                //------------------------------------------
                // CONNECTION
                //------------------------------------------

                Text(
                  "Our Connection ❤️",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                //------------------------------------------
                // STATS ROW 1
                //------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        emoji: "❤️",
                        value: "∞",
                        title: "Love",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        emoji: "📸",
                        value: "0",
                        title: "Memories",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //------------------------------------------
                // STATS ROW 2
                //------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        emoji: "💌",
                        value: "0",
                        title: "Letters",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        emoji: "💓",
                        value: "0",
                        title: "Heartbeats",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                //------------------------------------------
                // SETTINGS
                //------------------------------------------

                Text(
                  "Settings",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffC2185B),
                  ),
                ),

                const SizedBox(height: 18),

                //------------------------------------------
                // PRIVACY
                //------------------------------------------

                _settingsCard(
                  context: context,
                  icon: Icons.lock_outline_rounded,
                  title: "Privacy",
                  subtitle:
                      "Your memories remain private between you two.",
                  onTap: () {
                    _settingsTap(context, "Privacy");
                  },
                ),

                const SizedBox(height: 16),

                //------------------------------------------
                // NOTIFICATIONS
                //------------------------------------------

                _settingsCard(
                  context: context,
                  icon: Icons.notifications_none_rounded,
                  title: "Notifications",
                  subtitle:
                      "Manage LovePing reminders and alerts.",
                  onTap: () {
                    _settingsTap(context, "Notifications");
                  },
                ),

                const SizedBox(height: 16),

                //------------------------------------------
                // APPEARANCE
                //------------------------------------------

                _settingsCard(
                  context: context,
                  icon: Icons.palette_outlined,
                  title: "Appearance",
                  subtitle:
                      "Customize your LovePing experience.",
                  onTap: () {
                    _settingsTap(context, "Appearance");
                  },
                ),

                const SizedBox(height: 16),

                //------------------------------------------
                // HELP
                //------------------------------------------

                _settingsCard(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  subtitle:
                      "Need help? We're always here for you.",
                  onTap: () {
                    _settingsTap(context, "Help & Support");
                  },
                ),

                const SizedBox(height: 30),

                //------------------------------------------
                // LOGOUT
                //------------------------------------------

                _settingsCard(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  subtitle:
                      "Sign out from LovePing safely.",
                  onTap: () {
                    _settingsTap(context, "Logout");
                  },
                ),

                const SizedBox(height: 35),

                //------------------------------------------
                // FOOTER
                //------------------------------------------

                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xffE91E63),
                        size: 28,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Made with Love ❤️",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffC2185B),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "LovePing",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          color: Colors.black54,
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

  // --------------------------------------------------
  // INFO CARD
  // --------------------------------------------------

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.45),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.60),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xffC2185B),
                size: 28,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xffC2185B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xffC2185B),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // LOVE STAT CARD
  // --------------------------------------------------

  Widget _statCard({
    required String emoji,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.60),
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 10),

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
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SETTINGS CARD
  // --------------------------------------------------

  Widget _settingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.45),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.60),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xffC2185B),
                size: 28,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffC2185B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xffC2185B),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}