Widget _otpBox(int index) {
  return SizedBox(
    width: 45,
    height: 55,
    child: TextField(
      controller: controllers[index],
      keyboardType: TextInputType.number,

      textAlign: TextAlign.center,

      maxLength: 1,

      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),

      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.zero,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD9DEE7),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF1682F8),
            width: 2,
          ),
        ),
      ),

      onChanged: (value) {
        if (value.length == 1 && index < 5) {
          FocusScope.of(context).nextFocus();
        }

        if (value.isEmpty && index > 0) {
          FocusScope.of(context).previousFocus();
        }
      },
    ),
  );
}