import 'package:flutter/material.dart';

class AdmissionConditionTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool initiallyExpanded;
  final Widget? child;

  const AdmissionConditionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.initiallyExpanded = false,
    this.child,
  });

  @override
  State<AdmissionConditionTile> createState() =>
      _AdmissionConditionTileState();
}

class _AdmissionConditionTileState
    extends State<AdmissionConditionTile> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: 14,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE3EAF7),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xffEAF4FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: const Color(0xff1E73F2),
                    size: 22,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0B4EA2),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.4,
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

          if (expanded && widget.child != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            widget.child!,
          ]
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String text;

  const _DocumentItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            color: Color(0xff1E73F2),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}