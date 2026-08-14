import 'package:eamau/models/admission/admission_request_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the API file-name variants and keeps pending documents visible', () {
    final summary = AdmissionRequestSummaryModel.fromJson({
      'request_id': '42',
      'status': 'DRAFT',
      'documents': [
        {
          'id': 'document-1',
          'original_filename': 'acte-naissance.pdf',
          'attachment_type': 'BIRTH_CERTIFICATE',
          'is_validated': false,
        },
        {
          'id': 'document-2',
          'attachmentType': 'DIPLOMA',
          'validated': true,
        },
      ],
      'missing_documents': [],
      'is_complete': true,
    });

    expect(summary.requestId, 42);
    expect(summary.documents[0].originalFilename, 'acte-naissance.pdf');
    expect(summary.documents[0].validated, isFalse);
    expect(summary.documents[1].originalFilename, 'DIPLOMA');
    expect(summary.documents[1].validated, isTrue);
    expect(summary.missingDocuments, isEmpty);
    expect(summary.isComplete, isTrue);
  });
}
