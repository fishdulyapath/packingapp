import 'dart:convert';

class SerialNumber {
  final String serialNumber;

  SerialNumber({
    required this.serialNumber,
  });

  factory SerialNumber.empty() {
    return SerialNumber(serialNumber: "");
  }

  Map<String, dynamic> toMap() {
    return {
      'serialNumber': serialNumber,
    };
  }

  factory SerialNumber.fromMap(Map<String, dynamic> map) {
    return SerialNumber(
      serialNumber: map['serialNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SerialNumber.fromJson(String source) =>
      SerialNumber.fromMap(json.decode(source));
}
