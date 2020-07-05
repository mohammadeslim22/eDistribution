import 'dart:async';
import 'package:agent/constants/colors.dart';
import 'package:agent/constants/styles.dart';
import 'package:agent/localization/trans.dart';
import 'package:agent/providers/counter.dart';
import 'package:agent/util/dio.dart';
import 'package:animated_card/animated_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:mock_data/mock_data.dart';
import 'package:intl/intl.dart';

class BeneficiaryCenter extends StatefulWidget {
 const BeneficiaryCenter({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _BeneficiaryCenterState createState() => _BeneficiaryCenterState();
}

class _BeneficiaryCenterState extends State<BeneficiaryCenter> {
  //   Future<List<MembershipData>> getMembershipsData(int pageIndex) async {
  //   final Response<dynamic> response = await dio.get<dynamic>("memberships",
  //       queryParameters: <String, dynamic>{'page': pageIndex + 1});
  //   memberships = Memberships.fromJson(response.data);
  //   return memberships.data;
  // }
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        // _animateToUser();
      }
    }
  }

  StreamSubscription<dynamic> getPositionSubscription;
  GoogleMapController mapController;
  Location location = Location();
  double lat;
  double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    super.initState();
    lat = widget.lat ?? 25.063054;
    long = widget.long ?? 55.170010;
    setState(() {
      billIsOn = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  bool billIsOn = true;
  @override
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "altariq")),
        centerTitle: true,
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(trans(context, "ben_center"),
                    style: styles.mywhitestyle),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_outline,
                                  color: Colors.blue, size: 40),
                              const SizedBox(width: 16),
                              Text("كابيتال مول ",
                                  style: styles.beneficiresNmae)
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.location_on,
                                  color: Colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text("الإمارات العربية المتحدة",
                                  style: styles.underHeadgray)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 64),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.call, color: Colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text(
                                trans(context, "جوال:    ") + "0675052338",
                                style: styles.beneficiresNmae,
                              )
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email, color: Colors.blue, size: 30),
                              const SizedBox(width: 16),
                              Text(
                                "Ahmed@gmail.com",
                                style: styles.underHeadgray,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pushNamed(context, "/Order_Screen");
                          },
                          child: Text(trans(context, "order"),
                              style: styles.mywhitestyle),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.red,
                          onPressed: () {},
                          child: Text(
                            trans(context, "return"),
                            style: styles.mywhitestyle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.green,
                          onPressed: () {},
                          child: Text(trans(context, "collection"),
                              style: styles.mywhitestyle),
                        ),
                      )
                    ],
                  ),
                  listSubChoices(bolc.language, bolc),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.blue[100]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16,0,0,12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(trans(context, "id"),
                                    style: styles.mystyle,textAlign: TextAlign.start)),
                            Expanded(
                              child: Text(trans(context, "agent"),
                                  style: styles.mystyle),
                            ),
                            Expanded(
                              flex: 2,
                                child: Text(trans(context, "date"),
                                    style: styles.mystyle,textAlign: TextAlign.center)),
                            Expanded(
                                child: Text(trans(context, "total"),
                                    style: styles.mystyle,textAlign: TextAlign.end))
                          ],
                        ),
                      )),
                  Expanded(
                    child: FutureBuilder<String>(
                        future: getNotifications(),
                        builder:
                            (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data.isEmpty) {}
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: 60,
                              addRepaintBoundaries: true,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimatedCard(
                                  direction: AnimatedCardDirection.left,
                                  initDelay: const Duration(milliseconds: 0),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease,
                                  child: _itemBuilder(context, index),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                            ));
                          }
                        }),
                  )
                  // Expanded(
                  //   child: PagewiseListView<dynamic>(
                  //     physics: const ScrollPhysics(),
                  //     shrinkWrap: true,
                  //     loadingBuilder: (BuildContext context) {
                  //       return const Center(
                  //           child: CircularProgressIndicator(
                  //         backgroundColor: Colors.transparent,
                  //       ));
                  //     },
                  //     pageSize: 10,
                  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  //     itemBuilder:
                  //         (BuildContext context, dynamic entry, int index) {
                  //       return AnimatedCard(
                  //         direction: AnimatedCardDirection.left,
                  //         initDelay: const Duration(milliseconds: 0),
                  //         duration: const Duration(seconds: 1),
                  //         curve: Curves.ease,
                  //         child: _itemBuilder(context, entry),
                  //       );
                  //     },
                  //     noItemsFoundBuilder: (BuildContext context) {
                  //       return Text(trans(context, "noting_to_show"));
                  //     },
                  //     // pageFuture: (int pageIndex) {
                  //     //   return getAddressData(pageIndex);
                  //     // },
                  //   ),
                  // )
                ],
              ),
            ),
            if (billIsOn) Expanded(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          onMapCreated: _onMapCreated,
                          padding: const EdgeInsets.only(bottom: 60),
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(markers.values),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 13,
                          ),
                          onCameraMove: (CameraPosition pos) {
                            setState(() {
                              lat = pos.target.latitude;
                              long = pos.target.longitude;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 69),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {},
                                  child: GestureDetector(
                                    child: Center(
                                      child: Icon(
                                        Icons.my_location,
                                        color: const Color.fromARGB(
                                            1023, 150, 150, 150),
                                      ),
                                    ),
                                    onTap: () async {
                                      serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!serviceEnabled) {
                                        serviceEnabled =
                                            await location.requestService();
                                        if (!serviceEnabled) {
                                        } else {
                                          permissionGranted =
                                              await location.hasPermission();
                                          if (permissionGranted ==
                                              PermissionStatus.denied) {
                                            permissionGranted = await location
                                                .requestPermission();
                                            if (permissionGranted ==
                                                PermissionStatus.granted) {
                                              //  _animateToUser();
                                            }
                                          } else {
                                            //    _animateToUser();
                                          }
                                        }
                                      } else {
                                        permissionGranted =
                                            await location.hasPermission();
                                        if (permissionGranted ==
                                            PermissionStatus.denied) {
                                          permissionGranted = await location
                                              .requestPermission();
                                          if (permissionGranted ==
                                              PermissionStatus.granted) {
                                            //  _animateToUser();
                                          }
                                        } else {
                                          print("iam fucked up");
                                          //   _animateToUser();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) else Expanded(child: bill()),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int entry) {
    final DateTime berlinWallFell = DateTime.utc(2019, 12, 12);
    final DateTime dt = mockDate(berlinWallFell, DateTime.now());
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Share',
            color: Colors.indigo,
            icon: Icons.share,
            onTap: () {},
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'More',
            color: Colors.black45,
            icon: Icons.more_horiz,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {},
          ),
        ],
        child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: entry % 2 == 0 ? Colors.blue[200] : Colors.transparent,
          onPressed: () {
            setState(() {
              billIsOn = false;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(trans(context, entry.toString()), style: styles.mystyle),
              Text(trans(context, "أحمد سلمي"), style: styles.mystyle),
              Text(
                  " ${DateFormat('yyyy-MM-dd').format(dt)}   ${DateFormat.jm().format(dt)}",
                  style: styles.mystyle),
              Text(((entry + 1) * 330).toString() + ".00",
                  style: styles.mystyle)
            ],
          ),
        ));
  }

  Widget listSubChoices(List<bool> list, MyCounter bolc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(trans(context, "count"  "(22)"), style: styles.mystyle),
        Container(
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              color: list[0] ? Colors.green[100] : Colors.transparent),
          child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                bolc.changelanguageindex(0);
              },
              child: SvgPicture.asset("assets/images/order_icon.svg")),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              color: list[1] ? Colors.red[100] : Colors.transparent),
          child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                bolc.changelanguageindex(1);
              },
              child: SvgPicture.asset("assets/images/return_icon.svg")),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow),
              color: list[2] ? Colors.yellow[100] : Colors.transparent),
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              bolc.changelanguageindex(2);
            },
            child: SvgPicture.asset(
              "assets/images/collection_icon.svg",
              width: 40,
            ),
          ),
        ),
        Text(trans(context, "total"  "(222)"), style: styles.mystyle)
      ],
    );
  }

  Widget bill() {
    // final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(trans(context, "name"), style: styles.mybluestyle),
                      const SizedBox(height: 24),
                      Text(trans(context, "date"), style: styles.mybluestyle)
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(trans(context, "كابيتال مول للمأكولات الشعبية"),
                          style: styles.mystyle),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("28-1-2020   6:51 PM", style: styles.mystyle),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            if (!billIsOn) Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                    width: 130,
                    height: 130,
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              billIsOn = !billIsOn;
                            });
                          },
                          child: Image.asset("assets/images/map_icon.jpg",
                              scale: .01, width: 60, height: 60),
                        ),
                        Text(
                          trans(context, "back_to_map"),
                          style: TextStyle(color: colors.black),
                        )
                      ],
                    ),
                  ) else Container(),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(trans(context, 'id'),
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'product_name'),
                        style:const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'quantity'),
                        style:const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'unit'),
                        style:const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'unit_price'),
                        style:const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  DataColumn(
                    label: Text(trans(context, 'total'),
                        style:const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ],
                rows: const<DataRow>[
                  DataRow(cells: <DataCell>[
                    DataCell(Text('1')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('2')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('3')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('4')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('5')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('6')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('7')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('8')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('9')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('10')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('11')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('12')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('13')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('14')),
                    DataCell(Text('حليب المراعي')),
                    DataCell(Text('13')),
                    DataCell(Text('كرتونة')),
                    DataCell(Text('19.00')),
                    DataCell(Text('247.00'))
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('15')),
                    DataCell(Text('milk')),
                    DataCell(Text('13')),
                    DataCell(Text('carton')),
                    DataCell(Text('19')),
                    DataCell(Text('247'))
                  ]),
                ],
              )),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(trans(context, "share"), style: styles.mybluestyle),
                      Icon(
                        Icons.share,
                        size: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(trans(context, "total"), style: styles.mybluestyle),
                const SizedBox(width: 12),
                Text(trans(context, "231,0.00"), style: styles.mystyle),
                const SizedBox(width: 32),
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<String> getNotifications() async {
    final Response<dynamic> response = await dio.get<dynamic>("sales");
    return response.data.toString();
  }
}
