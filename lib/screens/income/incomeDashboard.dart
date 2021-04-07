import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeDashboard extends StatefulWidget {
  @override
  _IncomeDashboardState createState() => _IncomeDashboardState();
}

class _IncomeDashboardState extends State<IncomeDashboard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height / 3,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enableDoubleTapZooming: true,
                enablePanning: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(title: AxisTitle()),
            backgroundColor: Colors.white,
            title: ChartTitle(text: 'Trip'),
            legend: Legend(
              isVisible: false,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              ColumnSeries<Trip, String>(
                  color: Theme.of(context).accentColor,
                  name: "Trip",
                  dataSource: getColumnData(),
                  xValueMapper: (Trip trip, _) => trip.day,
                  yValueMapper: (Trip trip, _) => trip.trip),
            ],
          ),
        ),
        //top card
       for (IncomeDataList x in incomeDataLists)
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Row(
            children: [
              Container(
                height: height / 8,
                width: width / 2,
                color: Colors.white,
                child: Padding(
                  padding:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? const EdgeInsets.all(8.0)
                          : EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        x.title,
                        style: TextStyle(color: Colors.black38),
                      ),
                      Padding(
                        padding: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? const EdgeInsets.only(top: 8.0)
                            : EdgeInsets.only(top: 0.0),
                        child: Text(
                          x.value,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: height / 8),
              Container(
                height: height / 8,
                width: width / 2 - 1,
                color: Colors.white,
                child: Padding(
                  padding:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? const EdgeInsets.all(8.0)
                          : EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        x.title2,
                        style: TextStyle(color: Colors.black38),
                      ),
                      Padding(
                        padding: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? const EdgeInsets.only(top: 8.0)
                            : EdgeInsets.only(top: 0.0),
                        child: Text(
                          x.value2,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //middle card
     ],
    );
  }

  dynamic getColumnData() {
    List<Trip> columnData = <Trip>[
      Trip("Sun", 1),
      Trip("Mon", 8),
      Trip("Tue", 3),
      Trip("Wed", null),
      Trip("Thu", 8),
      Trip("Fri", 5),
      Trip("Sat", null),
    ];
    return columnData;
  }
}

class Trip {
  String day;
  int trip;
  Trip(this.day, this.trip);
}

//todo:if accepetd then convert to grid view
/* class IncomeDataList {
  final String title;
  final String value;
  const IncomeDataList(this.title, this.value);
}

const incomeDataLists = <IncomeDataList>[
  IncomeDataList('Total Earning', 'Rs 0'),
  IncomeDataList('Trips Completed', '0'),
  IncomeDataList('Collected Fare', 'Rs 0'),
  IncomeDataList('Request Received', '0'),
  IncomeDataList('Today Rating', 'N/A'),
  IncomeDataList('Completion Rate', 'N/A')
];
 */

 class IncomeDataList {
  final String title;
  final String value;
  final String title2;
  final String value2;
  const IncomeDataList(this.title, this.value, this.title2, this.value2);
}

const incomeDataLists = <IncomeDataList>[
  IncomeDataList('Total Earning', 'Rs 0','Trips Completed', '0'),
  IncomeDataList('Collected Fare', 'Rs 0','Request Received', '0'),
  IncomeDataList('Today Rating', 'N/A','Completion Rate', 'N/A')
];