import 'package:flutter/material.dart';

class ConditionsHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const ConditionsHeader({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: statusBar + 12,
        left: 18,
        right: 18,
        bottom: 18,
      ),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: onBack ??
                    () {
                  Navigator.pop(context);
                },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Text(
              "Condition d'admission",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xff0B4EA2),
              ),
            ),
          ),

          const SizedBox(width: 18),

          Image.asset(
            "assets/logos/eamau_logo.gif",
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}