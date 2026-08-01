class CandidateTypeModel {
  final String id;
  final String name;

  const CandidateTypeModel({required this.id, required this.name});

  factory CandidateTypeModel.fromJson(Map<String, dynamic> json) {
    return CandidateTypeModel(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? json['label'] ?? ''}',
    );
  }
}

class ConcoursFormAttributeModel {
  final String id;
  final String name;
  final String slug;
  final String type;
  final bool required;
  final String? placeholder;
  final int orderNumber;
  final List<String> candidateTypeIds;

  const ConcoursFormAttributeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.required,
    this.placeholder,
    required this.orderNumber,
    required this.candidateTypeIds,
  });

  factory ConcoursFormAttributeModel.fromJson(Map<String, dynamic> json) {
    final candidateTypeIds = <String>[];
    final rawCandidateTypeIds =
        json['candidateTypeIds'] as List<dynamic>? ?? [];
    for (final item in rawCandidateTypeIds) {
      candidateTypeIds.add('${item ?? ''}');
    }

    return ConcoursFormAttributeModel(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      type: '${json['type'] ?? 'varchar'}',
      required: json['required'] == true,
      placeholder: json['placeholder']?.toString(),
      orderNumber: int.tryParse('${json['orderNumber'] ?? 0}') ?? 0,
      candidateTypeIds: candidateTypeIds,
    );
  }
}

class ConcoursFormSectionModel {
  final String id;
  final String code;
  final String name;
  final int orderNumber;
  final List<ConcoursFormAttributeModel> attributes;

  const ConcoursFormSectionModel({
    required this.id,
    required this.code,
    required this.name,
    required this.orderNumber,
    required this.attributes,
  });

  factory ConcoursFormSectionModel.fromJson(Map<String, dynamic> json) {
    final attributes = (json['attributes'] as List<dynamic>? ?? [])
        .map(
          (item) => ConcoursFormAttributeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    return ConcoursFormSectionModel(
      id: '${json['id'] ?? ''}',
      code: '${json['code'] ?? ''}',
      name: '${json['name'] ?? ''}',
      orderNumber: int.tryParse('${json['orderNumber'] ?? 0}') ?? 0,
      attributes: attributes,
    );
  }
}

class ConcoursFormModel {
  final String id;
  final List<CandidateTypeModel> candidateTypes;
  final List<ConcoursFormSectionModel> sections;

  const ConcoursFormModel({
    required this.id,
    required this.candidateTypes,
    required this.sections,
  });

  factory ConcoursFormModel.fromJson(Map<String, dynamic> json) {
    final candidateTypes = (json['candidateTypes'] as List<dynamic>? ?? [])
        .map(
          (item) =>
              CandidateTypeModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    final sections = (json['sections'] as List<dynamic>? ?? [])
        .map(
          (item) => ConcoursFormSectionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    return ConcoursFormModel(
      id: '${json['id'] ?? ''}',
      candidateTypes: candidateTypes,
      sections: sections,
    );
  }
}

class PostulationDraftModel {
  final String id;
  final String? reference;

  const PostulationDraftModel({required this.id, this.reference});

  factory PostulationDraftModel.fromJson(Map<String, dynamic> json) {
    return PostulationDraftModel(
      id: '${json['id'] ?? ''}',
      reference: json['reference']?.toString(),
    );
  }
}

class PostulationVerificationResult {
  final PostulationDraftModel postulation;
  final String postulationToken;
  final String expiresAt;

  const PostulationVerificationResult({
    required this.postulation,
    required this.postulationToken,
    required this.expiresAt,
  });

  factory PostulationVerificationResult.fromJson(Map<String, dynamic> json) {
    final postulationData = json['postulation'] as Map<String, dynamic>? ?? {};
    return PostulationVerificationResult(
      postulation: PostulationDraftModel.fromJson(postulationData),
      postulationToken:
          '${json['postulationToken'] ?? json['postulation_token'] ?? ''}',
      expiresAt: '${json['expiresAt'] ?? json['expires_at'] ?? ''}',
    );
  }
}

class PostulationDocumentModel {
  final String id;
  final String attributeId;
  final String attributeSlug;
  final String name;

  const PostulationDocumentModel({
    required this.id,
    required this.attributeId,
    required this.attributeSlug,
    required this.name,
  });

  factory PostulationDocumentModel.fromJson(Map<String, dynamic> json) {
    return PostulationDocumentModel(
      id: '${json['id'] ?? ''}',
      attributeId: '${json['attributeId'] ?? ''}',
      attributeSlug: '${json['attributeSlug'] ?? ''}',
      name: '${json['name'] ?? ''}',
    );
  }
}
