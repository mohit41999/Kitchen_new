import 'dart:convert';

GetTrackDeliveries getTrackDeliveriesFromJson(String str) =>
    GetTrackDeliveries.fromJson(json.decode(str));

String getTrackDeliveriesToJson(GetTrackDeliveries data) =>
    json.encode(data.toJson());

class GetTrackDeliveries {
  GetTrackDeliveries({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<GetTrackDeliveriesData> data;

  factory GetTrackDeliveries.fromJson(Map<String, dynamic> json) =>
      GetTrackDeliveries(
        status: json["status"],
        message: json["message"],
        data: List<GetTrackDeliveriesData>.from(
            json["data"].map((x) => GetTrackDeliveriesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetTrackDeliveriesData {
  GetTrackDeliveriesData({
    this.orderNumber,
    this.time,
    this.orderBy,
    this.deliveryAddress,
    this.totalBill,
  });

  String orderNumber;
  String time;
  String orderBy;
  String deliveryAddress;
  String totalBill;

  factory GetTrackDeliveriesData.fromJson(Map<String, dynamic> json) =>
      GetTrackDeliveriesData(
        orderNumber: json["order_number"],
        time: json["time"],
        orderBy: json["order_by"],
        deliveryAddress: json["delivery_address"],
        totalBill: json["total_bill"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "time": time,
        "order_by": orderBy,
        "delivery_address": deliveryAddress,
        "total_bill": totalBill,
      };
}
