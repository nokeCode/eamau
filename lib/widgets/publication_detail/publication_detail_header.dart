import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/news/news_model.dart';
import 'publication_citation_sheet.dart';

class PublicationDetailHeader extends StatefulWidget {
  final NewsModel? publication;

  const PublicationDetailHeader({
    super.key,
    this.publication,
  });

  @override
  State<PublicationDetailHeader> createState() =>
      _PublicationDetailHeaderState();
}

class _PublicationDetailHeaderState extends State<PublicationDetailHeader> {
  bool _isBookmarked = false;

  void _sharePublication() {
    final pub = widget.publication;
    if (pub == null) return;

    final shareText = '''${pub.title}
${pub.formattedAuthors.isNotEmpty ? 'Par : ${pub.formattedAuthors}' : ''}
${pub.doiUrl.isNotEmpty ? 'Lien : ${pub.doiUrl}' : ''}
EAMAU Recherche Scientifique''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF162D6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.share, color: Color(0xFF60A5FA), size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Détails de la publication copiés pour le partage !',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF162D6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          _isBookmarked
              ? 'Publication ajoutée à vos favoris'
              : 'Publication retirée des favoris',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.18),
          radius: 19,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Publication Scientifique',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'EAMAU Recherche & Innovation',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFFBFDBFE),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        if (widget.publication != null) ...[
          IconButton(
            onPressed: () =>
                PublicationCitationSheet.show(context, widget.publication!),
            icon: const Icon(Icons.format_quote_rounded),
            color: Colors.white,
            tooltip: 'Citer cette publication',
          ),
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
            ),
            color: _isBookmarked ? const Color(0xFFFBBF24) : Colors.white,
            tooltip: 'Ajouter aux favoris',
          ),
          IconButton(
            onPressed: _sharePublication,
            icon: const Icon(Icons.share_outlined),
            color: Colors.white,
            tooltip: 'Partager',
          ),
        ],
      ],
    );
  }
}
