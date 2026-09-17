double jsonToDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.parse(value.toString());
}

double? jsonToNullableDouble(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

bool jsonToBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is int) {
    return value == 1;
  }

  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }

  return false;
}
