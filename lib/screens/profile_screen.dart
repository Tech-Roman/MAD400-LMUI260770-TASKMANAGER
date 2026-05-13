import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isWide = screenWidth > 750;
        const primaryColor = Color(0xFF228B22);

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                Container(
                  width: double.infinity,
                  height: isWide ? 300 : screenHeight * 0.4,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: Text(
                                "FR",
                                style: TextStyle(
                                  fontSize: 36,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Fuafuelaka Romanus",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "LMUI260770",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Software Engineering",
                              style: TextStyle(
                                color: Colors.white.withAlpha(230),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildSectionBlock(
                                    title: "Bio",
                                    icon: Icons.person_outline,
                                    primaryColor: primaryColor,
                                    child: const Text(
                                      "I am passionate about learning mobile app development and software engineering. I enjoy solving problems and building modern applications.",
                                      style: TextStyle(fontSize: 15, height: 1.5),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildSectionBlock(
                                    title: "Semester Goals",
                                    icon: Icons.flag_outlined,
                                    primaryColor: primaryColor,
                                    child: Column(
                                      children: [
                                        _buildGoalItem("Improve Flutter skills", primaryColor),
                                        _buildGoalItem("Build strong portfolio", primaryColor),
                                        _buildGoalItem("Pass all courses", primaryColor),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildSectionBlock(
                                  title: "Bio",
                                  icon: Icons.person_outline,
                                  primaryColor: primaryColor,
                                  child: const Text(
                                    "I am a software developer Visualgrapher, designer, i am passionate about shifting the next generation to the newest technology trend.",
                                    style: TextStyle(fontSize: 15, height: 1.5),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildSectionBlock(
                                  title: "Semester Goals",
                                  icon: Icons.flag_outlined,
                                  primaryColor: primaryColor,
                                  child: Column(
                                    children: [
                                      _buildGoalItem("Enhance skills in mobile ", primaryColor),
                                      _buildGoalItem("Building a portfolio ", primaryColor),
                                      _buildGoalItem("validating  all courses", primaryColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionBlock({
    required String title,
    required IconData icon,
    required Widget child,
    required Color primaryColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          child,
        ],
      ),
    );
  }

  Widget _buildGoalItem(String goal, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20, color: primaryColor),
          const SizedBox(width: 10),
          Text(goal, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
