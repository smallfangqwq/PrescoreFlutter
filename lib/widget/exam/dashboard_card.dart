import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../model/exam_model.dart';
import '../../util/struct.dart';

class DashboardCard extends StatefulWidget {
  final String examId;
  final double fullScore;
  final double userScore;
  final List<Paper> papers;
  const DashboardCard(
      {Key? key,
      required this.examId,
      required this.fullScore,
      required this.userScore,
      required this.papers})
      : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    Container infoCard = Container(
        padding: const EdgeInsets.all(12.0),
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            "得分：",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 12,
                          )
                        ],
                      ),
                      Text(
                        "${widget.userScore}",
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            "/",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 12,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.fullScore}",
                        style: const TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 16,
            ),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: widget.userScore / widget.fullScore,
              backgroundColor: Colors.grey,
              linearGradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.lightBlue, Colors.blue],
              ),
              barRadius: const Radius.circular(4),
            ),
          ],
        ));

    List<Widget> children = [
      Card(
        margin: const EdgeInsets.all(12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 8,
        child: infoCard,
      ),
    ];

    if (Provider.of<ExamModel>(context, listen: false).isDiagLoaded) {
      Widget chart = DashboardChart(
          papers: widget.papers, diagnoses: Provider.of<ExamModel>(context, listen: false).diagnoses);
      children.add(chart);
    } else {
      FutureBuilder futureBuilder = FutureBuilder(
        future: Provider.of<ExamModel>(context, listen: false)
            .user
            .fetchPaperDiagnosis(widget.examId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["state"]) {
              return DashboardChart(
                  papers: widget.papers, diagnoses: snapshot.data["result"]);
            } else {
              return Container();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );

      children.add(futureBuilder);
    }

    ListView listView = ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: false,
      children: children,
    );

    return Expanded(child: listView);
  }
}

class DashboardChart extends StatelessWidget {
  final List<Paper> papers;
  final List<PaperDiagnosis> diagnoses;
  const DashboardChart(
      {Key? key, required this.papers, required this.diagnoses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (diagnoses.length >= 3) {
      Container chartCard = Container(
          padding: const EdgeInsets.all(12.0),
          alignment: AlignmentDirectional.center,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        entryRadius: 3,
                        dataEntries: diagnoses
                            .map((e) => RadarEntry(value: e.diagnosticScore))
                            .toList(),
                      ),
                      RadarDataSet(
                        entryRadius: 0,
                        dataEntries: List.filled(
                            papers.length, const RadarEntry(value: 100)),
                        fillColor: Colors.transparent,
                        borderColor: Colors.transparent,
                      )
                    ],
                    tickCount: 3,
                    radarBorderData: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    tickBorderData: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    gridBorderData: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    radarShape: RadarShape.polygon,
                    getTitle: (index, angle) {
                      return RadarChartTitle(text: papers[index].name);
                    },
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
              const Text("这么巨！", style: TextStyle(fontSize: 16)),
            ],
          ));

      return Card(
        margin: const EdgeInsets.all(12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 8,
        child: chartCard,
      );
    } else {
      return Container();
    }
  }
}

/*
class DashboardCard extends StatelessWidget {
  final double fullScore;
  final double userScore;
  final List<Paper> papers;
  final List<PaperDiagnosis> diagnoses;

  const DashboardCard(
      {Key? key,
      required this.fullScore,
      required this.userScore,
      required this.papers,
      required this.diagnoses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  }
}
 */
