import 'package:flutter/material.dart';

import '../models/evaluation/teacher_evaluation_model.dart';
import '../services/evaluation/teacher_evaluation_service.dart';

import '../widgets/evaluation/evaluation_comment_field.dart';
import '../widgets/evaluation/evaluation_criterion_card.dart';
import '../widgets/evaluation/evaluation_info_box.dart';
import '../widgets/evaluation/submit_evaluation_button.dart';
import '../widgets/evaluation/teacher_info_card.dart';

class TeacherEvaluationScreen extends StatefulWidget {
  const TeacherEvaluationScreen({super.key});

  @override
  State<TeacherEvaluationScreen> createState() =>
      _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState
    extends State<TeacherEvaluationScreen> {
  final TeacherEvaluationService _service =
  TeacherEvaluationService();

  late Future<TeacherEvaluationModel> _future;

  final TextEditingController _commentController =
  TextEditingController();

  final Map<String, int> _ratings = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _future = _service.getEvaluation();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit(
      TeacherEvaluationModel evaluation) async {
    setState(() {
      _isSubmitting = true;
    });

    final success = await _service.submitEvaluation(
      courseId: evaluation.courseId,
      teacherId: evaluation.teacherId,
      ratings: _ratings,
      comment: _commentController.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Évaluation envoyée."
              : "Échec de l'envoi.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xff1976F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Evaluation des Enseignants",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder<TeacherEvaluationModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final evaluation = snapshot.data ??
              TeacherEvaluationModel.fallback();

          for (final criterion in evaluation.criteria) {
            _ratings.putIfAbsent(
              criterion.key,
                  () => 4,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                TeacherInfoCard(
                  courseName: evaluation.courseName,
                  teacherName: evaluation.teacherName,
                ),

                const SizedBox(height: 24),

                const Text(
                  "Veuillez évaluer les critères suivants",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1C2C5B),
                  ),
                ),

                const SizedBox(height: 18),

                ...evaluation.criteria.map(
                      (criterion) {
                    return EvaluationCriterionCard(
                      title: criterion.title,
                      rating:
                      _ratings[criterion.key] ?? 4,
                      onRatingChanged: (value) {
                        setState(() {
                          _ratings[criterion.key] =
                              value;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 8),

                EvaluationCommentField(
                  controller: _commentController,
                ),

                const SizedBox(height: 20),

                const EvaluationInfoBox(),

                const SizedBox(height: 24),

                SubmitEvaluationButton(
                  isLoading: _isSubmitting,
                  onPressed: () => _submit(
                    evaluation,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}