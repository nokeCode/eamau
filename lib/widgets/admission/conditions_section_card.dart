import 'package:flutter/material.dart';

class ConditionsSectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  const ConditionsSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.children = const [],
    this.initiallyExpanded = false,
  });

  @override
  State<ConditionsSectionCard> createState() =>
      _ConditionsSectionCardState();
}

class _ConditionsSectionCardState
    extends State<ConditionsSectionCard> {
  late bool expanded;

  bool get _subtitleIsLong {
    final words = widget.subtitle.trim().split(RegExp(r'\s+'));
    return words.length > 10;
  }

  String get _subtitlePreview {
    final words = widget.subtitle.trim().split(RegExp(r'\s+'));
    if (words.length <= 10) return widget.subtitle;
    return '${words.take(10).join(' ')}...';
  }

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffDCE5F2),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color(0xffEAF2FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: const Color(0xff0B7BD7),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0B4EA2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _subtitleIsLong && !expanded
                              ? _subtitlePreview
                              : widget.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                18,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  if (_subtitleIsLong) ...[
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ...widget.children,
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(
              milliseconds: 250,
            ),
          ),
        ],
      ),
    );
  }
}
