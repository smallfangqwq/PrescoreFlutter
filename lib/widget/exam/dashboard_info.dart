import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'dart:math' as math;

class DashboardInfo extends StatelessWidget {
  final double userScore;
  final double fullScore;
  final double? assignScore;
  const DashboardInfo(
      {Key? key, required this.userScore, required this.fullScore, this.assignScore})
      : super(key: key);

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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                        "$userScore",
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                        "$fullScore",
                        style: const TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                )),
            Builder(builder: (BuildContext ctx) {
              if (assignScore != null) {
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "赋分得分：",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                          Text(
                            "$assignScore",
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                            "$fullScore",
                            style: const TextStyle(fontSize: 48),
                          ),
                        ],
                      ),
                    ));
              } else {
                return Container();
              }
            }),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment(userScore / fullScore * 2 - 1, 0),
              child: Column(
                children: [
                  Transform.rotate(
                    angle: (userScore / fullScore < 0.6) ? -math.pi / 5 : 0,
                    child: SvgPicture.asset(
                      "assets/running_person.svg",
                      height: 32,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/triangle_down_fill.svg",
                    height: 8,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: userScore / fullScore,
                    backgroundColor: Colors.grey,
                    linearGradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.lightBlue,
                        Colors.blue
                      ],
                    ),
                    barRadius: const Radius.circular(4),
                  ),
                  const Align(
                    alignment: Alignment(0.7, 0),
                    child: VerticalDivider(
                      width: 4,
                      thickness: 4,
                      color: Colors.grey,
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0.4, 0),
                    child: VerticalDivider(
                      width: 4,
                      thickness: 4,
                      color: Colors.grey,
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0.2, 0),
                    child: VerticalDivider(
                      width: 4,
                      thickness: 4,
                      color: Colors.grey,
                    ),
                  ),
                  const Align(
                    alignment: Alignment(-0.2, 0),
                    child: VerticalDivider(
                      width: 4,
                      thickness: 4,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));

    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: infoCard,
    );
  }
}
