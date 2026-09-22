import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/news/news_model.dart';

class PublicationCitationSheet extends StatefulWidget {
  final NewsModel publication;

  const PublicationCitationSheet({
    super.key,
    required this.publication,
  });

  static Future<void> show(BuildContext context, NewsModel publication) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PublicationCitationSheet(publication: publication),
    );
  }

  @override
  State<PublicationCitationSheet> createState() =>
      _PublicationCitationSheetState();
}

class _PublicationCitationSheetState extends State<PublicationCitationSheet> {
  int _selectedFormatIndex = 0;
  bool _copied = false;

  final List<String> _formats = ['APA 7', 'BibTeX', 'IEEE', 'Chicago'];

  String _getCitationText(int index) {
    switch (index) {
      case 0:
        return widget.publication.apaCitation;
      case 1:
        return widget.publication.bibtexCitation;
      case 2:
        return widget.publication.ieeeCitation;
      case 3:
        return widget.publication.chicagoCitation;
      default:
        return widget.publication.apaCitation;
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(() {
      _copied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF162D6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4ADE80), size: 20),
            SizedBox(width: 10),
            Text(
              'Citation copiée dans le presse-papiers !',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final citationText = _getCitationText(_selectedFormatIndex);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF162D6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  color: Color(0xFF162D6B),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Citer cette publication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF162D6B),
                      ),
                    ),
                    Text(
                      'Formats de citation académique et bibliographique',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Format selector pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_formats.length, (index) {
                final isSelected = _selectedFormatIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_formats[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFormatIndex = index;
                          _copied = false;
                        });
                      }
                    },
                    selectedColor: const Color(0xFF162D6B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF162D6B),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13,
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF162D6B)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Citation box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formats[_selectedFormatIndex].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    InkWell(
                      onTap: () => _copyToClipboard(citationText),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _copied
                                  ? Icons.check
                                  : Icons.copy_rounded,
                              size: 14,
                              color: _copied
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _copied ? 'Copié' : 'Copier',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _copied
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SelectableText(
                  citationText,
                  style: TextStyle(
                    fontFamily: _selectedFormatIndex == 1
                        ? 'monospace'
                        : null,
                    fontSize: 13.5,
                    height: 1.5,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _copyToClipboard(citationText),
              icon: Icon(
                _copied ? Icons.check_circle_outline : Icons.content_copy,
                size: 18,
              ),
              label: Text(
                _copied
                    ? 'Citation copiée dans le presse-papiers'
                    : 'Copier la citation (${_formats[_selectedFormatIndex]})',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF162D6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
