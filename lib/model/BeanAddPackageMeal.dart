import 'dart:convert';

BeanAddPackageMeals beanApplyOrderFilterFromJson(String str) =>
    BeanAddPackageMeals.fromJson(json.decode(str));

String beanApplyOrderFilterToJson(BeanAddPackageMeals data) =>
    json.encode(data.toJson());

class BeanAddPackageMeals {
  BeanAddPackageMeals({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory BeanAddPackageMeals.fromJson(Map<String, dynamic> json) =>
      BeanAddPackageMeals(
        status: json["status"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
