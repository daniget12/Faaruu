import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        title: const Text(
          'Wa\'ee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // App logo / icon area
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6B2737),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B2737).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.menu_book, color: Colors.white, size: 52),
            ),

            const SizedBox(height: 20),

            const Text(
              'Baafata Faaruu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6B2737).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Senbet Timihirt Bet',
                style: TextStyle(
                  color: Color(0xFF6B2737),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Developer section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hojjataa',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          const Color(0xFF6B2737).withOpacity(0.15),
                      child: const Text(
                        'DG',
                        style: TextStyle(
                          color: Color(0xFF6B2737),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daniel Getahun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quunnamtii',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _ContactButton(
              icon: Icons.send,
              label: 'Telegram',
              color: const Color(0xFF0088CC),
              onTap: () => _launch('https://t.me/daniget12'),
            ),
            const SizedBox(height: 10),
            _ContactButton(
              icon: Icons.phone,
              label: 'Bilbili',
              color: const Color(0xFF34A853),
              onTap: () => _launch('tel:+251000000000'),
            ),
            const SizedBox(height: 10),
            _ContactButton(
              icon: Icons.email,
              label: 'Imeelii',
              color: const Color(0xFFEA4335),
              onTap: () => _launch(
                  'mailto:danielgetahun1000@gmail.com?subject=Baafata%20Faaruu%20App'),
            ),

            const SizedBox(height: 40),

            Text(
              '© 2024 Baafata Faaruu\nKabajaa Waaqayyoof',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: onTap,
      ),
    );
  }
}
