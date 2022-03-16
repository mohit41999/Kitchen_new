import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kitchen/model/AddOffer.dart';
import 'package:kitchen/model/GetOfferDetail.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constents.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/progress_dialog.dart';

class AddOfferScreen extends StatefulWidget {
  var offerId;
  AddOfferScreen({this.offerId});
  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  bool isChecked = false;
  var isSelect = -1;
  var isRequire = -1;
  var startDate = "";
  var endDate = "";

  var oferTitle = TextEditingController();
  var discountcode = TextEditingController();
  var discountType = TextEditingController();
  var discountValue = TextEditingController();
  var startTime = TextEditingController();
  var endTime = TextEditingController();
  var limit = TextEditingController();
  String dropdownValue;
  var offercode;
  TimeOfDay selectedTime = TimeOfDay.now();
  ProgressDialog progressDialog;
  List<String> location = ['Percentage', 'Value'];

  @override
  void initState() {
    print(widget.offerId + "add inittttttttttttttttttttttttttttttttt");
    getOfferDetail(context, widget.offerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Image.asset(
                          Res.ic_right_arrow,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 16, top: 16),
                      child: Text(
                        "Add an Offer",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ],
                ),
                height: 70,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Discount/Offer Title",
                  style: TextStyle(
                      color: AppConstant.appColor,
                      fontSize: 16,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                  child: TextField(
                    controller: oferTitle,
                    decoration: InputDecoration(hintText: 'Add Title'),
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  controller: discountcode,
                  decoration: InputDecoration(hintText: "Discount Code"),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Discount Type",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Discount Value",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: Text('Select'),
                        value: dropdownValue,
                        iconSize: 24,
                        elevation: 10,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            print(dropdownValue);
                          });
                        },
                        items: location
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // Expanded(
                    //     child: Container(
                    //         margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                    //         child: TextField(
                    //             controller: discountType,
                    //             keyboardType: TextInputType.number,
                    //             decoration: InputDecoration(hintText: "Percentage"),
                    //         ),
                    //     ),
                    // ),
                    // Container(
                    //     margin: EdgeInsets.only(top: 16, right: 16),
                    //     child: Image.asset(
                    //       Res.ic_down_arrow,
                    //       width: 15,
                    //       height: 15,
                    //     )),
                    SizedBox(width: 50),
                    Expanded(
                      child: Container(
                        height: 32,
                        //margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                        child: TextField(
                          controller: discountValue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "10"),
                        ),
                      ),
                    ),
                    (dropdownValue == 'Percentage')
                        ? Container(
                            margin: EdgeInsets.only(top: 16, right: 16),
                            child: Image.asset(
                              Res.ic_percent,
                              width: 15,
                              height: 15,
                            ))
                        : Container(
                            margin: EdgeInsets.only(top: 16, right: 16),
                            child: Text('₹')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Applies To",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontRegular,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelect = 1;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            color: isSelect == 1
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Breakfast",
                            style: TextStyle(
                                color:
                                    isSelect == 1 ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelect = 2;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            color: isSelect == 2
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Lunch",
                            style: TextStyle(
                                color:
                                    isSelect == 2 ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelect = 3;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            color: isSelect == 3
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Dinner",
                            style: TextStyle(
                                color:
                                    isSelect == 3 ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSelect = 0;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: isSelect == 0
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "All",
                            style: TextStyle(
                                color:
                                    isSelect == 0 ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Minimum Requirement",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontRegular,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isRequire = 0;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            color: isRequire == 0
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "None",
                            style: TextStyle(
                                color: isRequire == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isRequire = 1;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            color: isRequire == 1
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Min.Amount",
                            style: TextStyle(
                                color: isRequire == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isRequire = 2;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: isRequire == 2
                                ? Color(0xffFFA451)
                                : Color(0xffF3F6FA),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Min.Item",
                            style: TextStyle(
                                color: isRequire == 2
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "Start Date",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "End Date",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(startDate == "" ? "start Date" : startDate),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () async {
                      var result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(DateTime.now().year + 5));
                      print('$result');
                      setState(() {
                        startDate = result.year.toString() +
                            "/" +
                            result.month.toString() +
                            "/" +
                            result.day.toString();
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        child: Image.asset(
                          Res.ic_date,
                          width: 15,
                          height: 15,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(endDate == "" ? "end Date" : endDate),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () async {
                      var result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(DateTime.now().year + 5));
                      print('$result');
                      setState(() {
                        endDate = result.year.toString() +
                            "/" +
                            result.month.toString() +
                            "/" +
                            result.day.toString();
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        child: Image.asset(
                          Res.ic_date,
                          width: 15,
                          height: 15,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "Start Time",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "End Time",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                      child: TextField(
                        // readOnly: true,
                        controller: startTime,
                        //decoration: InputDecoration(hintText: "Start Time"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectTime(context, startTime);
                        startTime;
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        child: Image.asset(
                          Res.ic_time_circle,
                          width: 15,
                          height: 15,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                      child: TextField(
                        controller: endTime,
                        //decoration: InputDecoration(hintText: "End Time"),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Text("${selectedTime.hour}:${selectedTime.minute}"),
                  //       (selectedTime.period.index.toString() == '0')
                  //           ? Text(' AM')
                  //           : Text(' PM')
                  //     ],
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, endTime);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        child: Image.asset(
                          Res.ic_time_circle,
                          width: 15,
                          height: 15,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Minimum Requirement",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontRegular,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Color(0xff7EDABF),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                        print(isChecked);
                      });
                    },
                    value: isChecked == null ? false : isChecked,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 4),
                    child: Text(
                      "Limit the number of times this\ndiscount code can be used",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppConstant.fontRegular,
                          fontSize: 16),
                    ),
                  ),
                  (isChecked)
                      ? Container(
                          width: 70,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: limit,
                            decoration: InputDecoration(hintText: "limit"),
                          ),
                        )
                      : Container()
                ],
              ),
              InkWell(
                onTap: () {
                  validaton();
                },
                child: Container(
                  height: 55,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 36),
                  decoration: BoxDecoration(
                      color: AppConstant.appColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "CREATE OFFER",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          physics: BouncingScrollPhysics(),
        ));
  }

  void validaton() {
    var title = oferTitle.text.toString();
    var code = discountcode.text.toString();
    var type = (dropdownValue.toString() == 'Percentage') ? '0' : '1';
    var value = discountValue.text.toString();
    var sTime = startTime.text.toString();
    var eTime = endTime.text.toString();
    var lim = limit.text.toString();

    if (title.isEmpty) {
      Utils.showToast("Enter Offer Title");
    } else if (code.isEmpty) {
      Utils.showToast("Enter discount code");
    } else if (type.isEmpty) {
      Utils.showToast("Select discount type");
    } else if (value.isEmpty) {
      Utils.showToast("Enter discount value");
    } else if (isSelect == -1) {
      Utils.showToast("Please select applies");
    } else if (isRequire == -1) {
      Utils.showToast("Please select minimum requirement");
    } else if (startDate.isEmpty) {
      Utils.showToast("Please enter start date");
    } else if (endDate.isEmpty) {
      Utils.showToast("Please enter end date");
    } else if (sTime.isEmpty) {
      Utils.showToast("Please enter startTime");
    } else if (eTime.isEmpty) {
      Utils.showToast("Please enter end time");
    }
    // else if (isChecked == false) {
    //   Utils.showToast("Check Limit");
    // }
    else if (isChecked && lim.isEmpty) {
      Utils.showToast("Please enter minimum limit");
    } else {
      addOffer(title, code, type, value, lim, sTime, eTime);
    }
  }

  Future<GetOfferDetail> getOfferDetail(
      BuildContext context, String offerId) async {
    // progressDialog.show();
    try {
      FormData from = FormData.fromMap(
          {"user_id": "2", 'offer_id': offerId, "token": "123456789"});
      GetOfferDetail bean = await ApiProvider().getOfferDetail(from);
      print(bean.data);
      progressDialog.dismiss();
      if (bean.status == true) {
        setState(() {
          oferTitle.text = bean.data.title;
          discountcode.text = bean.data.offercode;
          //discountType.text = bean.data.discounttype;
          discountValue.text = bean.data.discountValue;
          startTime.text = bean.data.starttime;
          endTime.text = bean.data.endtime;
          limit.text = bean.data.usagelimit;
          isRequire = int.parse(bean.data.minrequirement);
          isSelect = int.parse(bean.data.appliesto);
          dropdownValue =
              (int.parse(bean.data.discounttype) == 0) ? 'Percentage' : 'Value';
          isChecked = (int.parse(bean.data.usagelimit) == 0) ? false : true;
        });

        return bean;
      } else {
        Utils.showToast(bean.message);
      }

      return null;
    } on HttpException catch (exception) {
      // progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      // progressDialog.dismiss();
      print(exception);
    }
  }

  Future<AddOffer> addOffer(String title, String discountcode, String type,
      String value, String lim, String sTime, String eTime) async {
    progressDialog.show();

    var userBean = await Utils.getUser();

    var id = userBean.data.id;

    print(startDate);
    print(endDate);
    try {
      FormData data;
      data = FormData.fromMap({
        "user_id": id,
        "offer_title": title,
        "offer_code": discountcode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": isSelect == 1
            ? "1"
            : isSelect == 2
                ? "2"
                : isSelect == 3
                    ? "3"
                    : "0",
        "minimum_requirement": isRequire == 1
            ? "1"
            : isRequire == 2
                ? "2"
                : '0',
        "usage_limit": lim,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "token": "123456789",
      });
      AddOffer bean = await ApiProvider().addOffer(data);
      print(bean.data);
      progressDialog.dismiss();
      if (bean.status == true) {
        Navigator.pop(context, true);
        Utils.showToast("Add Offer Successfully");
      } else {
        Utils.showToast(bean.message);
      }
    } on HttpException catch (exception) {
      progressDialog.dismiss();
    } catch (exception) {
      progressDialog.dismiss();
    }
  }

  _selectTime(BuildContext context, TextEditingController time) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        var type = (timeOfDay.hour >= 12) ? 'PM' : 'AM';
        time.text = timeOfDay.hour.toString() +
            ":" +
            timeOfDay.minute.toString() +
            ' ${type}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You cannot Select present time'),
      ));
    }
  }
}
