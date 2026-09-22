import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news/news_model.dart';
import '../../data/local/publication_local_datasource.dart';
import '../../data/remote/publication_remote_datasource.dart';
import '../../data/repositories/publication_repository.dart';
import '../widgets/publication_detail/publication_abstract_card.dart';
import '../widgets/publication_detail/publication_citation_sheet.dart';
import '../widgets/publication_detail/publication_detail_header.dart';
import '../widgets/publication_detail/publication_keywords_section.dart';
import '../widgets/publication_detail/publication_metadata_card.dart';
import '../widgets/publication_detail/publication_pdf_card.dart';

class PublicationDetailScreen extends StatefulWidget {
  final String? slug;

  const PublicationDetailScreen({super.key, this.slug});

  @override
  State<PublicationDetailScreen> createState() => _PublicationDetailScreenState();
}

class _PublicationDetailScreenState extends State<PublicationDetailScreen> {
  final PublicationRepository _repo = PublicationRepository(
    local: PublicationLocalDatasource(),
    remote: PublicationRemoteDatasource(),
  );
  late Future<NewsModel> _publicationFuture;
  NewsModel? _loadedPublication;

  @override
  void initState() {
    super.initState();
    _publicationFuture = _loadPublication();
  }

  Future<NewsModel> _loadPublication() async {
    if (widget.slug == null || widget.slug!.trim().isEmpty) {
      throw Exception('Publication scientifique introuvable');
    }
    final pub = await _repo.getPublicationBySlug(widget.slug!);
    if (mounted) {
      setState(() {
        _loadedPublication = pub;
      });
    }
    return pub;
  }

  void _sharePublication(NewsModel pub) {
    final shareText = '''${pub.title}
${pub.formattedAuthors.isNotEmpty ? 'Auteurs : ${pub.formattedAuthors}' : ''}
${pub.journal.isNotEmpty ? 'Revue : ${pub.journal}' : ''}
${pub.doiUrl.isNotEmpty ? 'DOI : ${pub.doiUrl}' : ''}
EAMAU - Recherche Scientifique''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F2B66),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.share, color: Color(0xFF60A5FA), size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Lien et détails de la publication copiés !',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadOrOpenPdf(NewsModel pub) async {
    if (pub.pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Le document PDF complet n\'est pas encore disponible en ligne.',
          ),
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(pub.pdfUrl);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Impossible d\'ouvrir le fichier PDF.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Erreur : $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              height: 72,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F2B66), Color(0xFF1E4DB7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PublicationDetailHeader(publication: _loadedPublication),
            ),

            // Main Content Area
            Expanded(
              child: FutureBuilder<NewsModel>(
                future: _publicationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildAcademicSkeleton();
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 56,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              snapshot.error?.toString() ??
                                  'Publication scientifique introuvable',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _publicationFuture = _loadPublication();
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F2B66),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final pub = snapshot.data!;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Academic Classification Badges
                            _buildAcademicBadges(pub),
                            const SizedBox(height: 14),

                            // 2. Publication Paper Title
                            Text(
                              pub.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 3. Authors & Affiliations Card
                            _buildAuthorsCard(pub),
                            const SizedBox(height: 18),

                            // 4. PDF Document Access Box
                            PublicationPdfCard(publication: pub),
                            const SizedBox(height: 20),

                            // 5. Academic Metadata Card (DOI, Journal, Volume, Pages, etc.)
                            PublicationMetadataCard(publication: pub),
                            const SizedBox(height: 20),

                            // 6. Keywords Section
                            if (pub.keywords.isNotEmpty) ...[
                              PublicationKeywordsSection(keywords: pub.keywords),
                              const SizedBox(height: 20),
                            ],

                            // 7. Structured Abstract / Résumé Scientifique
                            if (pub.summary.isNotEmpty) ...[
                              PublicationAbstractCard(abstractText: pub.summary),
                              const SizedBox(height: 20),
                            ],

                            // 8. Full Paper Body / Sections (HTML)
                            if (pub.content != null &&
                                pub.content!.trim().isNotEmpty &&
                                pub.content != pub.summary) ...[
                              const Text(
                                'Contenu de la Publication',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Html(
                                  data: pub.content,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(15),
                                      lineHeight: const LineHeight(1.6),
                                      color: const Color(0xFF334155),
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "h1": Style(
                                      fontSize: FontSize(20),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F2B66),
                                    ),
                                    "h2": Style(
                                      fontSize: FontSize(17),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F2B66),
                                    ),
                                    "h3": Style(
                                      fontSize: FontSize(15),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E293B),
                                    ),
                                    "blockquote": Style(
                                      margin: Margins.symmetric(vertical: 8),
                                      padding: HtmlPaddings.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      border: const Border(
                                        left: BorderSide(
                                          color: Color(0xFF0F2B66),
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // 9. Quick Citation Box
                            _buildInlineCitationBox(pub),
                            const SizedBox(height: 20),

                            // 10. EAMAU Research Footer Note
                            _buildAcademicFooterNote(),
                          ],
                        ),
                      ),

                      // Sticky Bottom Action Bar
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildStickyBottomBar(pub),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicBadges(NewsModel pub) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Category / Field Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2B66),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            pub.categoryLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Document Type Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFDDD6FE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_outlined,
                size: 13,
                color: Color(0xFF6D28D9),
              ),
              const SizedBox(width: 4),
              Text(
                pub.displayType,
                style: const TextStyle(
                  color: Color(0xFF6D28D9),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Peer-Reviewed Badge
        if (pub.peerReviewed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 13,
                  color: Color(0xFF059669),
                ),
                SizedBox(width: 4),
                Text(
                  'Évalué par les pairs',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAuthorsCard(NewsModel pub) {
    final authors = pub.authors;
    final affiliation = pub.affiliation.isNotEmpty
        ? pub.affiliation
        : "École Africaine des Métiers de l'Architecture et de l'Urbanisme (EAMAU)";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2B66).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: Color(0xFF0F2B66),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auteurs / Chercheurs',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authors.isNotEmpty
                          ? authors.join(', ')
                          : (pub.formattedAuthors.isNotEmpty
                              ? pub.formattedAuthors
                              : 'Équipe de Recherche EAMAU'),
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.business_outlined,
                size: 15,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  affiliation,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (pub.displayDate.isNotEmpty || pub.publishedAt.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  pub.displayDate.isNotEmpty ? pub.displayDate : pub.publishedAt,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInlineCitationBox(NewsModel pub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF0F2B66),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Comment citer cet article (APA)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2B66),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => PublicationCitationSheet.show(context, pub),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Tous les formats',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: SelectableText(
              pub.apaCitation,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: pub.apaCitation));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Citation copiée dans le presse-papiers !'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 14),
              label: const Text('Copier la citation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F2B66),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicFooterNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF64748B)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'École Africaine des Métiers de l\'Architecture et de l\'Urbanisme (EAMAU) — Département Recherche Scientifique & Valorisation.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(NewsModel pub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Share Button
          OutlinedButton(
            onPressed: () => _sharePublication(pub),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              minimumSize: const Size(44, 44),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Icon(
              Icons.share_outlined,
              color: Color(0xFF334155),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),

          // Citation Modal Trigger
          OutlinedButton.icon(
            onPressed: () => PublicationCitationSheet.show(context, pub),
            icon: const Icon(Icons.format_quote_rounded, size: 18),
            label: const Text('Citer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F2B66),
              side: const BorderSide(color: Color(0xFF0F2B66)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Download / Open PDF Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _downloadOrOpenPdf(pub),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(
                pub.hasPdf ? 'Télécharger PDF' : 'Consulter PDF',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2B66),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 120,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 240,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}
