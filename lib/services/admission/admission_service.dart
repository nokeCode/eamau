import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/admission/admission_model.dart';


class AdmissionService {
  static const String apiUrl =
      'https://votre-api.com/api/admission';

  Future<List<AdmissionModel>> getAdmissions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        return data
            .map((e) => AdmissionModel.fromJson(e))
            .toList();
      }
    } catch (_) {}

    return fallbackAdmissions;
  }
}

const List<AdmissionModel> fallbackAdmissions = [
  AdmissionModel(
    id: 1,
    title: "Admission en\npremière année",
    description:
    "Cette voie s'adresse aux bacheliers souhaitant intégrer l'EAMAU en première année de formation.",
    eligibility:
    "Être titulaire d'un baccalauréat ou d'un diplôme équivalent reconnu.",
    image: "assets/images/admission1.png",
    isOpen: true,
  ),
  AdmissionModel(
    id: 2,
    title: "Admission par passerelle\n(à partir de L2,...)",
    description:
    "Cette voie permet aux étudiants d'intégrer l'EAMAU à un niveau avancé selon leur parcours académique.",
    eligibility:
    "Être titulaire d'un diplôme universitaire (DEUG, Licence, etc.) ou équivalent.",
    image: "assets/images/admission2.png",
    isOpen: true,
  ),
];