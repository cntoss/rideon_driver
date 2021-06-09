import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/models/driverModel.dart';
import 'package:rideon_driver/models/pooling/sharingModel.dart';
import 'package:rideon_driver/screens/pooling/driver/driverProfile.dart';
import 'package:rideon_driver/widget/customCard.dart';

class CarShareSearching extends StatefulWidget {
  final SharingModel sharingModel;
  CarShareSearching(this.sharingModel);

  @override
  _CarShareSearchingState createState() =>
      _CarShareSearchingState(this.sharingModel);
}

class _CarShareSearchingState extends State<CarShareSearching> {
  SharingModel sharingModel;
  _CarShareSearchingState(this.sharingModel);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResult();
  }

  _fetchSearchResult() {
    Future.delayed(
        Duration(seconds: 2),
        () => setState(() {
              _loading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomCard(
                  child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Icon(Icons.search),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: sharingModel.fromLocation,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                WidgetSpan(
                                  child: Icon(Icons.east, size: 14),
                                ),
                                TextSpan(
                                    text: sharingModel.fromLocation,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            maxLines: 3,
                          ),
                        ),
                        /*  Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1, child: Text(sharingModel.fromLocation)),
                        //Flexible(flex:5,child: Icon(Icons.east)),
                        //Flexible(flex:3,child: Text(sharingModel.toLocation)),
                      ],
                    ), */
                        Row(
                          children: [
                            Text(
                                '${AppConfig().dateWithoutTime.format(sharingModel.date)} , ${sharingModel.passenger} passengers'),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
              CircleAvatar(
                radius: 100,
                backgroundImage: ExactAssetImage('assets/waiting.png'),
              ),
              Container(
                height: 100,
                child: Text(
                    'There is no rides between this cities on ${AppConfig().dateWithoutTime.format(sharingModel.date)}'),
              ),
              Container(height: 200, child: SharingResult(widget.sharingModel))
            ],
          ),
          if (_loading)
            Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.tealAccent,
            ))
        ],
      ),
    );
  }
}

class SharingResult extends StatefulWidget {
  final SharingModel sharingModel;
  SharingResult(this.sharingModel);
  @override
  _SharingResultState createState() => _SharingResultState();
}

class _SharingResultState extends State<SharingResult> {
  List<Model> list = [];
  int rate = 2;
  String? driverImage;
  @override
  void initState() {
    super.initState();
    list.add(Model(widget.sharingModel.fromLocation, Color(0xff6b0236)));
    //list.add(Model("Visakhapatnam", Colors.green));
    list.add(Model(widget.sharingModel.toLocation, Color(0xff570357)));
  }

  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;
    return CustomCard(
        color: Color(0xff05a74b),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: MediaQuery.of(context).size.height / 4.3,
              child: MaterialButton(
                height: 30,
                onPressed: () {},
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text(
                  "Chipest",
                ),
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            ListView.builder(
                itemCount: list.length,
                itemBuilder: (con, ind) {
                  return ind != 0
                      ? Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Column(
                                children: List.generate(
                                  6,
                                  (ii) => Padding(
                                      padding: EdgeInsets.only(
                                          left: 47,
                                          right: 10,
                                          top: 1,
                                          bottom: 1),
                                      child: Container(
                                        height: 3,
                                        width: 2,
                                        color: Colors.grey,
                                      )),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.run_circle,
                                    size: 30,
                                    color: rate == 1
                                        ? Color(0xffb6cc0e)
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.run_circle,
                                    size: 30,
                                    color: rate == 2
                                        ? Color(0xffc90ecc)
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.run_circle,
                                    size: 30,
                                    color: rate == 3
                                        ? Color(0xffcc370e)
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: Container(
                                color: Colors.grey.withAlpha(60),
                                height: 0.1,
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 20,
                                ),
                              )),
                            ],
                          ),
                          Row(children: [
                            Text('10:20',
                                style: TextStyle(color: list[ind].color)),
                            Icon(Icons.location_on, color: list[ind].color),
                            Text(list[ind].address,
                                style: TextStyle(color: list[ind].color))
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(left: 57.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.run_circle,
                                  size: 30,
                                  color: rate == 1
                                      ? Color(0xffb6cc0e)
                                      : Colors.grey,
                                ),
                                Icon(
                                  Icons.run_circle,
                                  size: 30,
                                  color: rate == 2
                                      ? Color(0xffc90ecc)
                                      : Colors.grey,
                                ),
                                Icon(
                                  Icons.run_circle,
                                  size: 30,
                                  color: rate == 3
                                      ? Color(0xffcc370e)
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToDriverProfile(context),
                            child: Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: driverImage == null
                                        ? AssetImage('assets/avatar.png') as ImageProvider
                                        : NetworkImage('randomLInk'),
                                    radius: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Rajesh',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                size: 12, color: Colors.white),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text('4.5',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white)),
                                            )
                                          ],
                                        )

                                        /*  TextButton.icon(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.star,
                                              size: 12,
                                            ),
                                            label: Text(
                                              '4.5',
                                              style: TextStyle(fontSize: 12),
                                            )
                                            ) */
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ])
                      : Row(children: [
                          Text('10:20',
                              style: TextStyle(color: list[ind].color)),
                          Icon(Icons.location_on, color: list[ind].color),
                          Text(list[ind].address,
                              style: TextStyle(color: list[ind].color)),
                          Spacer(),
                          Text('Rs.950.00')
                        ]);
                }),
          ],
        ));
  }

  _navigateToDriverProfile(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverProfile(DriverModel(
                id: 1,
                age: 28,
                displayName: 'Rmesh Prasai',
                profilePicture:
                    "https://cdn.images.express.co.uk/img/dynamic/24/590x/women-better-drivers-945487.jpg",
                rating: 3.5,
                music: true,
                smoke: false,
                petAllow: true,
                funny: true,
                memberDate: "2077-09-11",
                rides: 29))));
  }
}

class Model {
  String address;
 /*  double lat;
  double long;
  */ Color color;
  //Other fields if needed....
  Model(this.address, this.color);
  //initialise other fields so on....
}
