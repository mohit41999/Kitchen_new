import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/Order/ActiveScreen.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/Order/OrdersHistory.dart';
import 'package:kitchen/Order/RequestScreen.dart';
import 'package:kitchen/Order/UpcomingScreen.dart';
import 'package:kitchen/model/BeanGetDashboard.dart' as res;
import 'package:kitchen/model/BeanLogin.dart';
import 'package:kitchen/model/BeanSignUp.dart';
import 'package:kitchen/model/GetorderHistory.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/screen/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constents.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/progress_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'TrackDeliveryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BeanLogin userBean;
  var name = "";
  var menu = "";
  var userId = "";
  var active_orders = "";
  var upcoming_orders = "";
  var pending_orders = "";
  var completed_orders = "";
  var active_deliveries = "";
  var ready = "";
  var preparing = "";
  var out_for_delivery = "";
  var loss = "";
  var profit = "";
  var nameOfKitchen = "";
  var profileimage = "";
  List<res.Data> data = [];
  // List<FlSpot> spots = [
  //   FlSpot(0, 3),
  //   FlSpot(2.6, 2),
  //   FlSpot(4.9, 5),
  //   FlSpot(6.8, 3.1),
  //   FlSpot(8, 4),
  //   FlSpot(9.5, 3),
  //   FlSpot(11, 4),
  // ];
  List<FlSpot> spots = [
    FlSpot(0, 0),
    FlSpot(1, 3),
    FlSpot(2, 5),
    FlSpot(3, 3.1),
    FlSpot(4, 4),
  ];

  ProgressDialog progressDialog;

  void getUser() async {
    userBean = await Utils.getUser();
    name = userBean.data.kitchenname;
    menu = userBean.data.menufile;
    userId = userBean.data.id.toString();
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();

    Future.delayed(Duration.zero, () {
      getDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
        drawer: MyDrawers(),
        backgroundColor: AppConstant.appColor,
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 120),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(38),
                      topLeft: Radius.circular(38))),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.network(
                            profileimage,
                            width: 90,
                            height: 90,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              nameOfKitchen,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'finest cuisine',
                              style: TextStyle(
                                  color: Color(0xffA7A8BC),
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActiveScreen(
                                            fromDashboard: true,
                                          )),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.only(left: 16, top: 16),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Container(
                                  height: 110,
                                  width: 70,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        active_orders.toString(),
                                        style: TextStyle(
                                            color: Color(0xffBEE8FF),
                                            fontSize: 30,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                      Text(
                                        "Active\nOrders",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpcomingScreen(
                                            fromDashboard: true,
                                          )),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.only(left: 16, top: 16),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Container(
                                  height: 110,
                                  width: 70,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        upcoming_orders.toString(),
                                        style: TextStyle(
                                            color: Color(0xffFEDF7C),
                                            fontSize: 30,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                      Text(
                                        "Upcoming\n   Orders",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestScreen(
                                            fromDashboard: true,
                                          )),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.only(left: 16, top: 16),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Container(
                                  height: 110,
                                  width: 70,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        pending_orders.toString(),
                                        style: TextStyle(
                                            color: Color(0xffFCA896),
                                            fontSize: 30,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                      Text(
                                        "Pending\nOrders",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersHistory(
                                            fromDashboard: true,
                                          )),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.only(left: 16, top: 16),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Container(
                                  height: 110,
                                  width: 70,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        completed_orders.toString(),
                                        style: TextStyle(
                                            color: Color(0xffBEE8FF),
                                            fontSize: 30,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                      Text(
                                        "Completed\n   Orders",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackDeliveryScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16, top: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Image.asset(
                              Res.ic_pan,
                              width: 120,
                              height: 120,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                "Active\nDeliveries",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                active_deliveries.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Image.asset(
                                Res.ic_back,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xffBEE8FF),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    "Preparing " + preparing.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xff7EDABF),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    "Ready " + ready.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xffFEDF7C),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                    child: Text(
                                  "Out for Delivery " +
                                      out_for_delivery.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: AppConstant.fontRegular),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 16, top: 26),
                    //   child: Text(
                    //     "Earning Reports",
                    //     style: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 18,
                    //         fontFamily: AppConstant.fontBold),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 16, right: 16, top: 26),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           margin: EdgeInsets.only(left: 1, top: 16),
                    //           height: 120,
                    //           width: 120,
                    //           decoration: BoxDecoration(
                    //               color: Color(0xffF3F6FA),
                    //               borderRadius: BorderRadius.circular(16)),
                    //           child: Center(
                    //             child: CircularPercentIndicator(
                    //               radius: 100.0,
                    //               lineWidth: 10.0,
                    //               percent: 0.5,
                    //               center: Text(
                    //                 profit + "%" + "\nProfit",
                    //                 style: TextStyle(
                    //                     fontFamily: AppConstant.fontRegular),
                    //               ),
                    //               backgroundColor: Colors.white,
                    //               progressColor: Color(0xff7EDABF),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Container(
                    //           margin: EdgeInsets.only(left: 11, top: 16),
                    //           height: 120,
                    //           width: 120,
                    //           decoration: BoxDecoration(
                    //               color: Color(0xffF3F6FA),
                    //               borderRadius: BorderRadius.circular(16)),
                    //           child: Center(
                    //             child: CircularPercentIndicator(
                    //               radius: 100.0,
                    //               lineWidth: 10.0,
                    //               percent: 0.2,
                    //               center: Text(
                    //                 loss + "%" + "\nLoss",
                    //                 style: TextStyle(
                    //                     fontFamily: AppConstant.fontRegular),
                    //               ),
                    //               backgroundColor: Colors.white,
                    //               progressColor: Color(0xffFCA896),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 16, top: 26),
                    //   child: Text(
                    //     "Sales Overview",
                    //     style: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 18,
                    //         fontFamily: AppConstant.fontBold),
                    //   ),
                    // ),
                    // // Container(
                    // //   margin: EdgeInsets.only(
                    // //       left: 16, right: 16, top: 16, bottom: 16),
                    // //   height: 270,
                    // //   width: double.infinity,
                    // //   decoration: BoxDecoration(
                    // //       color: Color(0xffF3F6FA),
                    // //       borderRadius: BorderRadius.circular(16)),
                    // //   child: Center(
                    // //       child: Padding(
                    // //     padding: EdgeInsets.only(top: 16, bottom: 16),
                    // //     child: Image.asset(Res.ic_graph),
                    // //   )),
                    // // ),
                    // SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Container(
                    //       height: 310,
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(16),
                    //         color: Color(0xffF3F6FA),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         Text('Total Earn'),
                    //                         Text(
                    //                           '  ₹15,425',
                    //                           style: TextStyle(
                    //                               fontSize: 20,
                    //                               fontWeight: FontWeight.bold),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Text('December v')
                    //                   ]),
                    //             ),
                    //             Expanded(child: LineChart(mainData())),
                    //           ],
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
                physics: BouncingScrollPhysics(),
              ),
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _scaffoldKey.currentState.openDrawer();
                      });
                    },
                    child: Image.asset(
                      Res.ic_menu,
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestScreen(
                                    fromDashboard: true,
                                  )));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Image.asset(
                        Res.ic_notification,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  )
                ],
              ),
              height: 150,
            ),
          ],
        )
        /*    appBar: AppBar(
          elevation: 0,
            backgroundColor: Colors.orange,
            leading:Row(
              children: [
                IconButton(
                  icon: ImageIcon(
                    AssetImage(
                      'assets/images/ic_menu.png',
                    ),
                    color: Colors.white,
                  ), onPressed: () {
                  setState(() {
                    _scaffoldKey.currentState.openDrawer();
                  });
                },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text("Dashboard",style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: AppConstant.fontBold),),
                  ),
                ),
                Image.asset(Res.ic_back)

              ],
            )
        )*/

        );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true, fullHeightTouchLine: true),
      showingTooltipIndicators: <ShowingTooltipIndicators>[
        ShowingTooltipIndicators(1, [
          LineBarSpot(
            LineChartBarData(show: false, showingIndicators: [1, 1]),
            1,
            FlSpot(1, 1),
          )
        ])
      ],
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xffA7A8BC),
            strokeWidth: 1,
            dashArray: [5],
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.red,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          // getTextStyles: (context, value) => const TextStyle(
          //     color: Color(0xff68737d),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1 W';
              case 2:
                return '2 w';
              case 3:
                return '3 w';
              case 4:
                return '4 w';
              case 5:
                return '5 w';
            }
            return '';
          },
          margin: 1,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          // getTextStyles: (context, value) => const TextStyle(
          //   color: Color(0xff67727d),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 15,
          // ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 2:
                return '30k';
              case 3:
                return '50k';
              case 4:
                return '70k';
              case 5:
                return '90k';
              case 6:
                return '110k';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          shadow: Shadow(color: Color(0x58968B47), blurRadius: 2),
          colors: [Color(0xff7EDABF)],
          spots: spots,
          isCurved: true,
          //colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            // colors:
            // gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  Future<res.BeanGetDashboard> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    progressDialog.show();
    try {
      FormData from =
          FormData.fromMap({"kitchen_id": userId, "token": "123456789"});
      res.BeanGetDashboard bean = await ApiProvider().beanGetDashboard(from);
      print(bean.data);
      progressDialog.dismiss();
      if (bean.status == true) {
        if (bean.data != null) {
          active_orders = bean.data.activeOrders.toString();
          upcoming_orders = bean.data.upcomingOrders.toString();
          pending_orders = bean.data.pendingOrders.toString();
          completed_orders = bean.data.completedOrders.toString();
          active_deliveries = bean.data.activeDeliveries.toString();
          ready = bean.data.ready.toString();
          preparing = bean.data.preparing.toString();
          out_for_delivery = bean.data.outForDelivery.toString();
          loss = bean.data.loss.toString();
          profit = bean.data.profit.toString();
          nameOfKitchen = bean.data.kitchenName.toString();
          profileimage = bean.data.profile_image.toString();
          prefs.setString('profile', profileimage);
        }

        setState(() {});

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
}
