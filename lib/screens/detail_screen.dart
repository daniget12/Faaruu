import 'package:flutter/material.dart';
import '../models/mezmur.dart';

class DetailScreen extends StatefulWidget {
  final Mezmur mezmur;
  final int displayNumber;

  const DetailScreen({
    super.key,
    required this.mezmur,
    required this.displayNumber,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        title: Text(
          '${widget.displayNumber}. ${widget.mezmur.title}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease, size: 20),
            tooltip: 'Smaller text',
            onPressed: () {
              setState(() {
                if (_fontSize > 12) _fontSize -= 2;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase, size: 20),
            tooltip: 'Larger text',
            onPressed: () {
              setState(() {
                if (_fontSize < 28) _fontSize += 2;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6B2737).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.mezmur.language,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B2737),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFormattedText(widget.mezmur.fullText),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedText(String text) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.isEmpty) {
          return const SizedBox(height: 12);
        }

        // Indented sub-line (starts with 4 spaces)
        if (line.startsWith('    >> ')) {
          final content = line.substring(7);
          return Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '»',
                  style: TextStyle(
                    fontSize: _fontSize - 1,
                    color: const Color(0xFF6B2737).withOpacity(0.6),
                    height: 1.6,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: _fontSize,
                      height: 1.7,
                      color: const Color(0xFF3A3A4A),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (line.startsWith('    ')) {
          final content = line.trimLeft();
          return Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 4),
            child: Text(
              content,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.7,
                color: const Color(0xFF3A3A4A),
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        // Normal line
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            line,
            style: TextStyle(
              fontSize: _fontSize,
              height: 1.7,
              color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
