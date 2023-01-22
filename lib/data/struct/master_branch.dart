
class Branch {
  const Branch({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  factory Branch.empty() {
    return const Branch(code: "", name: "");
  }

  @override
  String toString() {
    return '$code';
  }

  String toShowLabel() {
    if (code != '') {
      return '$code~$name';
    } else {
      return '';
    }
  }

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(code: json["id"], name: json["name"]);
  }

  static List<Branch> fromJsonList(List list) {
    return list.map((item) => Branch.fromJson(item)).toList();
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      code: map['code'],
      name: map['name_1'],
    );
  }
}
