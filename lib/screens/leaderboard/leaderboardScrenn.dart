import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rideon_driver/services/utils/extension.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderBoard> leaderBoard;
  bool _orderOnPrice = true;

  Random random = new Random();
  @override
  void initState() {
    super.initState();
    leaderBoard = [
      LeaderBoard(
          name: "Ramesh Lekhak",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Pulchowk'),
      LeaderBoard(
          name: "Ramesh Karki",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Pulchowk'),
      LeaderBoard(
          name: "Rai Vae",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Itahari'),
      LeaderBoard(
          name: "Sashikant Chaudhary",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Damak'),
      LeaderBoard(
          name: "RamesJimi Bikram",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Brt'),
      LeaderBoard(
          name: "Barat Karki",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Ktm'),
      LeaderBoard(
          name: "Ram shah",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Vhaktapur'),
      LeaderBoard(
          name: "Sita Devi Yadab Lekhak",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Morang'),
      LeaderBoard(
          name: "Ramesh Bastola",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Sunsari'),
      LeaderBoard(
          name: "Bishal Lekhak",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Dhankuta'),
      LeaderBoard(
          name: "HAri Bastab",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Pokhera'),
      LeaderBoard(
          name: "XYZ  Khadka",
          trip: random.nextInt(100),
          income: random.nextInt(100) * 55.0,
          location: 'Butwal')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _orderOnPrice = !_orderOnPrice;
                    if (_orderOnPrice) {
                      leaderBoard.sort((a, b) => b.income.compareTo(a.income));
                    } else {
                      leaderBoard.sort((a, b) => b.trip.compareTo(a.trip));
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.filter_alt, color: Colors.redAccent,),
                  Text(
                      'click here to reorder based on ${!_orderOnPrice ? 'Price' : 'Trip'}')
                ]),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: leaderBoard[index].image.isNullOrEmpty()
                          ? AssetImage('assets/avatar.png')
                          : NetworkImage(leaderBoard[index].image),
                      radius: 20,
                    ),
                    title: Text(leaderBoard[index].name ?? ''),
                    //isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(leaderBoard[index].income.toString()),
                        Text(leaderBoard[index].location ?? ''),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.all_inclusive),
                        ),
                        Text(leaderBoard[index].trip.toString())
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 70.0),
                      child: Divider(),
                    ),
                itemCount: leaderBoard.length),
          ),
        ],
      ),
    );
  }
}

class LeaderBoard {
  String name;
  String image;
  String id;
  int trip;
  double income;
  String location;

  LeaderBoard(
      {this.name, this.image, this.id, this.trip, this.income, this.location});

  factory LeaderBoard.fromJsom(Map<String, dynamic> json) {
    return LeaderBoard(
        name: json['name'],
        image: json['image'],
        id: json['id'],
        trip: json['trip'],
        income: json['income'],
        location: json['location']);
  }
}
