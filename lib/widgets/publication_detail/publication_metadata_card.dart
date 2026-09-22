import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news/news_model.dart';

class PublicationMetadataCard extends StatelessWidget {
  final NewsModel publication;

  const PublicationMetadataCard({
    super.key,
    required this.publication,
  });

  Future<void> _copyDoi(BuildContext context, String doi) async {
    await Clipboard.setData(ClipboardData(text: doi));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF162D6B),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF4ADE80), size: 18),
              const SizedBox(width: 8),
              Text('DOI copié : $doi'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openDoi(BuildContext context, String doiUrl) async {
    try {
      final uri = Uri.parse(doiUrl);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Impossible d\'ouvrir le lien DOI.'),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final hasJournal = publication.journal.isNotEmpty;
    final hasDoi = publication.hasDoi;
    final hasVolume = publication.volume.isNotEmpty || publication.issue.isNotEmpty;
    final hasPages = publication.pages.isNotEmpty;
    final hasIssn = publication.issn.isNotEmpty;
    final hasIsbn = publication.isbn.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_outlined,
                color: Color(0xFF162D6B),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Métadonnées Académiques',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF162D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // DOI row if present
          if (hasDoi) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DOI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectableText(
                      publication.cleanDoi,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF2563EB)),
                    tooltip: 'Copier le DOI',
                    onPressed: () => _copyDoi(context, publication.cleanDoi),
                  ),
                  const SizedBox(width: 6),
                  if (publication.doiUrl.isNotEmpty)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF2563EB)),
                      tooltip: 'Ouvrir le lien DOI',
                      onPressed: () => _openDoi(context, publication.doiUrl),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Grid of metadata items
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              if (hasJournal)
                _buildMetaItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Revue / Journal',
                  value: publication.journal,
                ),
              if (hasVolume)
                _buildMetaItem(
                  icon: Icons.collections_bookmark_outlined,
                  label: 'Volume / Numéro',
                  value: 'Vol. ${publication.volume.isNotEmpty ? publication.volume : "-"}${publication.issue.isNotEmpty ? ", N° ${publication.issue}" : ""}',
                ),
              if (hasPages)
                _buildMetaItem(
                  icon: Icons.find_in_page_outlined,
                  label: 'Pages',
                  value: publication.pages,
                ),
              _buildMetaItem(
                icon: Icons.calendar_month_outlined,
                label: 'Date de publication',
                value: publication.displayDate.isNotEmpty
                    ? publication.displayDate
                    : publication.publishedAt,
              ),
              _buildMetaItem(
                icon: Icons.translate_rounded,
                label: 'Langue',
                value: publication.language.isNotEmpty
                    ? publication.language
                    : 'Français',
              ),
              _buildMetaItem(
                icon: Icons.verified_outlined,
                label: 'Évaluation',
                value: publication.peerReviewed
                    ? 'Revue par les pairs'
                    : 'Comité scientifique',
                valueColor: const Color(0xFF15803D),
              ),
              if (hasIssn)
                _buildMetaItem(
                  icon: Icons.tag_rounded,
                  label: 'ISSN',
                  value: publication.issn,
                ),
              if (hasIsbn)
                _buildMetaItem(
                  icon: Icons.tag_rounded,
                  label: 'ISBN',
                  value: publication.isbn,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return SizedBox(
      width: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: valueColor ?? const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
