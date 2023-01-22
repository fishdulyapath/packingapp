
class WarehouseLocation {
  const WarehouseLocation({
    required this.whcode,
    required this.whname,
    required this.locationcode,
    required this.locationname,
  });

  final String whcode;
  final String whname;
  final String locationcode;
  final String locationname;

  factory WarehouseLocation.empty() {
    return const WarehouseLocation(
        whcode: "", whname: "", locationcode: "", locationname: "");
  }

  String toString() {
    return '$whcode';
  }

  String getWhcode() {
    return this.whcode;
  }

  String getLocationcode() {
    return '$locationcode';
  }

  String toShowLabel() {
    if (whname != '') {
      return '$whname($whcode)/$locationname($locationcode)';
    } else {
      return '';
    }
  }

  factory WarehouseLocation.fromJson(Map<String, dynamic> json) {
    return WarehouseLocation(
        whcode: json["whcode"],
        whname: json["whname"],
        locationcode: json["location_code"],
        locationname: json["location_name"]);
  }

  static List<WarehouseLocation> fromJsonList(List list) {
    return list.map((item) => WarehouseLocation.fromJson(item)).toList();
  }

  factory WarehouseLocation.fromMap(Map<String, dynamic> map) {
    return WarehouseLocation(
      whcode: map['wh_code'],
      whname: map['wh_name'],
      locationcode: map['shelf_code'],
      locationname: map['shelf_name'],
    );
  }
}
