import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:ned/models/leaves.dart';

class PieChartExample extends StatefulWidget {
  const PieChartExample({Key key}) : super(key: key);

  @override
  _PieChartExampleState createState() => _PieChartExampleState();
}

class _PieChartExampleState extends State<PieChartExample> {
  // Chart configs.
  bool _animate = true;
  double _arcRatio = 0.2;
  charts.ArcLabelPosition _arcLabelPosition = charts.ArcLabelPosition.outside;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.top;

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<List<Course>>(context) ?? [];
    final user = Provider.of<User>(context);

    final _colorPalettes =
    charts.MaterialPalette.getOrderedPalettes(courses.length);

    double newHeight = courses.length > 10 ? 200 : 250;

      return StreamBuilder<List<Course>>(
        stream: DatabaseService(email: user.email, uid: user.uid).courses,
        builder: (context, snapshot){
              return ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  courses.length != 0 ? Column(
                    children: <Widget>[
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Container(width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0,10.0),
                                      blurRadius: 5.0
                                  ),
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 30.0,
                                  )
                                ]
                            ),
                            height: MediaQuery.of(context).size.height*0.25,
                            child:  charts.PieChart(
                              // Pie chart can only render one series.
                              /*seriesList=*/ [
                              charts.Series<Course, String>(
                                id: 'Sales-1',
                                colorFn: (_, idx) => _colorPalettes[idx].shadeDefault,
                                domainFn: (Course sales, _) => sales.courseCode,
                                measureFn: (Course sales, _) => sales.leaves,
                                data: courses,
                                // Set a label accessor to control the text of the arc label.
                                labelAccessorFn: (Course row, _) =>
                                '${row.courseCode}: ${row.leaves}',

                              ),
                            ],
                              animate: this._animate,


                              defaultRenderer: new charts.ArcRendererConfig(
                                arcRatio: this._arcRatio,
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator(labelPosition: this._arcLabelPosition)
                                ],
                              ),
                              behaviors: [
                                // Add title.
                              ],
                            )
                          ),
                        ),
                      ) ,
                      SizedBox(height: 10.0),
                      Text(
                        'All Courses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: newHeight,
                          child: charts.PieChart(
                            // Pie chart can only render one series.
                            /*seriesList=*/ [
                            charts.Series<Course, String>(
                              id: 'Sales-1',
                              colorFn: (_, idx) => _colorPalettes[idx].shadeDefault,
                              domainFn: (Course row, _) => '${row.courseName} - ${row.courseCode}',
                              measureFn: (Course sales, _) => sales.leaves,
                              data: courses,
                              // Set a label accessor to control the text of the arc label.
                              labelAccessorFn: (Course row, _) =>
                              '${row.courseCode}: ${row.leaves}',
                            ),
                          ],
                            defaultRenderer: new charts.ArcRendererConfig(
                              arcRatio: 0,
                            ),
                            behaviors: [

                              // Add legend. ("Datum" means the "X-axis" of each data point.)
                              charts.DatumLegend(
                                desiredMaxColumns: 1,
                                position: this._legendPosition,
                                desiredMaxRows: 25,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ) : Container(
                    height: MediaQuery.of(context).size.height*0.84,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/bot.gif', height: MediaQuery.of(context).size.height*0.25, width: 200,),
                        SizedBox(height: 50.0),
                        SizedBox(height: 20.0),
                        SizedBox(height: 50.0),
                        Text(
                          "tap '+' to add a New Course",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.height*0.022,
                          ),
                        ),
                        SizedBox(height: 8.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "tap '",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: MediaQuery.of(context).size.height*0.020,
                              ),
                            ),
                            Icon(
                              Icons.update,
                             // color: Colors.white,
                            ),
                            Text(
                              "' to Update Attendance",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: MediaQuery.of(context).size.height*0.020,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
        },
      );
    }

}

