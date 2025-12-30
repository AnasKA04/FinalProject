class Validators {
  Validators._();

  static String? email(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Email is required";

    // Simple and reliable email regex (not over-strict)
    final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    if (!emailRegex.hasMatch(value)) return "Enter a valid email address";

    return null;
  }

  static String? password(String? v) {
    final value = (v ?? "");
    if (value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";

    final hasLetter = RegExp(r"[A-Za-z]").hasMatch(value);
    final hasNumber = RegExp(r"\d").hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]~`+=;]').hasMatch(value);

    if (!hasLetter) return "Password must include at least 1 letter";
    if (!hasNumber) return "Password must include at least 1 number";
    if (!hasSpecial) return "Password must include at least 1 special character";

    return null;
  }

  static String? name(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Full name is required";
    if (value.length < 2) return "Name is too short";
    return null;
  }
}
