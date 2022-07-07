enum PassStrength {
  weak,
  normal,
  strong,
  veryStrong,
}

typedef PassStrengthGetter = PassStrength Function(String);

PassStrength passStrengthGetterImpl(String pass) {
  final hasLetters = pass.contains(RegExp("[a-zA-Z]"));
  if (pass.length < 8 || !hasLetters) {
    return PassStrength.weak;
  }
  final hasDigits = pass.contains(RegExp("[0-9]"));
  final hasSpecial = pass.contains(RegExp(r"[\!@#$%^&*()_+=]"));
  if (hasLetters && !hasDigits && !hasSpecial) {
    return PassStrength.normal;
  }
  if (hasDigits && !hasSpecial) {
    return PassStrength.strong;
  } else {
    return PassStrength.veryStrong;
  }
}
