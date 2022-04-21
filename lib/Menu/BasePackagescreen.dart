import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/Menu/AddMealScreen.dart';
import 'package:kitchen/Menu/PackageList.dart';
import 'package:kitchen/Menu/SuccessPackageScreen.dart';
import 'package:kitchen/model/BeanAddMenu.dart';
import 'package:kitchen/model/BeanAddPackage.dart';
import 'package:kitchen/model/BeanAddPackagePrice.dart';
import 'package:kitchen/model/BeanGetPackages.dart';
import 'package:kitchen/model/BeanLogin.dart';
import 'package:kitchen/model/BeanPackagePriceDetail.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constents.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/progress_dialog.dart';
import 'package:kitchen/model/BeanDeletePackage.dart';
import 'package:kitchen/model/BeanGetPackages.dart';

class BasePackagescreen extends StatefulWidget {
  @override
  _BasePackagescreenState createState() => _BasePackagescreenState();
}

class _BasePackagescreenState extends State<BasePackagescreen> {
  BeanLogin userBean;
  BeanAddMenu bean;
  PickedFile mediaFile;
  List<String> Files = [
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
  ];
  var createPackageid;
  BeanPackagePriceDetail beanprice;
  BeanGetPackages getPackagesbean;
  double variance;
  bool isReplaceDefault = true;
  bool isReplaceMenu = false;
  bool isReplaceAddPackages = false;
  bool isCreatePackages = false;
  var isMealType = -1;
  var isSelected = -1;
  var isSelectMenu = -1;
  var isSelectFood = -1;
  var isSelectedNorth = 1;
  var _other2 = false;
  var sunday = false;
  var addDefaultIcon = true;
  bool isSelectPlanTypeWeekly = false;
  bool isSelectPlanTypeMonthly = false;
  Future future;
  var packagename = TextEditingController();
  var packname = "";
  var date = "";
  var userId;
  var weekly = TextEditingController();
  var monthly = TextEditingController();
  ProgressDialog progressDialog;

  Future getUser() async {
    userBean = await Utils.getUser();
    userId = userBean.data.id.toString();
  }

  @override
  void initState() {
    getUser().then((value) {
      // getMenuPackageList();
      // getPackagePriceDetail(context);
      getMealScreenItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return Scaffold(
      body: getPaged(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (isReplaceDefault == true)
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 65),
              child: FloatingActionButton(
                backgroundColor: AppConstant.appColor,
                onPressed: () {
                  setState(() {
                    isReplaceDefault = false;
                    isReplaceAddPackages = true;

                    isReplaceMenu = false;

                    isCreatePackages = false;
                  });
                },
                child: Icon(Icons.add),
              ),
            )
          : Container(),
    );
  }

  getPaged() {
    if (isReplaceDefault == true) {
      // return addDafultIcon();
      return PackageList();
      // return addMenu();
    } else if (isReplaceAddPackages == true) {
      return addPackages();
    } else if (isReplaceMenu == true) {
      return addMenu();
    } else if (isCreatePackages == true) {
      return createPackage();
    }
  }

  addMenu() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 16),
            height: 60,
            child: Row(
              children: [
                Text(
                  bean.data.mealfor,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 16),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 20,
                ),
                SizedBox(
                  width: 16,
                ),
                Image.asset(
                  mealIcon(bean.data.mealtype),
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  bean.data.mealtype,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 16,
                ),
                VerticalDivider(color: Colors.grey, width: 20),
                Text(
                  bean.data.cuisinetype,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            color: Colors.grey.shade400,
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return getList(
                bean.data.weeklyDetail,
                index,
                bean.data.packageId,
                bean.data.cuisinetype,
                bean.data.mealtype,
              );
            },
            itemCount: bean.data.weeklyDetail.length,
          ),
          SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              for (int i = 0; i < Files.length; i++) {
                if (Files[i].toString() == 'null') {
                } else {
                  postImage(i);
                }
              }

              getPackagePriceDetail(context).then((value) {
                setState(() {
                  isCreatePackages = true;
                  addDefaultIcon = false;
                  isReplaceMenu = false;
                  isReplaceAddPackages = false;
                });
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "SET PRICE",
                  style: TextStyle(
                      color: Colors.white, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
      physics: BouncingScrollPhysics(),
    );
  }

  Future postImage(int index) async {
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://nohungkitchen.notionprojects.tech/api/kitchen/add_package_info.php"));
    request.fields['token'] = '123456789';
    request.fields['kitchen_id'] = userId;
    request.fields['package_id'] = bean.data.packageId;
    request.fields['day'] = (index + 1).toString();
    request.fields['token'] = '123456789';

    var pic = await http.MultipartFile.fromPath("image", Files[index]);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();

    var responseString = String.fromCharCodes(responseData);
    print(responseString + 'kkkkkkkkkkkkkkkkkkkkkkkkk');
  }

  addDafultIcon() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Image.asset(
                        Res.ic_default_order,
                        width: 220,
                        height: 120,
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "No package added yet",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppConstant.fontBold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "look's like you, haven't\n made your package yet.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: AppConstant.fontRegular,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isReplaceDefault = false;
                          isReplaceAddPackages = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(0xffFFA451),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2, color: Colors.grey.shade300)
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "CREATE PACKAGE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              AppConstant().navBarHt()
            ],
          ),
          physics: BouncingScrollPhysics(),
        ));
  }

  getList(
    List<WeeklyDetail> choic,
    int index,
    String package_id,
    String cuisine,
    String meal_type,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              mealDay(choic[index].day),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppConstant.fontBold),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showPicker(context, index);
            },
            child: Padding(
                padding: EdgeInsets.only(right: 36, left: 5),
                child: Image(
                  image: (Files[index].toString() == 'null')
                      ? NetworkImage(choic[index].image)
                      : FileImage(File(Files[index])),
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                )
                // Image.file(
                //   choic[index].image,

                // ),
                ),
          ),
          Expanded(
            child: Text(
              choic[index].itemName.toString(),
              style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddMealScreen(
                            package_id: package_id,
                            appBar_Cuisine: cuisine,
                            appBar_cat: meal_type,
                            day: choic[index].day.toString(),
                          ))).then((value) {
                setState(() {
                  getMenuPackageList(package_id);
                });
              });
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 10),
              width: 50,
              decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Image.asset(
                  Res.ic_plus,
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String mealIcon(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Res.ic_breakfast;
      case 'Lunch':
        return Res.ic_dinner;
      case 'Dinner':
        return Res.ic_dinner;
      case 'Veg':
        return Res.ic_veg;
      case 'Non-Veg':
        return Res.ic_chiken;
      default:
        return Res.ic_cross;
    }
  }

  String mealDay(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Wrong day';
    }
  }

  Widget getItems(BeanGetPackagesData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    (item.mealtype == '0')
                        ? Image.asset(
                            Res.ic_veg,
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            Res.ic_chiken,
                            width: 20,
                            height: 20,
                          ),
                    SizedBox(width: 5),
                    Text(
                      item.packagename,
                      style: TextStyle(
                          fontFamily: AppConstant.fontBold, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        getMenuPackageList(item.packageId).then((value) {
                          setState(() {
                            createPackageid = item.packageId;
                            isReplaceDefault = false;
                            addDefaultIcon = false;
                            isReplaceMenu = true;
                            isReplaceAddPackages = false;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset(
                          Res.ic_edit,
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        deletePackage(item.packageId);
                      },
                      child: Container(
                        child: Icon(Icons.delete, color: AppConstant.appColor),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From ' + item.createddate.substring(0, 10)),
                    SizedBox(height: 10),
                    Text(
                      'Meal for',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          Res.ic_breakfast,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 7),
                        Text(
                          (item.mealfor == '0')
                              ? 'Breakfast'
                              : (item.mealfor == '1')
                                  ? 'Lunch'
                                  : 'Dinner',
                          style: TextStyle(fontFamily: AppConstant.fontBold),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Including  ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        (item.includingSaturday == '1')
                            ? Text('Saturday,')
                            : Text(''),
                        (item.includingSunday == '1')
                            ? Text(' Sunday')
                            : Text(''),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Type of cuisine',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Text(
                      (item.cuisinetype == '0')
                          ? 'South Indina'
                          : (item.cuisinetype == '0')
                              ? 'North Indina'
                              : 'Other Cuisine',
                      style: TextStyle(fontFamily: AppConstant.fontBold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(height: 1, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (item.weeklyplantype == '1')
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstant.rupee + item.weeklyprice,
                            style: TextStyle(
                                color: AppConstant.lightGreen,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Weekly  Package'),
                        ],
                      )
                    : Container(),
                (item.monthlyplantype == '1')
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstant.rupee + item.monthlyprice,
                            style: TextStyle(
                                color: AppConstant.lightGreen,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Monthly Package'),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(height: 2, thickness: 5, color: Colors.grey.withOpacity(0.2)),
        ],
      ),
    );
  }

  PackageList() {
    return (userBean.data == null)
        ? Container()
        : (getPackagesbean.status == false)
            ? addDafultIcon()
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: getPackagesbean.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return getItems(getPackagesbean.data[index]);
                      },
                    ),
                    AppConstant().navBarHt()
                  ],
                ),
              );
  }

  addPackages() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Packages Name",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: TextField(
                controller: packagename,
                decoration: InputDecoration(hintText: "Package 1"),
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Type of Cuisine",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectFood = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16),
                    decoration: BoxDecoration(
                        color: isSelectFood == 0
                            ? Color(0xffFEDF7C)
                            : Color(0xffF3F6FA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "South Indian",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectFood = 1;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isSelectFood == 1
                              ? Color(0xffFEDF7C)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "North Indian",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectFood = 2;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16, right: 10),
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isSelectFood == 2
                              ? Color(0xffFEDF7C)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Other",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold),
                        ),
                      )),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
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
                      isMealType = 0;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      height: 45,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isMealType == 0
                              ? Color(0xff7EDABF)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Image.asset(
                            Res.ic_veg,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Veg",
                            style: TextStyle(
                                color: isMealType == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: AppConstant.fontBold),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isMealType = 1;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      height: 45,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isMealType == 1
                              ? Color(0xff7EDABF)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Image.asset(
                            Res.ic_chiken,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Non Veg",
                            style: TextStyle(
                                color: isMealType == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: AppConstant.fontBold),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal For",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
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
                      isSelectMenu = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16),
                    decoration: BoxDecoration(
                        color: isSelectMenu == 0
                            ? Color(0xffFEDF7C)
                            : Color(0xffF3F6FA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Breakfast",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenu = 1;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isSelectMenu == 1
                              ? Color(0xffFEDF7C)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Lunch",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenu = 2;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16, right: 10),
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isSelectMenu == 2
                              ? Color(0xffFEDF7C)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Dinner",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold),
                        ),
                      )),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Plan Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
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
                      isSelectPlanTypeWeekly = !isSelectPlanTypeWeekly;
                      print(isSelectPlanTypeWeekly);
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                    decoration: BoxDecoration(
                        color: isSelectPlanTypeWeekly
                            ? Color(0xffFEDF7C)
                            : Color(0xffF3F6FA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Weekly",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectPlanTypeMonthly = !isSelectPlanTypeMonthly;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                      height: 50,
                      width: 110,
                      decoration: BoxDecoration(
                          color: isSelectPlanTypeMonthly
                              ? Color(0xffFEDF7C)
                              : Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Monthly",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold),
                        ),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 26),
            child: Text(
              "Start Date",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(child: Text(date == "" ? "select date" : date)),
              InkWell(
                onTap: () async {
                  var result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 10),
                      lastDate: DateTime(DateTime.now().year + 10));
                  print('$result');
                  setState(() {
                    date = result.year.toString() +
                        "-" +
                        result.month.toString() +
                        "-" +
                        result.day.toString();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Res.ic_calendar,
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Saturday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: _other2,
                    onChanged: (newValue) {
                      setState(() {
                        _other2 = newValue;
                        if (_other2 == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Saturday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: sunday,
                    onChanged: (newValue) {
                      setState(() {
                        sunday = newValue;
                        if (sunday == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () {
              setState(() {
                validation();
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "SET MENU",
                  style: TextStyle(
                      color: Colors.white, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
    );
  }

  createPackage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 150,
            child: Center(
              child:
                  Image.asset(Res.ic_create_package, width: 130, height: 130),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    AppConstant.rupee +
                        " " +
                        beanprice.data.actualWeeklyPackage,
                    style: TextStyle(
                        color: Color(0xff7EDABF),
                        fontFamily: AppConstant.fontBold,
                        fontSize: 18),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 16),
                ),
              ),
              Padding(
                child: Text(
                  AppConstant.rupee + " " + beanprice.data.actualMonthlyPackage,
                  style: TextStyle(
                      color: Color(0xff7EDABF),
                      fontFamily: AppConstant.fontBold,
                      fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    "Actual Total Price",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontRegular,
                        fontSize: 14),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                ),
              ),
              Padding(
                child: Text(
                  "Actual Total Price",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontRegular,
                      fontSize: 14),
                ),
                padding: EdgeInsets.only(top: 16, right: 16),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    "Weekly Package",
                    style: TextStyle(
                        color: Color(0xff555555),
                        fontFamily: AppConstant.fontBold,
                        fontSize: 14),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                ),
              ),
              Padding(
                child: Text(
                  "Monthly Package",
                  style: TextStyle(
                      color: Color(0xff555555),
                      fontFamily: AppConstant.fontBold,
                      fontSize: 14),
                ),
                padding: EdgeInsets.only(top: 8, right: 16),
              ),
            ],
          ),
          Padding(
            child: Text(
              "Set your price (weekly)",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold,
                  fontSize: 14),
            ),
            padding: EdgeInsets.only(left: 16, top: 30, right: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: TextField(
                    onChanged: (val) {
                      double diff = double.parse(weekly.text) -
                          double.parse(
                              beanprice.data.actualWeeklyPackage.toString());
                      double av = (double.parse(weekly.text) +
                              double.parse(beanprice.data.actualWeeklyPackage
                                  .toString())) /
                          2;
                      setState(() {
                        variance = (diff /
                                double.parse(
                                    beanprice.data.actualWeeklyPackage)) *
                            100;
                        print(variance.toString());
                      });
                    },
                    controller: weekly,
                    decoration:
                        InputDecoration(hintText: AppConstant.rupee + "25,00"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "Variation",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  variance.toString(),
                  // .substring(0, 5) + " %",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            child: Text(
              "Set your price (Monthly)",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold,
                  fontSize: 14),
            ),
            padding: EdgeInsets.only(left: 16, top: 30, right: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: TextField(
                    controller: monthly,
                    decoration:
                        InputDecoration(hintText: AppConstant.rupee + "25,00"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "Variation",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "-16.5%",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              addPackagePriceValidation(createPackageid);
            },
            child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 15),
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xffFFA451),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "CREATE PACKAGE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: AppConstant.fontBold),
                  ),
                )),
          ),
          AppConstant().navBarHt()
        ],
      ),
    );
  }

  Future<BeanPackagePriceDetail> getPackagePriceDetail(
      BuildContext context) async {
    progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": '123456789',
        "package_id": createPackageid,
      });

      beanprice = await ApiProvider().getPackagePriceDetail(from);
      print(bean.data);

      if (bean.status == true) {
        progressDialog.dismiss();
        return beanprice;
      } else {
        Utils.showToast(bean.message);
      }

      return null;
    } on HttpException catch (exception) {
      progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      progressDialog.dismiss();
      print(exception);
    }
  }

  void addPackagePriceValidation(String package_id) {
    if (weekly.text.isEmpty) {
      Utils.showToast("please enter weekly price");
    } else if (monthly.text.isEmpty) {
      Utils.showToast("please enter monthly price");
    } else {
      addPackagePrice(context, package_id);
    }
  }

  Future<BeanAddPackagePrice> addPackagePrice(
      BuildContext context, String package_id) async {
    progressDialog.show();
    print(package_id + '===========package=====================');
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": '123456789',
        "package_id": package_id,
        "weekly_price": weekly.text.toString(),
        "monthly_price": monthly.text.toString(),
      });

      BeanAddPackagePrice bean = await ApiProvider().addPackagePrice(from);
      print(bean.data);

      if (bean.status == true) {
        progressDialog.dismiss();
        weekly.clear();
        monthly.clear();
        variance = 0.0;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPackageScreen()),
        ).then((value) {
          setState(() {
            getMealScreenItems();
            isReplaceDefault = true;
            isReplaceMenu = false;
            isReplaceAddPackages = false;
            isCreatePackages = false;
          });
        });
        return bean;
      } else {
        Utils.showToast(bean.message);
      }

      return null;
    } on HttpException catch (exception) {
      progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      progressDialog.dismiss();
      print(exception);
    }
  }

  Future<BeanAddMenu> getMenuPackageList(String Package_id) async {
    progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "package_id": Package_id,
      });
      bean = await ApiProvider().getMenuPackageList(from);
      print(bean.data);
      progressDialog.dismiss();
      if (bean.status == true) {
        setState(() {});
        return bean;
      } else {
        Utils.showToast(bean.message);
        return bean;
      }

      return null;
    } on HttpException catch (exception) {
      progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      progressDialog.dismiss();
      print(exception);
    }
  }

  Future<BeanGetPackages> getMealScreenItems() async {
    progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "user_id": userId,
        "token": "123456789",
      });
      getPackagesbean = await ApiProvider().getPackages(from);
      print(getPackagesbean.data);
      progressDialog.dismiss();
      if (getPackagesbean.status == true) {
        setState(() {});
        return getPackagesbean;
      } else {
        Utils.showToast(getPackagesbean.message);
        setState(() {});
        return getPackagesbean;
      }

      return null;
    } on HttpException catch (exception) {
      // progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      //  progressDialog.dismiss();
      print(exception);
    }
  }

  Future<BeanDeletePackage> deletePackage(String packageId) async {
    progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "package_id": packageId,
      });
      BeanDeletePackage bean = await ApiProvider().deletePackage(from);
      print(bean.data);
      if (bean.status == true) {
        setState(() {
          getMealScreenItems();
        });
        progressDialog.dismiss();
        return bean;
      } else {
        Utils.showToast(bean.message);
      }

      return null;
    } on HttpException catch (exception) {
      progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      progressDialog.dismiss();
      print(exception);
    }
  }

  Future _showPicker(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        setState(() {
                          _imgFromGallery(index);
                        });

                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      setState(() {
                        _imgFromCamera(index);
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera(int index) async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      mediaFile = image;
      Files.insert(index, mediaFile.path);
    });
  }

  Future _imgFromGallery(int index) async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      mediaFile = image;
      Files.insert(index, mediaFile.path);
    });
  }

  Future addPackage(BuildContext context, String packName) async {
    progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "user_id": userId,
        "token": "123456789",
        "package_name": packName,
        "cuisine_type": isSelectFood == 0
            ? "0"
            : isSelectFood == 1
                ? "1"
                : isSelectFood == 2
                    ? "2"
                    : "",
        "meal_type": isMealType == 0
            ? "0"
            : isMealType == 1
                ? "1"
                : "",
        "meal_for": isSelectMenu == 0
            ? "0"
            : isSelectMenu == 1
                ? "1"
                : isSelectMenu == 2
                    ? "2"
                    : "",
        "weekly_plan_type": isSelectPlanTypeWeekly ? '1' : '0',
        "monthly_plan_type": isSelectPlanTypeMonthly ? '1' : '0',
        "start_date": date,
        "including_saturday": _other2 == false ? "0" : "1",
        "including_sunday": sunday == false ? "0" : "1"
      });
      var bean = await ApiProvider().addPackage(from);
      // print(bean.data);
      progressDialog.dismiss();
      if (bean['status'] == true) {
        Utils.showToast(bean['message']);
        setState(() {
          createPackageid = bean['data'][0]['package_id'];
          getMenuPackageList(bean['data'][0]['package_id']);
          addDefaultIcon = false;
          isReplaceMenu = true;
          isReplaceAddPackages = false;
        });

        return bean;
      } else {
        Utils.showToast(bean.message);
      }

      return null;
    } on HttpException catch (exception) {
      progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      progressDialog.dismiss();
      print(exception);
    }
  }

  void validation() {
    var packName = packagename.text.toString();
    if (packName.isEmpty) {
      Utils.showToast("please select package name");
    } else if (isSelectFood == -1) {
      Utils.showToast("please select cuisine type");
    } else if (isMealType == -1) {
      Utils.showToast("please select meal type");
    } else if (isSelectMenu == -1) {
      Utils.showToast("please select meal for");
    } else if (date.isEmpty) {
      Utils.showToast("please add start date");
    } else if (!isSelectPlanTypeWeekly && !isSelectPlanTypeMonthly) {
      Utils.showToast("please select plan type");
    } else {
      addPackage(context, packName);
    }
  }
}

class Choice {
  Choice({this.title, this.image});

  String title;
  String image;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Monday'),
  Choice(title: 'Tuesday'),
  Choice(title: 'Wednesday'),
  Choice(title: 'Thursday'),
  Choice(title: 'Friday'),
  Choice(title: 'Saturday'),
  Choice(title: 'Sunday'),
];
