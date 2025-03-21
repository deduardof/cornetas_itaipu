// ignore_for_file: public_member_api_docs, sort_constructors_first
class IpAddress {
  final int first;
  final int second;
  final int third;
  final int fourth;
  IpAddress({required this.first, required this.second, required this.third, required this.fourth});

  factory IpAddress.fromString(String value) {
    final values = value.split('.').map((n) => int.tryParse(n) ?? 0).toList();
    return IpAddress(first: values[0], second: values[1], third: values[2], fourth: values[3]);
  }

  static bool validate({required String value}) {
    final values = value.split('.').map((n) => int.tryParse(n) ?? 0).toList();
    if (values.length != 4 || values.first < 1 || values.first > 254) return false;
    for (var num in values) {
      if (num < 0 || num > 254) return false;
    }
    return true;
  }

  @override
  String toString() => '$first.$second.$third.$fourth';

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is IpAddress) {
      return first == other.first && second == other.second && third == other.third && fourth == other.fourth;
    }
    return false;
  }
}
