import 'package:flutter/material.dart';
class DommyLine extends StatefulWidget {
  @override
  _DommyLineState createState() => _DommyLineState();
}

class _DommyLineState extends State<DommyLine> {

  List<Model> list = [];

  @override
  void initState() {
    super.initState();
    list.add(Model("Hyderabad", Colors.red));
    list.add(Model("Visakhapatnam", Colors.green));
    list.add(Model("Vijayawada", Colors.blue));
  }

  void addNew() {
    setState(() {
      list.add(Model("Karnool", Colors.black));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title:
                Text('Custom Stepper', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.white),
                  onPressed: addNew)
            ]),
        body: Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (con, ind) {
                  return ind != 0
                      ? Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(children: [
                            Column(
                              children: List.generate(
                                3,
                                (ii) => Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Container(
                                      height: 3,
                                      width: 2,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              color: Colors.grey.withAlpha(60),
                              height: 0.5,
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 20,
                              ),
                            ))
                          ]),
                          Row(children: [
                            Icon(Icons.location_on, color: list[ind].color),
                            Text(list[ind].address,
                                style: TextStyle(color: list[ind].color))
                          ])
                        ])
                      : Row(children: [
                          Icon(Icons.location_on, color: list[ind].color),
                          Text(list[ind].address,
                              style: TextStyle(color: list[ind].color))
                        ]);
                })));
  }
}

class Model {
  String address;
  double lat;
  double long;
  Color color;
  //Other fields if needed....
  Model(this.address, this.color);
  //initialise other fields so on....
}