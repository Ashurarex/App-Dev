String? emailValidator(String? v) {
  if (v == null || !v.contains('@')) return 'Enter valid email';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.length < 6) return '6+ chars';
  return null;
}
