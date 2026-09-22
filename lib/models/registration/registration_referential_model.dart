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

  factory RegistrationSemesterEntry.fromJson(dynamic source) {
    if (source is Map) {
      final map = Map<String, dynamic>.from(source);
      final semOpt = map['semester'] != null
          ? RegistrationOption.fromJson(map['semester'])
          : (map['semesterId'] != null
              ? RegistrationOption(
                  id: map['semesterId'].toString(),
                  value: map['semesterId'].toString(),
                  label: map['semesterId'].toString(),
                )
              : null);
      final statOpt = map['status'] != null
          ? RegistrationOption.fromJson(map['status'])
          : (map['statusId'] != null
              ? RegistrationOption(
                  id: map['statusId'].toString(),
                  value: map['statusId'].toString(),
                  label: map['statusId'].toString(),
                )
              : null);
      return RegistrationSemesterEntry(semester: semOpt, status: statOpt);
    }
    return const RegistrationSemesterEntry();
  }

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
      if (semester != null) 'semester': semester!.toJson(),
      if (status != null) 'status': status!.toJson(),
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
  final String uploadStatus;

  const RegistrationDocument({
    required this.fileName,
    required this.filePath,
    required this.type,
    required this.sizeBytes,
    this.uploadStatus = 'pending',
  });

  factory RegistrationDocument.fromJson(dynamic source) {
    if (source is Map) {
      final map = Map<String, dynamic>.from(source);
      return RegistrationDocument(
        fileName: map['fileName']?.toString() ?? '',
        filePath: map['filePath']?.toString() ?? '',
        type: map['type']?.toString() ?? 'OTHER',
        sizeBytes: int.tryParse(map['sizeBytes']?.toString() ?? '0') ?? 0,
        uploadStatus: map['uploadStatus']?.toString() ?? 'pending',
      );
    }
    return const RegistrationDocument(fileName: '', filePath: '', type: 'OTHER', sizeBytes: 0);
  }

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

  factory RegistrationDraft.fromJson(dynamic source) {
    if (source is! Map) return const RegistrationDraft();
    final map = Map<String, dynamic>.from(source);

    RegistrationOption? parseOpt(dynamic optSource, String? fallbackId) {
      if (optSource != null) {
        return RegistrationOption.fromJson(optSource);
      }
      if (fallbackId != null && fallbackId.isNotEmpty) {
        return RegistrationOption(id: fallbackId, value: fallbackId, label: fallbackId);
      }
      return null;
    }

    final semsList = <RegistrationSemesterEntry>[];
    if (map['semesters'] is List) {
      for (final item in map['semesters'] as List) {
        semsList.add(RegistrationSemesterEntry.fromJson(item));
      }
    }

    return RegistrationDraft(
      firstName: map['firstName']?.toString() ?? '',
      lastName: map['lastName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      matricule: map['matricule']?.toString() ?? '',
      author: map['author']?.toString() ?? '',
      alreadyRegistered: map['alreadyRegistered'] == true || map['oldStudent'] == true,
      schoolYear: parseOpt(
        map['schoolYear'],
        map['schoolYearId']?.toString() ?? map['anneeScolaireId']?.toString(),
      ),
      status: parseOpt(
        map['status'],
        map['statusId']?.toString(),
      ),
      filiere: parseOpt(
        map['filiere'],
        map['filiereId']?.toString(),
      ),
      grade: parseOpt(
        map['grade'],
        map['gradeId']?.toString(),
      ),
      group: parseOpt(
        map['group'],
        map['groupeId']?.toString() ?? map['groupId']?.toString(),
      ),
      semesters: semsList,
    );
  }

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

  /// Full representation for durable local SQLite caching
  Map<String, dynamic> toLocalMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'matricule': matricule,
      'author': author,
      'alreadyRegistered': alreadyRegistered,
      'oldStudent': alreadyRegistered,
      if (schoolYear != null) 'schoolYear': schoolYear!.toJson(),
      if (schoolYear != null) 'anneeScolaireId': schoolYear!.id,
      if (status != null) 'status': status!.toJson(),
      if (filiere != null) 'filiere': filiere!.toJson(),
      if (filiere != null) 'filiereId': filiere!.id,
      if (grade != null) 'grade': grade!.toJson(),
      if (grade != null) 'gradeId': grade!.id,
      if (group != null) 'group': group!.toJson(),
      if (group != null) 'groupeId': group!.id,
      'semesters': semesters.map((s) => s.toJson()).toList(),
    };
  }

  /// Payload format expected by the Symfony backend API
  Map<String, dynamic> toApiJson() {
    return {
      'anneeScolaireId': schoolYear?.id,
      if (status != null) 'statusId': status!.id,
      if (status != null) 'statutId': status!.id,
      if (matricule.isNotEmpty) 'matricule': matricule,
      'oldStudent': alreadyRegistered,
      if (filiere != null) 'filiereId': filiere!.id,
      if (grade != null) 'gradeId': grade!.id,
      if (group != null) 'groupeId': group!.id,
    };
  }

  Map<String, dynamic> toJson() => toLocalMap();
}
