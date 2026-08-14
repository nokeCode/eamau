class RegistrationOption {
  final String id;
  final String value;
  final String label;
  final String? code;

  const RegistrationOption({
    required this.id,
    required this.value,
    required this.label,
    this.code,
  });

  factory RegistrationOption.fromJson(dynamic source) {
    if (source is String) {
      return RegistrationOption(id: source, value: source, label: source);
    }

    if (source is Map) {
      final map = Map<String, dynamic>.from(source);
      final id = map['id']?.toString() ?? '';
      final rawValue = map['value']?.toString() ?? '';
      final rawLabel = map['label']?.toString() ?? '';
      final rawName = map['name']?.toString() ?? '';
      final rawTitle = map['title']?.toString() ?? '';
      final rawCode = map['code']?.toString() ?? '';

      final value = rawValue.isNotEmpty
          ? rawValue
          : rawName.isNotEmpty
              ? rawName
              : rawLabel.isNotEmpty
                  ? rawLabel
                  : rawTitle.isNotEmpty
                      ? rawTitle
                      : rawCode;
      final label = rawLabel.isNotEmpty
          ? rawLabel
          : rawName.isNotEmpty
              ? rawName
              : rawTitle.isNotEmpty
                  ? rawTitle
                  : rawCode.isNotEmpty
                      ? rawCode
                      : value;

      return RegistrationOption(
        id: id.isNotEmpty ? id : value,
        value: value.isNotEmpty ? value : label,
        label: label.isNotEmpty ? label : value,
        code: rawCode.isNotEmpty ? rawCode : null,
      );
    }

    return const RegistrationOption(id: '', value: '', label: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'label': label,
      if (code != null) 'code': code,
    };
  }
}

class RegistrationReferentialCollection {
  final List<RegistrationOption> schoolYears;
  final List<RegistrationOption> statuses;
  final List<RegistrationOption> filieres;
  final List<RegistrationOption> grades;
  final List<RegistrationOption> groups;
  final List<RegistrationOption> semesters;
  final List<RegistrationOption> documentTypes;

  const RegistrationReferentialCollection({
    this.schoolYears = const [],
    this.statuses = const [],
    this.filieres = const [],
    this.grades = const [],
    this.groups = const [],
    this.semesters = const [],
    this.documentTypes = const [],
  });

  factory RegistrationReferentialCollection.fromJson(dynamic source) {
    final root = _extractMap(source);
    final payload = _extractMap(
      root['data'] ?? root['result'] ?? root['payload'],
    );

    return RegistrationReferentialCollection(
      schoolYears: _parseOptions(
        payload['schoolYears'] ?? payload['years'] ?? payload['academicYears'],
      ),
      statuses: _parseOptions(
        payload['statuses'] ?? payload['status'] ?? payload['statuts'],
      ),
      filieres: _parseOptions(
        payload['filieres'] ?? payload['programs'] ?? payload['formations'],
      ),
      grades: _parseOptions(
        payload['grades'] ?? payload['grade'] ?? payload['niveaux'],
      ),
      groups: _parseOptions(payload['groups'] ?? payload['groupes']),
      semesters: _parseOptions(payload['semesters'] ?? payload['semestres']),
      documentTypes: _parseOptions(
        payload['documentTypes'] ?? payload['documents'] ?? payload['pieces'],
      ),
    );
  }

  static Map<String, dynamic> _extractMap(dynamic source) {
    if (source is Map) {
      return Map<String, dynamic>.from(source);
    }
    return {};
  }

  static List<RegistrationOption> _parseOptions(dynamic source) {
    if (source is List) {
      return source.map((item) => RegistrationOption.fromJson(item)).toList();
    }
    return const [];
  }
}

class RegistrationSemesterEntry {
  final RegistrationOption? semester;
  final RegistrationOption? status;

  const RegistrationSemesterEntry({this.semester, this.status});

  RegistrationSemesterEntry copyWith({
    RegistrationOption? semester,
    RegistrationOption? status,
  }) {
    return RegistrationSemesterEntry(
      semester: semester ?? this.semester,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (semester != null) 'semesterId': semester!.id,
      if (status != null) 'statusId': status!.id,
    };
  }
}

class RegistrationDocument {
  final String fileName;
  final String filePath;
  final String type;
  final int sizeBytes;

  const RegistrationDocument({
    required this.fileName,
    required this.filePath,
    required this.type,
    required this.sizeBytes,
  });

  String get extension => fileName.split('.').last.toLowerCase();

  String get displaySize {
    if (sizeBytes < 1024) {
      return '$sizeBytes o';
    }
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} Ko';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'type': type,
      'sizeBytes': sizeBytes,
    };
  }
}

class RegistrationDraft {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String matricule;
  final String author;
  final bool alreadyRegistered;
  final RegistrationOption? schoolYear;
  final RegistrationOption? status;
  final RegistrationOption? filiere;
  final RegistrationOption? grade;
  final RegistrationOption? group;
  final List<RegistrationSemesterEntry> semesters;

  const RegistrationDraft({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.matricule = '',
    this.author = '',
    this.alreadyRegistered = false,
    this.schoolYear,
    this.status,
    this.filiere,
    this.grade,
    this.group,
    this.semesters = const [],
  });

  RegistrationDraft copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? matricule,
    String? author,
    bool? alreadyRegistered,
    RegistrationOption? schoolYear,
    RegistrationOption? status,
    RegistrationOption? filiere,
    RegistrationOption? grade,
    RegistrationOption? group,
    List<RegistrationSemesterEntry>? semesters,
  }) {
    return RegistrationDraft(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      matricule: matricule ?? this.matricule,
      author: author ?? this.author,
      alreadyRegistered: alreadyRegistered ?? this.alreadyRegistered,
      schoolYear: schoolYear ?? this.schoolYear,
      status: status ?? this.status,
      filiere: filiere ?? this.filiere,
      grade: grade ?? this.grade,
      group: group ?? this.group,
      semesters: semesters ?? this.semesters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Backend récupère firstName, lastName, email, phone du JWT/profil utilisateur
      // Ne pas les envoyer ici
      'anneeScolaireId': schoolYear?.id,
      if (matricule.isNotEmpty) 'matricule': matricule,
      'oldStudent': alreadyRegistered,
      if (filiere != null) 'filiereId': filiere!.id,
      if (grade != null) 'gradeId': grade!.id,
      if (group != null) 'groupeId': group!.id,
    };
  }
}
