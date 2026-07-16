import 'package:flutter/material.dart';
import '../../models/admission/admission_tracking_model.dart';
import 'tracking_timeline_item.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingStepModel> steps;

  const TrackingTimeline({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: List.generate(

        steps.length,

            (index) {

          final step = steps[index];

          return TrackingTimelineItem(

            title: step.title,

            description: step.description,

            date: step.date,

            completed: step.completed,

            isLast: index == steps.length - 1,

          );

        },
      ),
    );
  }
}