import 'package:flutter/material.dart';

class CandidatureHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const CandidatureHeader({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        statusBar + 15,
        20,
        18,
      ),
      color: const Color(0xff1565C0),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(30),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Text(
              "Candidature au concours",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Image.asset(
            "assets/logos/eamau_logo.gif",
            width: 42,
            height: 42,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}