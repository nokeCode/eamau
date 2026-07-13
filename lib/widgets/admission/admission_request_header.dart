import 'package:flutter/material.dart';

class AdmissionRequestHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const AdmissionRequestHeader({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;

    return Container(
      height: 110 + statusBar,
      padding: EdgeInsets.only(
        top: statusBar,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff0F5BD7),
            Color(0xff1D75EA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack ??
                    () {
                  Navigator.pop(context);
                },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 6),

          const Expanded(
            child: Text(
              "Admission",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Image.asset(
            "assets/logos/eamau_logo.gif",
            width: 52,
            height: 52,
          ),
        ],
      ),
    );
  }
}