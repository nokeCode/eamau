// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NewsTable extends News with TableInfo<$NewsTable, New> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _featuredMeta =
      const VerificationMeta('featured');
  @override
  late final GeneratedColumn<bool> featured = GeneratedColumn<bool>(
      'featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("featured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        title,
        slug,
        summary,
        content,
        image,
        publishedAt,
        featured,
        categoryId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'news';
  @override
  VerificationContext validateIntegrity(Insertable<New> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    if (data.containsKey('featured')) {
      context.handle(_featuredMeta,
          featured.isAcceptableOrUnknown(data['featured']!, _featuredMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  New map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return New(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      featured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}featured'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $NewsTable createAlias(String alias) {
    return $NewsTable(attachedDatabase, alias);
  }
}

class New extends DataClass implements Insertable<New> {
  final int id;
  final int? remoteId;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? image;
  final DateTime? publishedAt;
  final bool featured;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const New(
      {required this.id,
      this.remoteId,
      required this.title,
      required this.slug,
      this.summary,
      this.content,
      this.image,
      this.publishedAt,
      required this.featured,
      this.categoryId,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['featured'] = Variable<bool>(featured);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  NewsCompanion toCompanion(bool nullToAbsent) {
    return NewsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      title: Value(title),
      slug: Value(slug),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      featured: Value(featured),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory New.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return New(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      summary: serializer.fromJson<String?>(json['summary']),
      content: serializer.fromJson<String?>(json['content']),
      image: serializer.fromJson<String?>(json['image']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      featured: serializer.fromJson<bool>(json['featured']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<String?>(content),
      'image': serializer.toJson<String?>(image),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'featured': serializer.toJson<bool>(featured),
      'categoryId': serializer.toJson<int?>(categoryId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  New copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          String? title,
          String? slug,
          Value<String?> summary = const Value.absent(),
          Value<String?> content = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<DateTime?> publishedAt = const Value.absent(),
          bool? featured,
          Value<int?> categoryId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      New(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        summary: summary.present ? summary.value : this.summary,
        content: content.present ? content.value : this.content,
        image: image.present ? image.value : this.image,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        featured: featured ?? this.featured,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  New copyWithCompanion(NewsCompanion data) {
    return New(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      slug: data.slug.present ? data.slug.value : this.slug,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      image: data.image.present ? data.image.value : this.image,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      featured: data.featured.present ? data.featured.value : this.featured,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('New(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('featured: $featured, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, title, slug, summary, content,
      image, publishedAt, featured, categoryId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is New &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.image == this.image &&
          other.publishedAt == this.publishedAt &&
          other.featured == this.featured &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NewsCompanion extends UpdateCompanion<New> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> title;
  final Value<String> slug;
  final Value<String?> summary;
  final Value<String?> content;
  final Value<String?> image;
  final Value<DateTime?> publishedAt;
  final Value<bool> featured;
  final Value<int?> categoryId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const NewsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.featured = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NewsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String title,
    required String slug,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.featured = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : title = Value(title),
        slug = Value(slug);
  static Insertable<New> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? image,
    Expression<DateTime>? publishedAt,
    Expression<bool>? featured,
    Expression<int>? categoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (publishedAt != null) 'published_at': publishedAt,
      if (featured != null) 'featured': featured,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NewsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<String>? title,
      Value<String>? slug,
      Value<String?>? summary,
      Value<String?>? content,
      Value<String?>? image,
      Value<DateTime?>? publishedAt,
      Value<bool>? featured,
      Value<int?>? categoryId,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return NewsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      featured: featured ?? this.featured,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (featured.present) {
      map['featured'] = Variable<bool>(featured.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('featured: $featured, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PublicationsTable extends Publications
    with TableInfo<$PublicationsTable, Publication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PublicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _featuredMeta =
      const VerificationMeta('featured');
  @override
  late final GeneratedColumn<bool> featured = GeneratedColumn<bool>(
      'featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("featured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        title,
        slug,
        summary,
        content,
        image,
        publishedAt,
        featured,
        categoryId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'publications';
  @override
  VerificationContext validateIntegrity(Insertable<Publication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    if (data.containsKey('featured')) {
      context.handle(_featuredMeta,
          featured.isAcceptableOrUnknown(data['featured']!, _featuredMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Publication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Publication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      featured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}featured'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PublicationsTable createAlias(String alias) {
    return $PublicationsTable(attachedDatabase, alias);
  }
}

class Publication extends DataClass implements Insertable<Publication> {
  final int id;
  final int? remoteId;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? image;
  final DateTime? publishedAt;
  final bool featured;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Publication(
      {required this.id,
      this.remoteId,
      required this.title,
      required this.slug,
      this.summary,
      this.content,
      this.image,
      this.publishedAt,
      required this.featured,
      this.categoryId,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['featured'] = Variable<bool>(featured);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PublicationsCompanion toCompanion(bool nullToAbsent) {
    return PublicationsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      title: Value(title),
      slug: Value(slug),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      featured: Value(featured),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Publication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Publication(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      summary: serializer.fromJson<String?>(json['summary']),
      content: serializer.fromJson<String?>(json['content']),
      image: serializer.fromJson<String?>(json['image']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      featured: serializer.fromJson<bool>(json['featured']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<String?>(content),
      'image': serializer.toJson<String?>(image),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'featured': serializer.toJson<bool>(featured),
      'categoryId': serializer.toJson<int?>(categoryId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Publication copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          String? title,
          String? slug,
          Value<String?> summary = const Value.absent(),
          Value<String?> content = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<DateTime?> publishedAt = const Value.absent(),
          bool? featured,
          Value<int?> categoryId = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Publication(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        summary: summary.present ? summary.value : this.summary,
        content: content.present ? content.value : this.content,
        image: image.present ? image.value : this.image,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        featured: featured ?? this.featured,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Publication copyWithCompanion(PublicationsCompanion data) {
    return Publication(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      slug: data.slug.present ? data.slug.value : this.slug,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      image: data.image.present ? data.image.value : this.image,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      featured: data.featured.present ? data.featured.value : this.featured,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Publication(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('featured: $featured, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, title, slug, summary, content,
      image, publishedAt, featured, categoryId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Publication &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.image == this.image &&
          other.publishedAt == this.publishedAt &&
          other.featured == this.featured &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PublicationsCompanion extends UpdateCompanion<Publication> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> title;
  final Value<String> slug;
  final Value<String?> summary;
  final Value<String?> content;
  final Value<String?> image;
  final Value<DateTime?> publishedAt;
  final Value<bool> featured;
  final Value<int?> categoryId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const PublicationsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.featured = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PublicationsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String title,
    required String slug,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.featured = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : title = Value(title),
        slug = Value(slug);
  static Insertable<Publication> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? image,
    Expression<DateTime>? publishedAt,
    Expression<bool>? featured,
    Expression<int>? categoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (publishedAt != null) 'published_at': publishedAt,
      if (featured != null) 'featured': featured,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PublicationsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<String>? title,
      Value<String>? slug,
      Value<String?>? summary,
      Value<String?>? content,
      Value<String?>? image,
      Value<DateTime?>? publishedAt,
      Value<bool>? featured,
      Value<int?>? categoryId,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return PublicationsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      featured: featured ?? this.featured,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (featured.present) {
      map['featured'] = Variable<bool>(featured.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PublicationsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('featured: $featured, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ConcoursTable extends Concours with TableInfo<$ConcoursTable, Concour> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConcoursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
      'titre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Ouvert'));
  static const VerificationMeta _startingAtMeta =
      const VerificationMeta('startingAt');
  @override
  late final GeneratedColumn<String> startingAt = GeneratedColumn<String>(
      'starting_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endingAtMeta =
      const VerificationMeta('endingAt');
  @override
  late final GeneratedColumn<String> endingAt = GeneratedColumn<String>(
      'ending_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        titre,
        slug,
        description,
        image,
        statut,
        startingAt,
        endingAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concours';
  @override
  VerificationContext validateIntegrity(Insertable<Concour> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('titre')) {
      context.handle(
          _titreMeta, titre.isAcceptableOrUnknown(data['titre']!, _titreMeta));
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('starting_at')) {
      context.handle(
          _startingAtMeta,
          startingAt.isAcceptableOrUnknown(
              data['starting_at']!, _startingAtMeta));
    }
    if (data.containsKey('ending_at')) {
      context.handle(_endingAtMeta,
          endingAt.isAcceptableOrUnknown(data['ending_at']!, _endingAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Concour map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Concour(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      titre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titre'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      startingAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}starting_at']),
      endingAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ending_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ConcoursTable createAlias(String alias) {
    return $ConcoursTable(attachedDatabase, alias);
  }
}

class Concour extends DataClass implements Insertable<Concour> {
  final int id;
  final String? remoteId;
  final String titre;
  final String slug;
  final String? description;
  final String? image;
  final String statut;
  final String? startingAt;
  final String? endingAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Concour(
      {required this.id,
      this.remoteId,
      required this.titre,
      required this.slug,
      this.description,
      this.image,
      required this.statut,
      this.startingAt,
      this.endingAt,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['titre'] = Variable<String>(titre);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || startingAt != null) {
      map['starting_at'] = Variable<String>(startingAt);
    }
    if (!nullToAbsent || endingAt != null) {
      map['ending_at'] = Variable<String>(endingAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ConcoursCompanion toCompanion(bool nullToAbsent) {
    return ConcoursCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      titre: Value(titre),
      slug: Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      statut: Value(statut),
      startingAt: startingAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startingAt),
      endingAt: endingAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endingAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Concour.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Concour(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      titre: serializer.fromJson<String>(json['titre']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      statut: serializer.fromJson<String>(json['statut']),
      startingAt: serializer.fromJson<String?>(json['startingAt']),
      endingAt: serializer.fromJson<String?>(json['endingAt']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'titre': serializer.toJson<String>(titre),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
      'statut': serializer.toJson<String>(statut),
      'startingAt': serializer.toJson<String?>(startingAt),
      'endingAt': serializer.toJson<String?>(endingAt),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Concour copyWith(
          {int? id,
          Value<String?> remoteId = const Value.absent(),
          String? titre,
          String? slug,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent(),
          String? statut,
          Value<String?> startingAt = const Value.absent(),
          Value<String?> endingAt = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Concour(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        titre: titre ?? this.titre,
        slug: slug ?? this.slug,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
        statut: statut ?? this.statut,
        startingAt: startingAt.present ? startingAt.value : this.startingAt,
        endingAt: endingAt.present ? endingAt.value : this.endingAt,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Concour copyWithCompanion(ConcoursCompanion data) {
    return Concour(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      titre: data.titre.present ? data.titre.value : this.titre,
      slug: data.slug.present ? data.slug.value : this.slug,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      statut: data.statut.present ? data.statut.value : this.statut,
      startingAt:
          data.startingAt.present ? data.startingAt.value : this.startingAt,
      endingAt: data.endingAt.present ? data.endingAt.value : this.endingAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Concour(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('titre: $titre, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('statut: $statut, ')
          ..write('startingAt: $startingAt, ')
          ..write('endingAt: $endingAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, titre, slug, description, image,
      statut, startingAt, endingAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Concour &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.titre == this.titre &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.image == this.image &&
          other.statut == this.statut &&
          other.startingAt == this.startingAt &&
          other.endingAt == this.endingAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConcoursCompanion extends UpdateCompanion<Concour> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> titre;
  final Value<String> slug;
  final Value<String?> description;
  final Value<String?> image;
  final Value<String> statut;
  final Value<String?> startingAt;
  final Value<String?> endingAt;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const ConcoursCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.titre = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.statut = const Value.absent(),
    this.startingAt = const Value.absent(),
    this.endingAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ConcoursCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String titre,
    required String slug,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.statut = const Value.absent(),
    this.startingAt = const Value.absent(),
    this.endingAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : titre = Value(titre),
        slug = Value(slug);
  static Insertable<Concour> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? titre,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? image,
    Expression<String>? statut,
    Expression<String>? startingAt,
    Expression<String>? endingAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (titre != null) 'titre': titre,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (statut != null) 'statut': statut,
      if (startingAt != null) 'starting_at': startingAt,
      if (endingAt != null) 'ending_at': endingAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ConcoursCompanion copyWith(
      {Value<int>? id,
      Value<String?>? remoteId,
      Value<String>? titre,
      Value<String>? slug,
      Value<String?>? description,
      Value<String?>? image,
      Value<String>? statut,
      Value<String?>? startingAt,
      Value<String?>? endingAt,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return ConcoursCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      titre: titre ?? this.titre,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      image: image ?? this.image,
      statut: statut ?? this.statut,
      startingAt: startingAt ?? this.startingAt,
      endingAt: endingAt ?? this.endingAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (startingAt.present) {
      map['starting_at'] = Variable<String>(startingAt.value);
    }
    if (endingAt.present) {
      map['ending_at'] = Variable<String>(endingAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConcoursCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('titre: $titre, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('statut: $statut, ')
          ..write('startingAt: $startingAt, ')
          ..write('endingAt: $endingAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FiliereTable extends Filiere with TableInfo<$FiliereTable, FiliereData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FiliereTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _niveauMeta = const VerificationMeta('niveau');
  @override
  late final GeneratedColumn<String> niveau = GeneratedColumn<String>(
      'niveau', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parcoursCountMeta =
      const VerificationMeta('parcoursCount');
  @override
  late final GeneratedColumn<int> parcoursCount = GeneratedColumn<int>(
      'parcours_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, nom, slug, niveau, description, image, parcoursCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filiere';
  @override
  VerificationContext validateIntegrity(Insertable<FiliereData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('niveau')) {
      context.handle(_niveauMeta,
          niveau.isAcceptableOrUnknown(data['niveau']!, _niveauMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('parcours_count')) {
      context.handle(
          _parcoursCountMeta,
          parcoursCount.isAcceptableOrUnknown(
              data['parcours_count']!, _parcoursCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FiliereData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FiliereData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      niveau: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}niveau']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      parcoursCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parcours_count'])!,
    );
  }

  @override
  $FiliereTable createAlias(String alias) {
    return $FiliereTable(attachedDatabase, alias);
  }
}

class FiliereData extends DataClass implements Insertable<FiliereData> {
  final int id;
  final int? remoteId;
  final String nom;
  final String slug;
  final String? niveau;
  final String? description;
  final String? image;
  final int parcoursCount;
  const FiliereData(
      {required this.id,
      this.remoteId,
      required this.nom,
      required this.slug,
      this.niveau,
      this.description,
      this.image,
      required this.parcoursCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['nom'] = Variable<String>(nom);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || niveau != null) {
      map['niveau'] = Variable<String>(niveau);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['parcours_count'] = Variable<int>(parcoursCount);
    return map;
  }

  FiliereCompanion toCompanion(bool nullToAbsent) {
    return FiliereCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      nom: Value(nom),
      slug: Value(slug),
      niveau:
          niveau == null && nullToAbsent ? const Value.absent() : Value(niveau),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      parcoursCount: Value(parcoursCount),
    );
  }

  factory FiliereData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FiliereData(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      nom: serializer.fromJson<String>(json['nom']),
      slug: serializer.fromJson<String>(json['slug']),
      niveau: serializer.fromJson<String?>(json['niveau']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      parcoursCount: serializer.fromJson<int>(json['parcoursCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'nom': serializer.toJson<String>(nom),
      'slug': serializer.toJson<String>(slug),
      'niveau': serializer.toJson<String?>(niveau),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
      'parcoursCount': serializer.toJson<int>(parcoursCount),
    };
  }

  FiliereData copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          String? nom,
          String? slug,
          Value<String?> niveau = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent(),
          int? parcoursCount}) =>
      FiliereData(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        nom: nom ?? this.nom,
        slug: slug ?? this.slug,
        niveau: niveau.present ? niveau.value : this.niveau,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
        parcoursCount: parcoursCount ?? this.parcoursCount,
      );
  FiliereData copyWithCompanion(FiliereCompanion data) {
    return FiliereData(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      nom: data.nom.present ? data.nom.value : this.nom,
      slug: data.slug.present ? data.slug.value : this.slug,
      niveau: data.niveau.present ? data.niveau.value : this.niveau,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      parcoursCount: data.parcoursCount.present
          ? data.parcoursCount.value
          : this.parcoursCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FiliereData(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nom: $nom, ')
          ..write('slug: $slug, ')
          ..write('niveau: $niveau, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('parcoursCount: $parcoursCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, remoteId, nom, slug, niveau, description, image, parcoursCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FiliereData &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.nom == this.nom &&
          other.slug == this.slug &&
          other.niveau == this.niveau &&
          other.description == this.description &&
          other.image == this.image &&
          other.parcoursCount == this.parcoursCount);
}

class FiliereCompanion extends UpdateCompanion<FiliereData> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> nom;
  final Value<String> slug;
  final Value<String?> niveau;
  final Value<String?> description;
  final Value<String?> image;
  final Value<int> parcoursCount;
  const FiliereCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.nom = const Value.absent(),
    this.slug = const Value.absent(),
    this.niveau = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.parcoursCount = const Value.absent(),
  });
  FiliereCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String nom,
    required String slug,
    this.niveau = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.parcoursCount = const Value.absent(),
  })  : nom = Value(nom),
        slug = Value(slug);
  static Insertable<FiliereData> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? nom,
    Expression<String>? slug,
    Expression<String>? niveau,
    Expression<String>? description,
    Expression<String>? image,
    Expression<int>? parcoursCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (nom != null) 'nom': nom,
      if (slug != null) 'slug': slug,
      if (niveau != null) 'niveau': niveau,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (parcoursCount != null) 'parcours_count': parcoursCount,
    });
  }

  FiliereCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<String>? nom,
      Value<String>? slug,
      Value<String?>? niveau,
      Value<String?>? description,
      Value<String?>? image,
      Value<int>? parcoursCount}) {
    return FiliereCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nom: nom ?? this.nom,
      slug: slug ?? this.slug,
      niveau: niveau ?? this.niveau,
      description: description ?? this.description,
      image: image ?? this.image,
      parcoursCount: parcoursCount ?? this.parcoursCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (niveau.present) {
      map['niveau'] = Variable<String>(niveau.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (parcoursCount.present) {
      map['parcours_count'] = Variable<int>(parcoursCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FiliereCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('nom: $nom, ')
          ..write('slug: $slug, ')
          ..write('niveau: $niveau, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('parcoursCount: $parcoursCount')
          ..write(')'))
        .toString();
  }
}

class $ParcoursTable extends Parcours with TableInfo<$ParcoursTable, Parcour> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcoursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _filiereIdMeta =
      const VerificationMeta('filiereId');
  @override
  late final GeneratedColumn<int> filiereId = GeneratedColumn<int>(
      'filiere_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES filiere (id)'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, filiereId, remoteId, nom, description, image];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcours';
  @override
  VerificationContext validateIntegrity(Insertable<Parcour> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('filiere_id')) {
      context.handle(_filiereIdMeta,
          filiereId.isAcceptableOrUnknown(data['filiere_id']!, _filiereIdMeta));
    } else if (isInserting) {
      context.missing(_filiereIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Parcour map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Parcour(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      filiereId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}filiere_id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $ParcoursTable createAlias(String alias) {
    return $ParcoursTable(attachedDatabase, alias);
  }
}

class Parcour extends DataClass implements Insertable<Parcour> {
  final int id;
  final int filiereId;
  final int? remoteId;
  final String nom;
  final String? description;
  final String? image;
  const Parcour(
      {required this.id,
      required this.filiereId,
      this.remoteId,
      required this.nom,
      this.description,
      this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['filiere_id'] = Variable<int>(filiereId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  ParcoursCompanion toCompanion(bool nullToAbsent) {
    return ParcoursCompanion(
      id: Value(id),
      filiereId: Value(filiereId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      nom: Value(nom),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory Parcour.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Parcour(
      id: serializer.fromJson<int>(json['id']),
      filiereId: serializer.fromJson<int>(json['filiereId']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      nom: serializer.fromJson<String>(json['nom']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filiereId': serializer.toJson<int>(filiereId),
      'remoteId': serializer.toJson<int?>(remoteId),
      'nom': serializer.toJson<String>(nom),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
    };
  }

  Parcour copyWith(
          {int? id,
          int? filiereId,
          Value<int?> remoteId = const Value.absent(),
          String? nom,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
      Parcour(
        id: id ?? this.id,
        filiereId: filiereId ?? this.filiereId,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        nom: nom ?? this.nom,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
      );
  Parcour copyWithCompanion(ParcoursCompanion data) {
    return Parcour(
      id: data.id.present ? data.id.value : this.id,
      filiereId: data.filiereId.present ? data.filiereId.value : this.filiereId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      nom: data.nom.present ? data.nom.value : this.nom,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Parcour(')
          ..write('id: $id, ')
          ..write('filiereId: $filiereId, ')
          ..write('remoteId: $remoteId, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, filiereId, remoteId, nom, description, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parcour &&
          other.id == this.id &&
          other.filiereId == this.filiereId &&
          other.remoteId == this.remoteId &&
          other.nom == this.nom &&
          other.description == this.description &&
          other.image == this.image);
}

class ParcoursCompanion extends UpdateCompanion<Parcour> {
  final Value<int> id;
  final Value<int> filiereId;
  final Value<int?> remoteId;
  final Value<String> nom;
  final Value<String?> description;
  final Value<String?> image;
  const ParcoursCompanion({
    this.id = const Value.absent(),
    this.filiereId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.nom = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  });
  ParcoursCompanion.insert({
    this.id = const Value.absent(),
    required int filiereId,
    this.remoteId = const Value.absent(),
    required String nom,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  })  : filiereId = Value(filiereId),
        nom = Value(nom);
  static Insertable<Parcour> custom({
    Expression<int>? id,
    Expression<int>? filiereId,
    Expression<int>? remoteId,
    Expression<String>? nom,
    Expression<String>? description,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filiereId != null) 'filiere_id': filiereId,
      if (remoteId != null) 'remote_id': remoteId,
      if (nom != null) 'nom': nom,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
    });
  }

  ParcoursCompanion copyWith(
      {Value<int>? id,
      Value<int>? filiereId,
      Value<int?>? remoteId,
      Value<String>? nom,
      Value<String?>? description,
      Value<String?>? image}) {
    return ParcoursCompanion(
      id: id ?? this.id,
      filiereId: filiereId ?? this.filiereId,
      remoteId: remoteId ?? this.remoteId,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filiereId.present) {
      map['filiere_id'] = Variable<int>(filiereId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParcoursCompanion(')
          ..write('id: $id, ')
          ..write('filiereId: $filiereId, ')
          ..write('remoteId: $remoteId, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $AppNotificationsTable extends AppNotifications
    with TableInfo<$AppNotificationsTable, AppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, remoteId, title, message, icon, isRead, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_notifications';
  @override
  VerificationContext validateIntegrity(Insertable<AppNotification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotification(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $AppNotificationsTable createAlias(String alias) {
    return $AppNotificationsTable(attachedDatabase, alias);
  }
}

class AppNotification extends DataClass implements Insertable<AppNotification> {
  final int id;
  final int? remoteId;
  final String title;
  final String? message;
  final String? icon;
  final bool isRead;
  final DateTime? createdAt;
  const AppNotification(
      {required this.id,
      this.remoteId,
      required this.title,
      this.message,
      this.icon,
      required this.isRead,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_read'] = Variable<bool>(isRead);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  AppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return AppNotificationsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      title: Value(title),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isRead: Value(isRead),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotification(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String?>(json['message']),
      icon: serializer.fromJson<String?>(json['icon']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String?>(message),
      'icon': serializer.toJson<String?>(icon),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  AppNotification copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          String? title,
          Value<String?> message = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          bool? isRead,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      AppNotification(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        title: title ?? this.title,
        message: message.present ? message.value : this.message,
        icon: icon.present ? icon.value : this.icon,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  AppNotification copyWithCompanion(AppNotificationsCompanion data) {
    return AppNotification(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      icon: data.icon.present ? data.icon.value : this.icon,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotification(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('icon: $icon, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, remoteId, title, message, icon, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotification &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.message == this.message &&
          other.icon == this.icon &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class AppNotificationsCompanion extends UpdateCompanion<AppNotification> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> title;
  final Value<String?> message;
  final Value<String?> icon;
  final Value<bool> isRead;
  final Value<DateTime?> createdAt;
  const AppNotificationsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.icon = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppNotificationsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String title,
    this.message = const Value.absent(),
    this.icon = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<AppNotification> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? title,
    Expression<String>? message,
    Expression<String>? icon,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (icon != null) 'icon': icon,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppNotificationsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<String>? title,
      Value<String?>? message,
      Value<String?>? icon,
      Value<bool>? isRead,
      Value<DateTime?>? createdAt}) {
    return AppNotificationsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('icon: $icon, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AdmissionDraftsTable extends AdmissionDrafts
    with TableInfo<$AdmissionDraftsTable, AdmissionDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdmissionDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _localUuidMeta =
      const VerificationMeta('localUuid');
  @override
  late final GeneratedColumn<String> localUuid = GeneratedColumn<String>(
      'local_uuid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, localUuid, remoteId, dataJson, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admission_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<AdmissionDraft> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_uuid')) {
      context.handle(_localUuidMeta,
          localUuid.isAcceptableOrUnknown(data['local_uuid']!, _localUuidMeta));
    } else if (isInserting) {
      context.missing(_localUuidMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdmissionDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdmissionDraft(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      localUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_uuid'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AdmissionDraftsTable createAlias(String alias) {
    return $AdmissionDraftsTable(attachedDatabase, alias);
  }
}

class AdmissionDraft extends DataClass implements Insertable<AdmissionDraft> {
  final int id;
  final String localUuid;
  final int? remoteId;
  final String dataJson;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const AdmissionDraft(
      {required this.id,
      required this.localUuid,
      this.remoteId,
      required this.dataJson,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_uuid'] = Variable<String>(localUuid);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['data_json'] = Variable<String>(dataJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AdmissionDraftsCompanion toCompanion(bool nullToAbsent) {
    return AdmissionDraftsCompanion(
      id: Value(id),
      localUuid: Value(localUuid),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      dataJson: Value(dataJson),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AdmissionDraft.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdmissionDraft(
      id: serializer.fromJson<int>(json['id']),
      localUuid: serializer.fromJson<String>(json['localUuid']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localUuid': serializer.toJson<String>(localUuid),
      'remoteId': serializer.toJson<int?>(remoteId),
      'dataJson': serializer.toJson<String>(dataJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AdmissionDraft copyWith(
          {int? id,
          String? localUuid,
          Value<int?> remoteId = const Value.absent(),
          String? dataJson,
          String? status,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AdmissionDraft(
        id: id ?? this.id,
        localUuid: localUuid ?? this.localUuid,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        dataJson: dataJson ?? this.dataJson,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AdmissionDraft copyWithCompanion(AdmissionDraftsCompanion data) {
    return AdmissionDraft(
      id: data.id.present ? data.id.value : this.id,
      localUuid: data.localUuid.present ? data.localUuid.value : this.localUuid,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionDraft(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, localUuid, remoteId, dataJson, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdmissionDraft &&
          other.id == this.id &&
          other.localUuid == this.localUuid &&
          other.remoteId == this.remoteId &&
          other.dataJson == this.dataJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AdmissionDraftsCompanion extends UpdateCompanion<AdmissionDraft> {
  final Value<int> id;
  final Value<String> localUuid;
  final Value<int?> remoteId;
  final Value<String> dataJson;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const AdmissionDraftsCompanion({
    this.id = const Value.absent(),
    this.localUuid = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AdmissionDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String localUuid,
    this.remoteId = const Value.absent(),
    required String dataJson,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : localUuid = Value(localUuid),
        dataJson = Value(dataJson);
  static Insertable<AdmissionDraft> custom({
    Expression<int>? id,
    Expression<String>? localUuid,
    Expression<int>? remoteId,
    Expression<String>? dataJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localUuid != null) 'local_uuid': localUuid,
      if (remoteId != null) 'remote_id': remoteId,
      if (dataJson != null) 'data_json': dataJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AdmissionDraftsCompanion copyWith(
      {Value<int>? id,
      Value<String>? localUuid,
      Value<int?>? remoteId,
      Value<String>? dataJson,
      Value<String>? status,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return AdmissionDraftsCompanion(
      id: id ?? this.id,
      localUuid: localUuid ?? this.localUuid,
      remoteId: remoteId ?? this.remoteId,
      dataJson: dataJson ?? this.dataJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localUuid.present) {
      map['local_uuid'] = Variable<String>(localUuid.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionDraftsCompanion(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<int> draftId = GeneratedColumn<int>(
      'draft_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES admission_drafts (id)'));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uploadStatusMeta =
      const VerificationMeta('uploadStatus');
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
      'upload_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        draftId,
        localPath,
        fileName,
        mimeType,
        size,
        uploadStatus,
        retryCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('upload_status')) {
      context.handle(
          _uploadStatusMeta,
          uploadStatus.isAcceptableOrUnknown(
              data['upload_status']!, _uploadStatusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}draft_id']),
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      uploadStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upload_status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final int? draftId;
  final String localPath;
  final String? fileName;
  final String? mimeType;
  final int? size;
  final String uploadStatus;
  final int retryCount;
  const Document(
      {required this.id,
      this.draftId,
      required this.localPath,
      this.fileName,
      this.mimeType,
      this.size,
      required this.uploadStatus,
      required this.retryCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || draftId != null) {
      map['draft_id'] = Variable<int>(draftId);
    }
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      draftId: draftId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftId),
      localPath: Value(localPath),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      uploadStatus: Value(uploadStatus),
      retryCount: Value(retryCount),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      draftId: serializer.fromJson<int?>(json['draftId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      size: serializer.fromJson<int?>(json['size']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftId': serializer.toJson<int?>(draftId),
      'localPath': serializer.toJson<String>(localPath),
      'fileName': serializer.toJson<String?>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'size': serializer.toJson<int?>(size),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  Document copyWith(
          {int? id,
          Value<int?> draftId = const Value.absent(),
          String? localPath,
          Value<String?> fileName = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<int?> size = const Value.absent(),
          String? uploadStatus,
          int? retryCount}) =>
      Document(
        id: id ?? this.id,
        draftId: draftId.present ? draftId.value : this.draftId,
        localPath: localPath ?? this.localPath,
        fileName: fileName.present ? fileName.value : this.fileName,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        size: size.present ? size.value : this.size,
        uploadStatus: uploadStatus ?? this.uploadStatus,
        retryCount: retryCount ?? this.retryCount,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      size: data.size.present ? data.size.value : this.size,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, draftId, localPath, fileName, mimeType,
      size, uploadStatus, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.draftId == this.draftId &&
          other.localPath == this.localPath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.size == this.size &&
          other.uploadStatus == this.uploadStatus &&
          other.retryCount == this.retryCount);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<int?> draftId;
  final Value<String> localPath;
  final Value<String?> fileName;
  final Value<String?> mimeType;
  final Value<int?> size;
  final Value<String> uploadStatus;
  final Value<int> retryCount;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    required String localPath,
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : localPath = Value(localPath);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<int>? draftId,
    Expression<String>? localPath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? size,
    Expression<String>? uploadStatus,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftId != null) 'draft_id': draftId,
      if (localPath != null) 'local_path': localPath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (size != null) 'size': size,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  DocumentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? draftId,
      Value<String>? localPath,
      Value<String?>? fileName,
      Value<String?>? mimeType,
      Value<int?>? size,
      Value<String>? uploadStatus,
      Value<int>? retryCount}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<int>(draftId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

class $RegistrationDraftsTable extends RegistrationDrafts
    with TableInfo<$RegistrationDraftsTable, RegistrationDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrationDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _localUuidMeta =
      const VerificationMeta('localUuid');
  @override
  late final GeneratedColumn<String> localUuid = GeneratedColumn<String>(
      'local_uuid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, localUuid, remoteId, dataJson, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registration_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<RegistrationDraft> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_uuid')) {
      context.handle(_localUuidMeta,
          localUuid.isAcceptableOrUnknown(data['local_uuid']!, _localUuidMeta));
    } else if (isInserting) {
      context.missing(_localUuidMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistrationDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistrationDraft(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      localUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_uuid'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RegistrationDraftsTable createAlias(String alias) {
    return $RegistrationDraftsTable(attachedDatabase, alias);
  }
}

class RegistrationDraft extends DataClass
    implements Insertable<RegistrationDraft> {
  final int id;
  final String localUuid;
  final int? remoteId;
  final String dataJson;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const RegistrationDraft(
      {required this.id,
      required this.localUuid,
      this.remoteId,
      required this.dataJson,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_uuid'] = Variable<String>(localUuid);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['data_json'] = Variable<String>(dataJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RegistrationDraftsCompanion toCompanion(bool nullToAbsent) {
    return RegistrationDraftsCompanion(
      id: Value(id),
      localUuid: Value(localUuid),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      dataJson: Value(dataJson),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RegistrationDraft.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistrationDraft(
      id: serializer.fromJson<int>(json['id']),
      localUuid: serializer.fromJson<String>(json['localUuid']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localUuid': serializer.toJson<String>(localUuid),
      'remoteId': serializer.toJson<int?>(remoteId),
      'dataJson': serializer.toJson<String>(dataJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RegistrationDraft copyWith(
          {int? id,
          String? localUuid,
          Value<int?> remoteId = const Value.absent(),
          String? dataJson,
          String? status,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      RegistrationDraft(
        id: id ?? this.id,
        localUuid: localUuid ?? this.localUuid,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        dataJson: dataJson ?? this.dataJson,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  RegistrationDraft copyWithCompanion(RegistrationDraftsCompanion data) {
    return RegistrationDraft(
      id: data.id.present ? data.id.value : this.id,
      localUuid: data.localUuid.present ? data.localUuid.value : this.localUuid,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationDraft(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, localUuid, remoteId, dataJson, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistrationDraft &&
          other.id == this.id &&
          other.localUuid == this.localUuid &&
          other.remoteId == this.remoteId &&
          other.dataJson == this.dataJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RegistrationDraftsCompanion extends UpdateCompanion<RegistrationDraft> {
  final Value<int> id;
  final Value<String> localUuid;
  final Value<int?> remoteId;
  final Value<String> dataJson;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const RegistrationDraftsCompanion({
    this.id = const Value.absent(),
    this.localUuid = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RegistrationDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String localUuid,
    this.remoteId = const Value.absent(),
    required String dataJson,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : localUuid = Value(localUuid),
        dataJson = Value(dataJson);
  static Insertable<RegistrationDraft> custom({
    Expression<int>? id,
    Expression<String>? localUuid,
    Expression<int>? remoteId,
    Expression<String>? dataJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localUuid != null) 'local_uuid': localUuid,
      if (remoteId != null) 'remote_id': remoteId,
      if (dataJson != null) 'data_json': dataJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RegistrationDraftsCompanion copyWith(
      {Value<int>? id,
      Value<String>? localUuid,
      Value<int?>? remoteId,
      Value<String>? dataJson,
      Value<String>? status,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return RegistrationDraftsCompanion(
      id: id ?? this.id,
      localUuid: localUuid ?? this.localUuid,
      remoteId: remoteId ?? this.remoteId,
      dataJson: dataJson ?? this.dataJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localUuid.present) {
      map['local_uuid'] = Variable<String>(localUuid.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationDraftsCompanion(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RegistrationDocumentsTable extends RegistrationDocuments
    with TableInfo<$RegistrationDocumentsTable, RegistrationDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrationDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<int> draftId = GeneratedColumn<int>(
      'draft_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES registration_drafts (id)'));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uploadStatusMeta =
      const VerificationMeta('uploadStatus');
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
      'upload_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        draftId,
        localPath,
        fileName,
        mimeType,
        size,
        uploadStatus,
        retryCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registration_documents';
  @override
  VerificationContext validateIntegrity(
      Insertable<RegistrationDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('upload_status')) {
      context.handle(
          _uploadStatusMeta,
          uploadStatus.isAcceptableOrUnknown(
              data['upload_status']!, _uploadStatusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegistrationDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegistrationDocument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}draft_id']),
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      uploadStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upload_status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
    );
  }

  @override
  $RegistrationDocumentsTable createAlias(String alias) {
    return $RegistrationDocumentsTable(attachedDatabase, alias);
  }
}

class RegistrationDocument extends DataClass
    implements Insertable<RegistrationDocument> {
  final int id;
  final int? draftId;
  final String localPath;
  final String? fileName;
  final String? mimeType;
  final int? size;
  final String uploadStatus;
  final int retryCount;
  const RegistrationDocument(
      {required this.id,
      this.draftId,
      required this.localPath,
      this.fileName,
      this.mimeType,
      this.size,
      required this.uploadStatus,
      required this.retryCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || draftId != null) {
      map['draft_id'] = Variable<int>(draftId);
    }
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  RegistrationDocumentsCompanion toCompanion(bool nullToAbsent) {
    return RegistrationDocumentsCompanion(
      id: Value(id),
      draftId: draftId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftId),
      localPath: Value(localPath),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      uploadStatus: Value(uploadStatus),
      retryCount: Value(retryCount),
    );
  }

  factory RegistrationDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegistrationDocument(
      id: serializer.fromJson<int>(json['id']),
      draftId: serializer.fromJson<int?>(json['draftId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      size: serializer.fromJson<int?>(json['size']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftId': serializer.toJson<int?>(draftId),
      'localPath': serializer.toJson<String>(localPath),
      'fileName': serializer.toJson<String?>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'size': serializer.toJson<int?>(size),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  RegistrationDocument copyWith(
          {int? id,
          Value<int?> draftId = const Value.absent(),
          String? localPath,
          Value<String?> fileName = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<int?> size = const Value.absent(),
          String? uploadStatus,
          int? retryCount}) =>
      RegistrationDocument(
        id: id ?? this.id,
        draftId: draftId.present ? draftId.value : this.draftId,
        localPath: localPath ?? this.localPath,
        fileName: fileName.present ? fileName.value : this.fileName,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        size: size.present ? size.value : this.size,
        uploadStatus: uploadStatus ?? this.uploadStatus,
        retryCount: retryCount ?? this.retryCount,
      );
  RegistrationDocument copyWithCompanion(RegistrationDocumentsCompanion data) {
    return RegistrationDocument(
      id: data.id.present ? data.id.value : this.id,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      size: data.size.present ? data.size.value : this.size,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationDocument(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, draftId, localPath, fileName, mimeType,
      size, uploadStatus, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegistrationDocument &&
          other.id == this.id &&
          other.draftId == this.draftId &&
          other.localPath == this.localPath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.size == this.size &&
          other.uploadStatus == this.uploadStatus &&
          other.retryCount == this.retryCount);
}

class RegistrationDocumentsCompanion
    extends UpdateCompanion<RegistrationDocument> {
  final Value<int> id;
  final Value<int?> draftId;
  final Value<String> localPath;
  final Value<String?> fileName;
  final Value<String?> mimeType;
  final Value<int?> size;
  final Value<String> uploadStatus;
  final Value<int> retryCount;
  const RegistrationDocumentsCompanion({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  RegistrationDocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    required String localPath,
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : localPath = Value(localPath);
  static Insertable<RegistrationDocument> custom({
    Expression<int>? id,
    Expression<int>? draftId,
    Expression<String>? localPath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? size,
    Expression<String>? uploadStatus,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftId != null) 'draft_id': draftId,
      if (localPath != null) 'local_path': localPath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (size != null) 'size': size,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  RegistrationDocumentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? draftId,
      Value<String>? localPath,
      Value<String?>? fileName,
      Value<String?>? mimeType,
      Value<int?>? size,
      Value<String>? uploadStatus,
      Value<int>? retryCount}) {
    return RegistrationDocumentsCompanion(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<int>(draftId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrationDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

class $PostulationDraftsTable extends PostulationDrafts
    with TableInfo<$PostulationDraftsTable, PostulationDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostulationDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _localUuidMeta =
      const VerificationMeta('localUuid');
  @override
  late final GeneratedColumn<String> localUuid = GeneratedColumn<String>(
      'local_uuid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _concoursSlugMeta =
      const VerificationMeta('concoursSlug');
  @override
  late final GeneratedColumn<String> concoursSlug = GeneratedColumn<String>(
      'concours_slug', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _postulationTokenMeta =
      const VerificationMeta('postulationToken');
  @override
  late final GeneratedColumn<String> postulationToken = GeneratedColumn<String>(
      'postulation_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        localUuid,
        remoteId,
        reference,
        concoursSlug,
        dataJson,
        postulationToken,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postulation_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<PostulationDraft> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_uuid')) {
      context.handle(_localUuidMeta,
          localUuid.isAcceptableOrUnknown(data['local_uuid']!, _localUuidMeta));
    } else if (isInserting) {
      context.missing(_localUuidMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('concours_slug')) {
      context.handle(
          _concoursSlugMeta,
          concoursSlug.isAcceptableOrUnknown(
              data['concours_slug']!, _concoursSlugMeta));
    } else if (isInserting) {
      context.missing(_concoursSlugMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('postulation_token')) {
      context.handle(
          _postulationTokenMeta,
          postulationToken.isAcceptableOrUnknown(
              data['postulation_token']!, _postulationTokenMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostulationDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostulationDraft(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      localUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_uuid'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      concoursSlug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concours_slug'])!,
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      postulationToken: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}postulation_token']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PostulationDraftsTable createAlias(String alias) {
    return $PostulationDraftsTable(attachedDatabase, alias);
  }
}

class PostulationDraft extends DataClass
    implements Insertable<PostulationDraft> {
  final int id;
  final String localUuid;
  final String? remoteId;
  final String? reference;
  final String concoursSlug;
  final String dataJson;
  final String? postulationToken;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const PostulationDraft(
      {required this.id,
      required this.localUuid,
      this.remoteId,
      this.reference,
      required this.concoursSlug,
      required this.dataJson,
      this.postulationToken,
      required this.status,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_uuid'] = Variable<String>(localUuid);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['concours_slug'] = Variable<String>(concoursSlug);
    map['data_json'] = Variable<String>(dataJson);
    if (!nullToAbsent || postulationToken != null) {
      map['postulation_token'] = Variable<String>(postulationToken);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PostulationDraftsCompanion toCompanion(bool nullToAbsent) {
    return PostulationDraftsCompanion(
      id: Value(id),
      localUuid: Value(localUuid),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      concoursSlug: Value(concoursSlug),
      dataJson: Value(dataJson),
      postulationToken: postulationToken == null && nullToAbsent
          ? const Value.absent()
          : Value(postulationToken),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PostulationDraft.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostulationDraft(
      id: serializer.fromJson<int>(json['id']),
      localUuid: serializer.fromJson<String>(json['localUuid']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      reference: serializer.fromJson<String?>(json['reference']),
      concoursSlug: serializer.fromJson<String>(json['concoursSlug']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      postulationToken: serializer.fromJson<String?>(json['postulationToken']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localUuid': serializer.toJson<String>(localUuid),
      'remoteId': serializer.toJson<String?>(remoteId),
      'reference': serializer.toJson<String?>(reference),
      'concoursSlug': serializer.toJson<String>(concoursSlug),
      'dataJson': serializer.toJson<String>(dataJson),
      'postulationToken': serializer.toJson<String?>(postulationToken),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PostulationDraft copyWith(
          {int? id,
          String? localUuid,
          Value<String?> remoteId = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          String? concoursSlug,
          String? dataJson,
          Value<String?> postulationToken = const Value.absent(),
          String? status,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PostulationDraft(
        id: id ?? this.id,
        localUuid: localUuid ?? this.localUuid,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        reference: reference.present ? reference.value : this.reference,
        concoursSlug: concoursSlug ?? this.concoursSlug,
        dataJson: dataJson ?? this.dataJson,
        postulationToken: postulationToken.present
            ? postulationToken.value
            : this.postulationToken,
        status: status ?? this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  PostulationDraft copyWithCompanion(PostulationDraftsCompanion data) {
    return PostulationDraft(
      id: data.id.present ? data.id.value : this.id,
      localUuid: data.localUuid.present ? data.localUuid.value : this.localUuid,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      reference: data.reference.present ? data.reference.value : this.reference,
      concoursSlug: data.concoursSlug.present
          ? data.concoursSlug.value
          : this.concoursSlug,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      postulationToken: data.postulationToken.present
          ? data.postulationToken.value
          : this.postulationToken,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostulationDraft(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('reference: $reference, ')
          ..write('concoursSlug: $concoursSlug, ')
          ..write('dataJson: $dataJson, ')
          ..write('postulationToken: $postulationToken, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, localUuid, remoteId, reference,
      concoursSlug, dataJson, postulationToken, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostulationDraft &&
          other.id == this.id &&
          other.localUuid == this.localUuid &&
          other.remoteId == this.remoteId &&
          other.reference == this.reference &&
          other.concoursSlug == this.concoursSlug &&
          other.dataJson == this.dataJson &&
          other.postulationToken == this.postulationToken &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PostulationDraftsCompanion extends UpdateCompanion<PostulationDraft> {
  final Value<int> id;
  final Value<String> localUuid;
  final Value<String?> remoteId;
  final Value<String?> reference;
  final Value<String> concoursSlug;
  final Value<String> dataJson;
  final Value<String?> postulationToken;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const PostulationDraftsCompanion({
    this.id = const Value.absent(),
    this.localUuid = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.reference = const Value.absent(),
    this.concoursSlug = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.postulationToken = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PostulationDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String localUuid,
    this.remoteId = const Value.absent(),
    this.reference = const Value.absent(),
    required String concoursSlug,
    required String dataJson,
    this.postulationToken = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : localUuid = Value(localUuid),
        concoursSlug = Value(concoursSlug),
        dataJson = Value(dataJson);
  static Insertable<PostulationDraft> custom({
    Expression<int>? id,
    Expression<String>? localUuid,
    Expression<String>? remoteId,
    Expression<String>? reference,
    Expression<String>? concoursSlug,
    Expression<String>? dataJson,
    Expression<String>? postulationToken,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localUuid != null) 'local_uuid': localUuid,
      if (remoteId != null) 'remote_id': remoteId,
      if (reference != null) 'reference': reference,
      if (concoursSlug != null) 'concours_slug': concoursSlug,
      if (dataJson != null) 'data_json': dataJson,
      if (postulationToken != null) 'postulation_token': postulationToken,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PostulationDraftsCompanion copyWith(
      {Value<int>? id,
      Value<String>? localUuid,
      Value<String?>? remoteId,
      Value<String?>? reference,
      Value<String>? concoursSlug,
      Value<String>? dataJson,
      Value<String?>? postulationToken,
      Value<String>? status,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return PostulationDraftsCompanion(
      id: id ?? this.id,
      localUuid: localUuid ?? this.localUuid,
      remoteId: remoteId ?? this.remoteId,
      reference: reference ?? this.reference,
      concoursSlug: concoursSlug ?? this.concoursSlug,
      dataJson: dataJson ?? this.dataJson,
      postulationToken: postulationToken ?? this.postulationToken,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localUuid.present) {
      map['local_uuid'] = Variable<String>(localUuid.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (concoursSlug.present) {
      map['concours_slug'] = Variable<String>(concoursSlug.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (postulationToken.present) {
      map['postulation_token'] = Variable<String>(postulationToken.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostulationDraftsCompanion(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('remoteId: $remoteId, ')
          ..write('reference: $reference, ')
          ..write('concoursSlug: $concoursSlug, ')
          ..write('dataJson: $dataJson, ')
          ..write('postulationToken: $postulationToken, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PostulationDocumentsTable extends PostulationDocuments
    with TableInfo<$PostulationDocumentsTable, PostulationDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostulationDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<int> draftId = GeneratedColumn<int>(
      'draft_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES postulation_drafts (id)'));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _documentTypeMeta =
      const VerificationMeta('documentType');
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
      'document_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadStatusMeta =
      const VerificationMeta('uploadStatus');
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
      'upload_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        draftId,
        localPath,
        fileName,
        mimeType,
        size,
        documentType,
        uploadStatus,
        retryCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postulation_documents';
  @override
  VerificationContext validateIntegrity(
      Insertable<PostulationDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('document_type')) {
      context.handle(
          _documentTypeMeta,
          documentType.isAcceptableOrUnknown(
              data['document_type']!, _documentTypeMeta));
    }
    if (data.containsKey('upload_status')) {
      context.handle(
          _uploadStatusMeta,
          uploadStatus.isAcceptableOrUnknown(
              data['upload_status']!, _uploadStatusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostulationDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostulationDocument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}draft_id']),
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      documentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_type']),
      uploadStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upload_status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
    );
  }

  @override
  $PostulationDocumentsTable createAlias(String alias) {
    return $PostulationDocumentsTable(attachedDatabase, alias);
  }
}

class PostulationDocument extends DataClass
    implements Insertable<PostulationDocument> {
  final int id;
  final int? draftId;
  final String localPath;
  final String? fileName;
  final String? mimeType;
  final int? size;
  final String? documentType;
  final String uploadStatus;
  final int retryCount;
  const PostulationDocument(
      {required this.id,
      this.draftId,
      required this.localPath,
      this.fileName,
      this.mimeType,
      this.size,
      this.documentType,
      required this.uploadStatus,
      required this.retryCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || draftId != null) {
      map['draft_id'] = Variable<int>(draftId);
    }
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || documentType != null) {
      map['document_type'] = Variable<String>(documentType);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  PostulationDocumentsCompanion toCompanion(bool nullToAbsent) {
    return PostulationDocumentsCompanion(
      id: Value(id),
      draftId: draftId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftId),
      localPath: Value(localPath),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      documentType: documentType == null && nullToAbsent
          ? const Value.absent()
          : Value(documentType),
      uploadStatus: Value(uploadStatus),
      retryCount: Value(retryCount),
    );
  }

  factory PostulationDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostulationDocument(
      id: serializer.fromJson<int>(json['id']),
      draftId: serializer.fromJson<int?>(json['draftId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      size: serializer.fromJson<int?>(json['size']),
      documentType: serializer.fromJson<String?>(json['documentType']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftId': serializer.toJson<int?>(draftId),
      'localPath': serializer.toJson<String>(localPath),
      'fileName': serializer.toJson<String?>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'size': serializer.toJson<int?>(size),
      'documentType': serializer.toJson<String?>(documentType),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  PostulationDocument copyWith(
          {int? id,
          Value<int?> draftId = const Value.absent(),
          String? localPath,
          Value<String?> fileName = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<int?> size = const Value.absent(),
          Value<String?> documentType = const Value.absent(),
          String? uploadStatus,
          int? retryCount}) =>
      PostulationDocument(
        id: id ?? this.id,
        draftId: draftId.present ? draftId.value : this.draftId,
        localPath: localPath ?? this.localPath,
        fileName: fileName.present ? fileName.value : this.fileName,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        size: size.present ? size.value : this.size,
        documentType:
            documentType.present ? documentType.value : this.documentType,
        uploadStatus: uploadStatus ?? this.uploadStatus,
        retryCount: retryCount ?? this.retryCount,
      );
  PostulationDocument copyWithCompanion(PostulationDocumentsCompanion data) {
    return PostulationDocument(
      id: data.id.present ? data.id.value : this.id,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      size: data.size.present ? data.size.value : this.size,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostulationDocument(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('documentType: $documentType, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, draftId, localPath, fileName, mimeType,
      size, documentType, uploadStatus, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostulationDocument &&
          other.id == this.id &&
          other.draftId == this.draftId &&
          other.localPath == this.localPath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.size == this.size &&
          other.documentType == this.documentType &&
          other.uploadStatus == this.uploadStatus &&
          other.retryCount == this.retryCount);
}

class PostulationDocumentsCompanion
    extends UpdateCompanion<PostulationDocument> {
  final Value<int> id;
  final Value<int?> draftId;
  final Value<String> localPath;
  final Value<String?> fileName;
  final Value<String?> mimeType;
  final Value<int?> size;
  final Value<String?> documentType;
  final Value<String> uploadStatus;
  final Value<int> retryCount;
  const PostulationDocumentsCompanion({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.documentType = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  PostulationDocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    required String localPath,
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.documentType = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : localPath = Value(localPath);
  static Insertable<PostulationDocument> custom({
    Expression<int>? id,
    Expression<int>? draftId,
    Expression<String>? localPath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? size,
    Expression<String>? documentType,
    Expression<String>? uploadStatus,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftId != null) 'draft_id': draftId,
      if (localPath != null) 'local_path': localPath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (size != null) 'size': size,
      if (documentType != null) 'document_type': documentType,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  PostulationDocumentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? draftId,
      Value<String>? localPath,
      Value<String?>? fileName,
      Value<String?>? mimeType,
      Value<int?>? size,
      Value<String?>? documentType,
      Value<String>? uploadStatus,
      Value<int>? retryCount}) {
    return PostulationDocumentsCompanion(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      documentType: documentType ?? this.documentType,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<int>(draftId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostulationDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('size: $size, ')
          ..write('documentType: $documentType, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientOperationIdMeta =
      const VerificationMeta('clientOperationId');
  @override
  late final GeneratedColumn<String> clientOperationId =
      GeneratedColumn<String>('client_operation_id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 64),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, clientOperationId, type, payload, status, retryCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOperation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_operation_id')) {
      context.handle(
          _clientOperationIdMeta,
          clientOperationId.isAcceptableOrUnknown(
              data['client_operation_id']!, _clientOperationIdMeta));
    } else if (isInserting) {
      context.missing(_clientOperationIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clientOperationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}client_operation_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final int id;
  final String clientOperationId;
  final String type;
  final String payload;
  final String status;
  final int retryCount;
  final DateTime? createdAt;
  const SyncOperation(
      {required this.id,
      required this.clientOperationId,
      required this.type,
      required this.payload,
      required this.status,
      required this.retryCount,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_operation_id'] = Variable<String>(clientOperationId);
    map['type'] = Variable<String>(type);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      clientOperationId: Value(clientOperationId),
      type: Value(type),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<int>(json['id']),
      clientOperationId: serializer.fromJson<String>(json['clientOperationId']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientOperationId': serializer.toJson<String>(clientOperationId),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  SyncOperation copyWith(
          {int? id,
          String? clientOperationId,
          String? type,
          String? payload,
          String? status,
          int? retryCount,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      SyncOperation(
        id: id ?? this.id,
        clientOperationId: clientOperationId ?? this.clientOperationId,
        type: type ?? this.type,
        payload: payload ?? this.payload,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      clientOperationId: data.clientOperationId.present
          ? data.clientOperationId.value
          : this.clientOperationId,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('clientOperationId: $clientOperationId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, clientOperationId, type, payload, status, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.clientOperationId == this.clientOperationId &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<int> id;
  final Value<String> clientOperationId;
  final Value<String> type;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime?> createdAt;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.clientOperationId = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    this.id = const Value.absent(),
    required String clientOperationId,
    required String type,
    required String payload,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : clientOperationId = Value(clientOperationId),
        type = Value(type),
        payload = Value(payload);
  static Insertable<SyncOperation> custom({
    Expression<int>? id,
    Expression<String>? clientOperationId,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientOperationId != null) 'client_operation_id': clientOperationId,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncOperationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? clientOperationId,
      Value<String>? type,
      Value<String>? payload,
      Value<String>? status,
      Value<int>? retryCount,
      Value<DateTime?>? createdAt}) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      clientOperationId: clientOperationId ?? this.clientOperationId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientOperationId.present) {
      map['client_operation_id'] = Variable<String>(clientOperationId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('clientOperationId: $clientOperationId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AdmissionFormsTable extends AdmissionForms
    with TableInfo<$AdmissionFormsTable, AdmissionForm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdmissionFormsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, dataJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admission_forms';
  @override
  VerificationContext validateIntegrity(Insertable<AdmissionForm> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdmissionForm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdmissionForm(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AdmissionFormsTable createAlias(String alias) {
    return $AdmissionFormsTable(attachedDatabase, alias);
  }
}

class AdmissionForm extends DataClass implements Insertable<AdmissionForm> {
  final int id;
  final String dataJson;
  final DateTime? updatedAt;
  const AdmissionForm(
      {required this.id, required this.dataJson, this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_json'] = Variable<String>(dataJson);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AdmissionFormsCompanion toCompanion(bool nullToAbsent) {
    return AdmissionFormsCompanion(
      id: Value(id),
      dataJson: Value(dataJson),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AdmissionForm.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdmissionForm(
      id: serializer.fromJson<int>(json['id']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataJson': serializer.toJson<String>(dataJson),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AdmissionForm copyWith(
          {int? id,
          String? dataJson,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AdmissionForm(
        id: id ?? this.id,
        dataJson: dataJson ?? this.dataJson,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AdmissionForm copyWithCompanion(AdmissionFormsCompanion data) {
    return AdmissionForm(
      id: data.id.present ? data.id.value : this.id,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionForm(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdmissionForm &&
          other.id == this.id &&
          other.dataJson == this.dataJson &&
          other.updatedAt == this.updatedAt);
}

class AdmissionFormsCompanion extends UpdateCompanion<AdmissionForm> {
  final Value<int> id;
  final Value<String> dataJson;
  final Value<DateTime?> updatedAt;
  const AdmissionFormsCompanion({
    this.id = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AdmissionFormsCompanion.insert({
    this.id = const Value.absent(),
    required String dataJson,
    this.updatedAt = const Value.absent(),
  }) : dataJson = Value(dataJson);
  static Insertable<AdmissionForm> custom({
    Expression<int>? id,
    Expression<String>? dataJson,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataJson != null) 'data_json': dataJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AdmissionFormsCompanion copyWith(
      {Value<int>? id, Value<String>? dataJson, Value<DateTime?>? updatedAt}) {
    return AdmissionFormsCompanion(
      id: id ?? this.id,
      dataJson: dataJson ?? this.dataJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionFormsCompanion(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AdmissionCampaignsTable extends AdmissionCampaigns
    with TableInfo<$AdmissionCampaignsTable, AdmissionCampaign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdmissionCampaignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, remoteId, dataJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admission_campaigns';
  @override
  VerificationContext validateIntegrity(Insertable<AdmissionCampaign> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdmissionCampaign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdmissionCampaign(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AdmissionCampaignsTable createAlias(String alias) {
    return $AdmissionCampaignsTable(attachedDatabase, alias);
  }
}

class AdmissionCampaign extends DataClass
    implements Insertable<AdmissionCampaign> {
  final int id;
  final int? remoteId;
  final String dataJson;
  final DateTime? updatedAt;
  const AdmissionCampaign(
      {required this.id,
      this.remoteId,
      required this.dataJson,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    map['data_json'] = Variable<String>(dataJson);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AdmissionCampaignsCompanion toCompanion(bool nullToAbsent) {
    return AdmissionCampaignsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      dataJson: Value(dataJson),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AdmissionCampaign.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdmissionCampaign(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<int?>(remoteId),
      'dataJson': serializer.toJson<String>(dataJson),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AdmissionCampaign copyWith(
          {int? id,
          Value<int?> remoteId = const Value.absent(),
          String? dataJson,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AdmissionCampaign(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        dataJson: dataJson ?? this.dataJson,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AdmissionCampaign copyWithCompanion(AdmissionCampaignsCompanion data) {
    return AdmissionCampaign(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionCampaign(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, dataJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdmissionCampaign &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.dataJson == this.dataJson &&
          other.updatedAt == this.updatedAt);
}

class AdmissionCampaignsCompanion extends UpdateCompanion<AdmissionCampaign> {
  final Value<int> id;
  final Value<int?> remoteId;
  final Value<String> dataJson;
  final Value<DateTime?> updatedAt;
  const AdmissionCampaignsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AdmissionCampaignsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String dataJson,
    this.updatedAt = const Value.absent(),
  }) : dataJson = Value(dataJson);
  static Insertable<AdmissionCampaign> custom({
    Expression<int>? id,
    Expression<int>? remoteId,
    Expression<String>? dataJson,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (dataJson != null) 'data_json': dataJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AdmissionCampaignsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? remoteId,
      Value<String>? dataJson,
      Value<DateTime?>? updatedAt}) {
    return AdmissionCampaignsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      dataJson: dataJson ?? this.dataJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionCampaignsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NewsTable news = $NewsTable(this);
  late final $PublicationsTable publications = $PublicationsTable(this);
  late final $ConcoursTable concours = $ConcoursTable(this);
  late final $FiliereTable filiere = $FiliereTable(this);
  late final $ParcoursTable parcours = $ParcoursTable(this);
  late final $AppNotificationsTable appNotifications =
      $AppNotificationsTable(this);
  late final $AdmissionDraftsTable admissionDrafts =
      $AdmissionDraftsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $RegistrationDraftsTable registrationDrafts =
      $RegistrationDraftsTable(this);
  late final $RegistrationDocumentsTable registrationDocuments =
      $RegistrationDocumentsTable(this);
  late final $PostulationDraftsTable postulationDrafts =
      $PostulationDraftsTable(this);
  late final $PostulationDocumentsTable postulationDocuments =
      $PostulationDocumentsTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  late final $AdmissionFormsTable admissionForms = $AdmissionFormsTable(this);
  late final $AdmissionCampaignsTable admissionCampaigns =
      $AdmissionCampaignsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        news,
        publications,
        concours,
        filiere,
        parcours,
        appNotifications,
        admissionDrafts,
        documents,
        registrationDrafts,
        registrationDocuments,
        postulationDrafts,
        postulationDocuments,
        syncOperations,
        admissionForms,
        admissionCampaigns
      ];
}

typedef $$NewsTableCreateCompanionBuilder = NewsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  required String title,
  required String slug,
  Value<String?> summary,
  Value<String?> content,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<bool> featured,
  Value<int?> categoryId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$NewsTableUpdateCompanionBuilder = NewsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<String> title,
  Value<String> slug,
  Value<String?> summary,
  Value<String?> content,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<bool> featured,
  Value<int?> categoryId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$NewsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NewsTable,
    New,
    $$NewsTableFilterComposer,
    $$NewsTableOrderingComposer,
    $$NewsTableCreateCompanionBuilder,
    $$NewsTableUpdateCompanionBuilder> {
  $$NewsTableTableManager(_$AppDatabase db, $NewsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$NewsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$NewsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<bool> featured = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              NewsCompanion(
            id: id,
            remoteId: remoteId,
            title: title,
            slug: slug,
            summary: summary,
            content: content,
            image: image,
            publishedAt: publishedAt,
            featured: featured,
            categoryId: categoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required String title,
            required String slug,
            Value<String?> summary = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<bool> featured = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              NewsCompanion.insert(
            id: id,
            remoteId: remoteId,
            title: title,
            slug: slug,
            summary: summary,
            content: content,
            image: image,
            publishedAt: publishedAt,
            featured: featured,
            categoryId: categoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$NewsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $NewsTable> {
  $$NewsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get summary => $state.composableBuilder(
      column: $state.table.summary,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get featured => $state.composableBuilder(
      column: $state.table.featured,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$NewsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $NewsTable> {
  $$NewsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get summary => $state.composableBuilder(
      column: $state.table.summary,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get featured => $state.composableBuilder(
      column: $state.table.featured,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PublicationsTableCreateCompanionBuilder = PublicationsCompanion
    Function({
  Value<int> id,
  Value<int?> remoteId,
  required String title,
  required String slug,
  Value<String?> summary,
  Value<String?> content,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<bool> featured,
  Value<int?> categoryId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$PublicationsTableUpdateCompanionBuilder = PublicationsCompanion
    Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<String> title,
  Value<String> slug,
  Value<String?> summary,
  Value<String?> content,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<bool> featured,
  Value<int?> categoryId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$PublicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PublicationsTable,
    Publication,
    $$PublicationsTableFilterComposer,
    $$PublicationsTableOrderingComposer,
    $$PublicationsTableCreateCompanionBuilder,
    $$PublicationsTableUpdateCompanionBuilder> {
  $$PublicationsTableTableManager(_$AppDatabase db, $PublicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PublicationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PublicationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<bool> featured = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PublicationsCompanion(
            id: id,
            remoteId: remoteId,
            title: title,
            slug: slug,
            summary: summary,
            content: content,
            image: image,
            publishedAt: publishedAt,
            featured: featured,
            categoryId: categoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required String title,
            required String slug,
            Value<String?> summary = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<bool> featured = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PublicationsCompanion.insert(
            id: id,
            remoteId: remoteId,
            title: title,
            slug: slug,
            summary: summary,
            content: content,
            image: image,
            publishedAt: publishedAt,
            featured: featured,
            categoryId: categoryId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$PublicationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PublicationsTable> {
  $$PublicationsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get summary => $state.composableBuilder(
      column: $state.table.summary,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get featured => $state.composableBuilder(
      column: $state.table.featured,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PublicationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PublicationsTable> {
  $$PublicationsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get summary => $state.composableBuilder(
      column: $state.table.summary,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get featured => $state.composableBuilder(
      column: $state.table.featured,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ConcoursTableCreateCompanionBuilder = ConcoursCompanion Function({
  Value<int> id,
  Value<String?> remoteId,
  required String titre,
  required String slug,
  Value<String?> description,
  Value<String?> image,
  Value<String> statut,
  Value<String?> startingAt,
  Value<String?> endingAt,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$ConcoursTableUpdateCompanionBuilder = ConcoursCompanion Function({
  Value<int> id,
  Value<String?> remoteId,
  Value<String> titre,
  Value<String> slug,
  Value<String?> description,
  Value<String?> image,
  Value<String> statut,
  Value<String?> startingAt,
  Value<String?> endingAt,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$ConcoursTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConcoursTable,
    Concour,
    $$ConcoursTableFilterComposer,
    $$ConcoursTableOrderingComposer,
    $$ConcoursTableCreateCompanionBuilder,
    $$ConcoursTableUpdateCompanionBuilder> {
  $$ConcoursTableTableManager(_$AppDatabase db, $ConcoursTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ConcoursTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ConcoursTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String> titre = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> startingAt = const Value.absent(),
            Value<String?> endingAt = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ConcoursCompanion(
            id: id,
            remoteId: remoteId,
            titre: titre,
            slug: slug,
            description: description,
            image: image,
            statut: statut,
            startingAt: startingAt,
            endingAt: endingAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            required String titre,
            required String slug,
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> startingAt = const Value.absent(),
            Value<String?> endingAt = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ConcoursCompanion.insert(
            id: id,
            remoteId: remoteId,
            titre: titre,
            slug: slug,
            description: description,
            image: image,
            statut: statut,
            startingAt: startingAt,
            endingAt: endingAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$ConcoursTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ConcoursTable> {
  $$ConcoursTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get titre => $state.composableBuilder(
      column: $state.table.titre,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get statut => $state.composableBuilder(
      column: $state.table.statut,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get startingAt => $state.composableBuilder(
      column: $state.table.startingAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get endingAt => $state.composableBuilder(
      column: $state.table.endingAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ConcoursTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ConcoursTable> {
  $$ConcoursTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get titre => $state.composableBuilder(
      column: $state.table.titre,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get statut => $state.composableBuilder(
      column: $state.table.statut,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get startingAt => $state.composableBuilder(
      column: $state.table.startingAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get endingAt => $state.composableBuilder(
      column: $state.table.endingAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FiliereTableCreateCompanionBuilder = FiliereCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  required String nom,
  required String slug,
  Value<String?> niveau,
  Value<String?> description,
  Value<String?> image,
  Value<int> parcoursCount,
});
typedef $$FiliereTableUpdateCompanionBuilder = FiliereCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<String> nom,
  Value<String> slug,
  Value<String?> niveau,
  Value<String?> description,
  Value<String?> image,
  Value<int> parcoursCount,
});

class $$FiliereTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FiliereTable,
    FiliereData,
    $$FiliereTableFilterComposer,
    $$FiliereTableOrderingComposer,
    $$FiliereTableCreateCompanionBuilder,
    $$FiliereTableUpdateCompanionBuilder> {
  $$FiliereTableTableManager(_$AppDatabase db, $FiliereTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FiliereTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FiliereTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> niveau = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int> parcoursCount = const Value.absent(),
          }) =>
              FiliereCompanion(
            id: id,
            remoteId: remoteId,
            nom: nom,
            slug: slug,
            niveau: niveau,
            description: description,
            image: image,
            parcoursCount: parcoursCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required String nom,
            required String slug,
            Value<String?> niveau = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int> parcoursCount = const Value.absent(),
          }) =>
              FiliereCompanion.insert(
            id: id,
            remoteId: remoteId,
            nom: nom,
            slug: slug,
            niveau: niveau,
            description: description,
            image: image,
            parcoursCount: parcoursCount,
          ),
        ));
}

class $$FiliereTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FiliereTable> {
  $$FiliereTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nom => $state.composableBuilder(
      column: $state.table.nom,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get niveau => $state.composableBuilder(
      column: $state.table.niveau,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get parcoursCount => $state.composableBuilder(
      column: $state.table.parcoursCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter parcoursRefs(
      ComposableFilter Function($$ParcoursTableFilterComposer f) f) {
    final $$ParcoursTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.parcours,
        getReferencedColumn: (t) => t.filiereId,
        builder: (joinBuilder, parentComposers) =>
            $$ParcoursTableFilterComposer(ComposerState(
                $state.db, $state.db.parcours, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$FiliereTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FiliereTable> {
  $$FiliereTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nom => $state.composableBuilder(
      column: $state.table.nom,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get slug => $state.composableBuilder(
      column: $state.table.slug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get niveau => $state.composableBuilder(
      column: $state.table.niveau,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get parcoursCount => $state.composableBuilder(
      column: $state.table.parcoursCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ParcoursTableCreateCompanionBuilder = ParcoursCompanion Function({
  Value<int> id,
  required int filiereId,
  Value<int?> remoteId,
  required String nom,
  Value<String?> description,
  Value<String?> image,
});
typedef $$ParcoursTableUpdateCompanionBuilder = ParcoursCompanion Function({
  Value<int> id,
  Value<int> filiereId,
  Value<int?> remoteId,
  Value<String> nom,
  Value<String?> description,
  Value<String?> image,
});

class $$ParcoursTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ParcoursTable,
    Parcour,
    $$ParcoursTableFilterComposer,
    $$ParcoursTableOrderingComposer,
    $$ParcoursTableCreateCompanionBuilder,
    $$ParcoursTableUpdateCompanionBuilder> {
  $$ParcoursTableTableManager(_$AppDatabase db, $ParcoursTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ParcoursTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ParcoursTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> filiereId = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
          }) =>
              ParcoursCompanion(
            id: id,
            filiereId: filiereId,
            remoteId: remoteId,
            nom: nom,
            description: description,
            image: image,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int filiereId,
            Value<int?> remoteId = const Value.absent(),
            required String nom,
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
          }) =>
              ParcoursCompanion.insert(
            id: id,
            filiereId: filiereId,
            remoteId: remoteId,
            nom: nom,
            description: description,
            image: image,
          ),
        ));
}

class $$ParcoursTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ParcoursTable> {
  $$ParcoursTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nom => $state.composableBuilder(
      column: $state.table.nom,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$FiliereTableFilterComposer get filiereId {
    final $$FiliereTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.filiereId,
        referencedTable: $state.db.filiere,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$FiliereTableFilterComposer(
            ComposerState(
                $state.db, $state.db.filiere, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ParcoursTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ParcoursTable> {
  $$ParcoursTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nom => $state.composableBuilder(
      column: $state.table.nom,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$FiliereTableOrderingComposer get filiereId {
    final $$FiliereTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.filiereId,
        referencedTable: $state.db.filiere,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$FiliereTableOrderingComposer(ComposerState(
                $state.db, $state.db.filiere, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$AppNotificationsTableCreateCompanionBuilder
    = AppNotificationsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  required String title,
  Value<String?> message,
  Value<String?> icon,
  Value<bool> isRead,
  Value<DateTime?> createdAt,
});
typedef $$AppNotificationsTableUpdateCompanionBuilder
    = AppNotificationsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<String> title,
  Value<String?> message,
  Value<String?> icon,
  Value<bool> isRead,
  Value<DateTime?> createdAt,
});

class $$AppNotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppNotificationsTable,
    AppNotification,
    $$AppNotificationsTableFilterComposer,
    $$AppNotificationsTableOrderingComposer,
    $$AppNotificationsTableCreateCompanionBuilder,
    $$AppNotificationsTableUpdateCompanionBuilder> {
  $$AppNotificationsTableTableManager(
      _$AppDatabase db, $AppNotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppNotificationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppNotificationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> message = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              AppNotificationsCompanion(
            id: id,
            remoteId: remoteId,
            title: title,
            message: message,
            icon: icon,
            isRead: isRead,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required String title,
            Value<String?> message = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              AppNotificationsCompanion.insert(
            id: id,
            remoteId: remoteId,
            title: title,
            message: message,
            icon: icon,
            isRead: isRead,
            createdAt: createdAt,
          ),
        ));
}

class $$AppNotificationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isRead => $state.composableBuilder(
      column: $state.table.isRead,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppNotificationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isRead => $state.composableBuilder(
      column: $state.table.isRead,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AdmissionDraftsTableCreateCompanionBuilder = AdmissionDraftsCompanion
    Function({
  Value<int> id,
  required String localUuid,
  Value<int?> remoteId,
  required String dataJson,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$AdmissionDraftsTableUpdateCompanionBuilder = AdmissionDraftsCompanion
    Function({
  Value<int> id,
  Value<String> localUuid,
  Value<int?> remoteId,
  Value<String> dataJson,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$AdmissionDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdmissionDraftsTable,
    AdmissionDraft,
    $$AdmissionDraftsTableFilterComposer,
    $$AdmissionDraftsTableOrderingComposer,
    $$AdmissionDraftsTableCreateCompanionBuilder,
    $$AdmissionDraftsTableUpdateCompanionBuilder> {
  $$AdmissionDraftsTableTableManager(
      _$AppDatabase db, $AdmissionDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AdmissionDraftsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AdmissionDraftsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> localUuid = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionDraftsCompanion(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            dataJson: dataJson,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String localUuid,
            Value<int?> remoteId = const Value.absent(),
            required String dataJson,
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionDraftsCompanion.insert(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            dataJson: dataJson,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$AdmissionDraftsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AdmissionDraftsTable> {
  $$AdmissionDraftsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter documentsRefs(
      ComposableFilter Function($$DocumentsTableFilterComposer f) f) {
    final $$DocumentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.documents,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder, parentComposers) =>
            $$DocumentsTableFilterComposer(ComposerState(
                $state.db, $state.db.documents, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$AdmissionDraftsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AdmissionDraftsTable> {
  $$AdmissionDraftsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  required String localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String> uploadStatus,
  Value<int> retryCount,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  Value<String> localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String> uploadStatus,
  Value<int> retryCount,
});

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DocumentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DocumentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            required String localPath,
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
        ));
}

class $$DocumentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$AdmissionDraftsTableFilterComposer get draftId {
    final $$AdmissionDraftsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.admissionDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$AdmissionDraftsTableFilterComposer(ComposerState($state.db,
                    $state.db.admissionDrafts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$DocumentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$AdmissionDraftsTableOrderingComposer get draftId {
    final $$AdmissionDraftsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.admissionDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$AdmissionDraftsTableOrderingComposer(ComposerState($state.db,
                    $state.db.admissionDrafts, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$RegistrationDraftsTableCreateCompanionBuilder
    = RegistrationDraftsCompanion Function({
  Value<int> id,
  required String localUuid,
  Value<int?> remoteId,
  required String dataJson,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$RegistrationDraftsTableUpdateCompanionBuilder
    = RegistrationDraftsCompanion Function({
  Value<int> id,
  Value<String> localUuid,
  Value<int?> remoteId,
  Value<String> dataJson,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$RegistrationDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RegistrationDraftsTable,
    RegistrationDraft,
    $$RegistrationDraftsTableFilterComposer,
    $$RegistrationDraftsTableOrderingComposer,
    $$RegistrationDraftsTableCreateCompanionBuilder,
    $$RegistrationDraftsTableUpdateCompanionBuilder> {
  $$RegistrationDraftsTableTableManager(
      _$AppDatabase db, $RegistrationDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RegistrationDraftsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$RegistrationDraftsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> localUuid = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              RegistrationDraftsCompanion(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            dataJson: dataJson,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String localUuid,
            Value<int?> remoteId = const Value.absent(),
            required String dataJson,
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              RegistrationDraftsCompanion.insert(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            dataJson: dataJson,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$RegistrationDraftsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RegistrationDraftsTable> {
  $$RegistrationDraftsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter registrationDocumentsRefs(
      ComposableFilter Function($$RegistrationDocumentsTableFilterComposer f)
          f) {
    final $$RegistrationDocumentsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.registrationDocuments,
            getReferencedColumn: (t) => t.draftId,
            builder: (joinBuilder, parentComposers) =>
                $$RegistrationDocumentsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.registrationDocuments,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$RegistrationDraftsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RegistrationDraftsTable> {
  $$RegistrationDraftsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RegistrationDocumentsTableCreateCompanionBuilder
    = RegistrationDocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  required String localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String> uploadStatus,
  Value<int> retryCount,
});
typedef $$RegistrationDocumentsTableUpdateCompanionBuilder
    = RegistrationDocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  Value<String> localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String> uploadStatus,
  Value<int> retryCount,
});

class $$RegistrationDocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RegistrationDocumentsTable,
    RegistrationDocument,
    $$RegistrationDocumentsTableFilterComposer,
    $$RegistrationDocumentsTableOrderingComposer,
    $$RegistrationDocumentsTableCreateCompanionBuilder,
    $$RegistrationDocumentsTableUpdateCompanionBuilder> {
  $$RegistrationDocumentsTableTableManager(
      _$AppDatabase db, $RegistrationDocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$RegistrationDocumentsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$RegistrationDocumentsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              RegistrationDocumentsCompanion(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            required String localPath,
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              RegistrationDocumentsCompanion.insert(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
        ));
}

class $$RegistrationDocumentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RegistrationDocumentsTable> {
  $$RegistrationDocumentsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$RegistrationDraftsTableFilterComposer get draftId {
    final $$RegistrationDraftsTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.registrationDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$RegistrationDraftsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.registrationDrafts,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$RegistrationDocumentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RegistrationDocumentsTable> {
  $$RegistrationDocumentsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$RegistrationDraftsTableOrderingComposer get draftId {
    final $$RegistrationDraftsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.registrationDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$RegistrationDraftsTableOrderingComposer(ComposerState(
                    $state.db,
                    $state.db.registrationDrafts,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

typedef $$PostulationDraftsTableCreateCompanionBuilder
    = PostulationDraftsCompanion Function({
  Value<int> id,
  required String localUuid,
  Value<String?> remoteId,
  Value<String?> reference,
  required String concoursSlug,
  required String dataJson,
  Value<String?> postulationToken,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$PostulationDraftsTableUpdateCompanionBuilder
    = PostulationDraftsCompanion Function({
  Value<int> id,
  Value<String> localUuid,
  Value<String?> remoteId,
  Value<String?> reference,
  Value<String> concoursSlug,
  Value<String> dataJson,
  Value<String?> postulationToken,
  Value<String> status,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$PostulationDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PostulationDraftsTable,
    PostulationDraft,
    $$PostulationDraftsTableFilterComposer,
    $$PostulationDraftsTableOrderingComposer,
    $$PostulationDraftsTableCreateCompanionBuilder,
    $$PostulationDraftsTableUpdateCompanionBuilder> {
  $$PostulationDraftsTableTableManager(
      _$AppDatabase db, $PostulationDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PostulationDraftsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$PostulationDraftsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> localUuid = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String> concoursSlug = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<String?> postulationToken = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PostulationDraftsCompanion(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            reference: reference,
            concoursSlug: concoursSlug,
            dataJson: dataJson,
            postulationToken: postulationToken,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String localUuid,
            Value<String?> remoteId = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            required String concoursSlug,
            required String dataJson,
            Value<String?> postulationToken = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PostulationDraftsCompanion.insert(
            id: id,
            localUuid: localUuid,
            remoteId: remoteId,
            reference: reference,
            concoursSlug: concoursSlug,
            dataJson: dataJson,
            postulationToken: postulationToken,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
        ));
}

class $$PostulationDraftsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PostulationDraftsTable> {
  $$PostulationDraftsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reference => $state.composableBuilder(
      column: $state.table.reference,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get concoursSlug => $state.composableBuilder(
      column: $state.table.concoursSlug,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get postulationToken => $state.composableBuilder(
      column: $state.table.postulationToken,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter postulationDocumentsRefs(
      ComposableFilter Function($$PostulationDocumentsTableFilterComposer f)
          f) {
    final $$PostulationDocumentsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.postulationDocuments,
            getReferencedColumn: (t) => t.draftId,
            builder: (joinBuilder, parentComposers) =>
                $$PostulationDocumentsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.postulationDocuments,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$PostulationDraftsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PostulationDraftsTable> {
  $$PostulationDraftsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localUuid => $state.composableBuilder(
      column: $state.table.localUuid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reference => $state.composableBuilder(
      column: $state.table.reference,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get concoursSlug => $state.composableBuilder(
      column: $state.table.concoursSlug,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get postulationToken => $state.composableBuilder(
      column: $state.table.postulationToken,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PostulationDocumentsTableCreateCompanionBuilder
    = PostulationDocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  required String localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String?> documentType,
  Value<String> uploadStatus,
  Value<int> retryCount,
});
typedef $$PostulationDocumentsTableUpdateCompanionBuilder
    = PostulationDocumentsCompanion Function({
  Value<int> id,
  Value<int?> draftId,
  Value<String> localPath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<int?> size,
  Value<String?> documentType,
  Value<String> uploadStatus,
  Value<int> retryCount,
});

class $$PostulationDocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PostulationDocumentsTable,
    PostulationDocument,
    $$PostulationDocumentsTableFilterComposer,
    $$PostulationDocumentsTableOrderingComposer,
    $$PostulationDocumentsTableCreateCompanionBuilder,
    $$PostulationDocumentsTableUpdateCompanionBuilder> {
  $$PostulationDocumentsTableTableManager(
      _$AppDatabase db, $PostulationDocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$PostulationDocumentsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$PostulationDocumentsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String?> documentType = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              PostulationDocumentsCompanion(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            documentType: documentType,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> draftId = const Value.absent(),
            required String localPath,
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<String?> documentType = const Value.absent(),
            Value<String> uploadStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
          }) =>
              PostulationDocumentsCompanion.insert(
            id: id,
            draftId: draftId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            size: size,
            documentType: documentType,
            uploadStatus: uploadStatus,
            retryCount: retryCount,
          ),
        ));
}

class $$PostulationDocumentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PostulationDocumentsTable> {
  $$PostulationDocumentsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get documentType => $state.composableBuilder(
      column: $state.table.documentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PostulationDraftsTableFilterComposer get draftId {
    final $$PostulationDraftsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.postulationDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PostulationDraftsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.postulationDrafts,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$PostulationDocumentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PostulationDocumentsTable> {
  $$PostulationDocumentsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localPath => $state.composableBuilder(
      column: $state.table.localPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get documentType => $state.composableBuilder(
      column: $state.table.documentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uploadStatus => $state.composableBuilder(
      column: $state.table.uploadStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PostulationDraftsTableOrderingComposer get draftId {
    final $$PostulationDraftsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.draftId,
            referencedTable: $state.db.postulationDrafts,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PostulationDraftsTableOrderingComposer(ComposerState(
                    $state.db,
                    $state.db.postulationDrafts,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

typedef $$SyncOperationsTableCreateCompanionBuilder = SyncOperationsCompanion
    Function({
  Value<int> id,
  required String clientOperationId,
  required String type,
  required String payload,
  Value<String> status,
  Value<int> retryCount,
  Value<DateTime?> createdAt,
});
typedef $$SyncOperationsTableUpdateCompanionBuilder = SyncOperationsCompanion
    Function({
  Value<int> id,
  Value<String> clientOperationId,
  Value<String> type,
  Value<String> payload,
  Value<String> status,
  Value<int> retryCount,
  Value<DateTime?> createdAt,
});

class $$SyncOperationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOperationsTable,
    SyncOperation,
    $$SyncOperationsTableFilterComposer,
    $$SyncOperationsTableOrderingComposer,
    $$SyncOperationsTableCreateCompanionBuilder,
    $$SyncOperationsTableUpdateCompanionBuilder> {
  $$SyncOperationsTableTableManager(
      _$AppDatabase db, $SyncOperationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SyncOperationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SyncOperationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> clientOperationId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              SyncOperationsCompanion(
            id: id,
            clientOperationId: clientOperationId,
            type: type,
            payload: payload,
            status: status,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String clientOperationId,
            required String type,
            required String payload,
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              SyncOperationsCompanion.insert(
            id: id,
            clientOperationId: clientOperationId,
            type: type,
            payload: payload,
            status: status,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
        ));
}

class $$SyncOperationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get clientOperationId => $state.composableBuilder(
      column: $state.table.clientOperationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get payload => $state.composableBuilder(
      column: $state.table.payload,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SyncOperationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get clientOperationId => $state.composableBuilder(
      column: $state.table.clientOperationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payload => $state.composableBuilder(
      column: $state.table.payload,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get retryCount => $state.composableBuilder(
      column: $state.table.retryCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AdmissionFormsTableCreateCompanionBuilder = AdmissionFormsCompanion
    Function({
  Value<int> id,
  required String dataJson,
  Value<DateTime?> updatedAt,
});
typedef $$AdmissionFormsTableUpdateCompanionBuilder = AdmissionFormsCompanion
    Function({
  Value<int> id,
  Value<String> dataJson,
  Value<DateTime?> updatedAt,
});

class $$AdmissionFormsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdmissionFormsTable,
    AdmissionForm,
    $$AdmissionFormsTableFilterComposer,
    $$AdmissionFormsTableOrderingComposer,
    $$AdmissionFormsTableCreateCompanionBuilder,
    $$AdmissionFormsTableUpdateCompanionBuilder> {
  $$AdmissionFormsTableTableManager(
      _$AppDatabase db, $AdmissionFormsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AdmissionFormsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AdmissionFormsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionFormsCompanion(
            id: id,
            dataJson: dataJson,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String dataJson,
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionFormsCompanion.insert(
            id: id,
            dataJson: dataJson,
            updatedAt: updatedAt,
          ),
        ));
}

class $$AdmissionFormsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AdmissionFormsTable> {
  $$AdmissionFormsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AdmissionFormsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AdmissionFormsTable> {
  $$AdmissionFormsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AdmissionCampaignsTableCreateCompanionBuilder
    = AdmissionCampaignsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  required String dataJson,
  Value<DateTime?> updatedAt,
});
typedef $$AdmissionCampaignsTableUpdateCompanionBuilder
    = AdmissionCampaignsCompanion Function({
  Value<int> id,
  Value<int?> remoteId,
  Value<String> dataJson,
  Value<DateTime?> updatedAt,
});

class $$AdmissionCampaignsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdmissionCampaignsTable,
    AdmissionCampaign,
    $$AdmissionCampaignsTableFilterComposer,
    $$AdmissionCampaignsTableOrderingComposer,
    $$AdmissionCampaignsTableCreateCompanionBuilder,
    $$AdmissionCampaignsTableUpdateCompanionBuilder> {
  $$AdmissionCampaignsTableTableManager(
      _$AppDatabase db, $AdmissionCampaignsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AdmissionCampaignsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$AdmissionCampaignsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionCampaignsCompanion(
            id: id,
            remoteId: remoteId,
            dataJson: dataJson,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
            required String dataJson,
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AdmissionCampaignsCompanion.insert(
            id: id,
            remoteId: remoteId,
            dataJson: dataJson,
            updatedAt: updatedAt,
          ),
        ));
}

class $$AdmissionCampaignsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AdmissionCampaignsTable> {
  $$AdmissionCampaignsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AdmissionCampaignsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AdmissionCampaignsTable> {
  $$AdmissionCampaignsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get remoteId => $state.composableBuilder(
      column: $state.table.remoteId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dataJson => $state.composableBuilder(
      column: $state.table.dataJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NewsTableTableManager get news => $$NewsTableTableManager(_db, _db.news);
  $$PublicationsTableTableManager get publications =>
      $$PublicationsTableTableManager(_db, _db.publications);
  $$ConcoursTableTableManager get concours =>
      $$ConcoursTableTableManager(_db, _db.concours);
  $$FiliereTableTableManager get filiere =>
      $$FiliereTableTableManager(_db, _db.filiere);
  $$ParcoursTableTableManager get parcours =>
      $$ParcoursTableTableManager(_db, _db.parcours);
  $$AppNotificationsTableTableManager get appNotifications =>
      $$AppNotificationsTableTableManager(_db, _db.appNotifications);
  $$AdmissionDraftsTableTableManager get admissionDrafts =>
      $$AdmissionDraftsTableTableManager(_db, _db.admissionDrafts);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$RegistrationDraftsTableTableManager get registrationDrafts =>
      $$RegistrationDraftsTableTableManager(_db, _db.registrationDrafts);
  $$RegistrationDocumentsTableTableManager get registrationDocuments =>
      $$RegistrationDocumentsTableTableManager(_db, _db.registrationDocuments);
  $$PostulationDraftsTableTableManager get postulationDrafts =>
      $$PostulationDraftsTableTableManager(_db, _db.postulationDrafts);
  $$PostulationDocumentsTableTableManager get postulationDocuments =>
      $$PostulationDocumentsTableTableManager(_db, _db.postulationDocuments);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
  $$AdmissionFormsTableTableManager get admissionForms =>
      $$AdmissionFormsTableTableManager(_db, _db.admissionForms);
  $$AdmissionCampaignsTableTableManager get admissionCampaigns =>
      $$AdmissionCampaignsTableTableManager(_db, _db.admissionCampaigns);
}
