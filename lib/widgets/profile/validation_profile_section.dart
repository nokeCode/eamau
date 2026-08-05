import 'package:flutter/material.dart';

import '../../constants/profile_colors.dart';
import '../../constants/profile_sizes.dart';
import '../../models/profile/user_model.dart';

/// A readable, mobile-first record of the information supplied for validation.
class ValidationProfileSection extends StatelessWidget {
  final UserModel user;

  const ValidationProfileSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final sections = <_ProfileDetailsGroup>[
      _ProfileDetailsGroup(
        title: 'Identité',
        icon: Icons.badge_outlined,
        items: [
          _ProfileDetail('Prénom', user.firstName),
          _ProfileDetail('Nom', user.lastName),
          _ProfileDetail('Matricule', user.matricule),
          _ProfileDetail('Nom d’utilisateur', user.username),
          _ProfileDetail('Sexe', user.gender),
          _ProfileDetail('Date de naissance', user.birthDate),
          _ProfileDetail('Lieu de naissance', user.birthPlace),
          _ProfileDetail('Pays d’origine', user.country),
          _ProfileDetail('Nationalité', user.nationality),
          _ProfileDetail('Situation matrimoniale', user.maritalStatus),
          _ProfileDetail('N° de pièce d’identité', user.identityNumber),
        ],
      ),
      _ProfileDetailsGroup(
        title: 'Contacts',
        icon: Icons.contact_phone_outlined,
        items: [
          _ProfileDetail('E-mail principal', user.email),
          _ProfileDetail('Téléphone', user.phone),
          _ProfileDetail('WhatsApp', user.whatsapp),
          _ProfileDetail('Skype', user.skype),
        ],
      ),
      _ProfileDetailsGroup(
        title: 'Adresse permanente',
        icon: Icons.home_outlined,
        compact: true,
        items: [
          _ProfileDetail('Boîte postale', user.permanentPostalBox),
          _ProfileDetail('Ville', user.permanentCity),
          _ProfileDetail('Quartier', user.permanentQuarter),
          _ProfileDetail('Rue', user.permanentStreet),
          _ProfileDetail('Téléphone domicile', user.permanentHomePhone),
          _ProfileDetail('Téléphone mobile', user.permanentMobile),
        ],
      ),
      _ProfileDetailsGroup(
        title: 'Adresse à Lomé',
        icon: Icons.apartment_outlined,
        compact: true,
        items: [
          _ProfileDetail('Boîte postale', user.lomePostalBox),
          _ProfileDetail('Ville', user.lomeCity),
          _ProfileDetail('Quartier', user.lomeQuarter),
          _ProfileDetail('Rue', user.lomeStreet),
          _ProfileDetail('Téléphone domicile', user.lomeHomePhone),
          _ProfileDetail('Téléphone mobile', user.lomeMobile),
          _ProfileDetail('E-mail', user.lomeEmail),
        ],
      ),
      _ProfileDetailsGroup(
        title: 'Personne à prévenir',
        icon: Icons.emergency_outlined,
        compact: true,
        items: [
          _ProfileDetail('Nom', user.emergencyName),
          _ProfileDetail('Prénom complémentaire', user.emergencyFirstName),
          _ProfileDetail('Boîte postale', user.emergencyPostalBox),
          _ProfileDetail('Ville', user.emergencyCity),
          _ProfileDetail('Quartier', user.emergencyQuarter),
          _ProfileDetail('Rue', user.emergencyStreet),
          _ProfileDetail('Téléphone domicile', user.emergencyHomePhone),
          _ProfileDetail('Téléphone mobile', user.emergencyMobile),
          _ProfileDetail('E-mail', user.emergencyEmail),
        ],
      ),
      _ProfileDetailsGroup(
        title: 'Pièces d’identité',
        icon: Icons.description_outlined,
        isDocumentGroup: true,
        items: [
          _ProfileDetail('Recto de la pièce', user.identityFront),
          _ProfileDetail('Verso de la pièce', user.identityBack),
        ],
      ),
    ];
    final completedSections =
        sections.where((section) => section.hasDetails).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.folder_shared_outlined,
                  color: ProfileColors.secondary, size: 22),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Mon dossier personnel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ProfileColors.text,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: ProfileColors.secondary.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$completedSections/${sections.length}',
                  style: const TextStyle(
                    color: ProfileColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 18),
          child: Text(
            'Informations communiquées pour la validation du compte.',
            style: TextStyle(color: ProfileColors.subtitle, height: 1.35),
          ),
        ),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: section.isDocumentGroup
                ? _DocumentsCard(section: section)
                : (section.compact
                    ? _CompactDetailsCard(section: section)
                    : _ExpandedDetailsCard(section: section)),
          ),
        ),
      ],
    );
  }
}

class _ExpandedDetailsCard extends StatelessWidget {
  final _ProfileDetailsGroup section;

  const _ExpandedDetailsCard({required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section.visibleItems;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ProfileSizes.radius),
        border: Border.all(color: ProfileColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: ProfileColors.secondary.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(section.icon,
                    color: ProfileColors.secondary, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ProfileColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          if (items.isEmpty)
            const _EmptyDetailsState()
          else
            ...List.generate(items.length, (index) => _DetailRow(
                  item: items[index],
                  showDivider: index < items.length - 1,
                )),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final _ProfileDetail item;
  final bool showDivider;

  const _DetailRow({
    required this.item,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: ProfileColors.border))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              color: ProfileColors.subtitle,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            item.value,
            style: const TextStyle(
              color: ProfileColors.text,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Secondary areas stay compact until the user chooses to inspect them.
class _CompactDetailsCard extends StatelessWidget {
  final _ProfileDetailsGroup section;

  const _CompactDetailsCard({required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section.visibleItems;
    final summary = items.isEmpty
        ? 'Aucune information renseignée'
        : items.take(2).map((item) => item.value).join(' · ');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ProfileSizes.radius),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(18, 13, 14, 13),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ProfileColors.secondary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(section.icon, color: ProfileColors.secondary, size: 20),
          ),
          title: Text(
            section.title,
            style: const TextStyle(
              color: ProfileColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: ProfileColors.subtitle, fontSize: 13),
            ),
          ),
          children: [
            if (items.isEmpty)
              const _EmptyDetailsState()
            else
              ...List.generate(items.length, (index) => _DetailRow(
                    item: items[index],
                    showDivider: index < items.length - 1,
                  )),
          ],
        ),
      ),
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  final _ProfileDetailsGroup section;

  const _DocumentsCard({required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section.visibleItems;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(ProfileSizes.radius),
        border: Border.all(color: const Color(0xFFD7E7FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_file_outlined, color: ProfileColors.secondary),
              SizedBox(width: 10),
              Text('Pièces d’identité',
                  style: TextStyle(
                      color: ProfileColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Documents joints à votre dossier. Leur validation dépend de la décision de l’administration.',
            style: TextStyle(color: ProfileColors.subtitle, fontSize: 13, height: 1.35),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const _EmptyDetailsState()
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.insert_drive_file_outlined,
                          color: ProfileColors.subtitle, size: 19),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label,
                                style: const TextStyle(
                                    color: ProfileColors.subtitle, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(_documentName(item.value),
                                softWrap: true,
                                style: const TextStyle(
                                    color: ProfileColors.text,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  String _documentName(String value) {
    final uri = Uri.tryParse(value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return value.split('/').last;
  }
}

class _EmptyDetailsState extends StatelessWidget {
  const _EmptyDetailsState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: ProfileColors.subtitle, size: 17),
          SizedBox(width: 7),
          Text('Aucune information renseignée',
              style: TextStyle(color: ProfileColors.subtitle, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProfileDetailsGroup {
  final String title;
  final IconData icon;
  final List<_ProfileDetail> items;
  final bool isDocumentGroup;
  final bool compact;

  const _ProfileDetailsGroup({
    required this.title,
    required this.icon,
    required this.items,
    this.isDocumentGroup = false,
    this.compact = false,
  });

  List<_ProfileDetail> get visibleItems =>
      items.where((item) => item.value.trim().isNotEmpty).toList();

  bool get hasDetails => visibleItems.isNotEmpty;
}

class _ProfileDetail {
  final String label;
  final String value;

  const _ProfileDetail(this.label, this.value);
}
