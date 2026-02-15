import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Recoverienchart extends StatelessWidget {
  final List<double> recoveredData;
  final List<double> dueData;

  const Recoverienchart({
    super.key,
    required this.recoveredData,
    required this.dueData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // ✅ Y-Axis (Left)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                  );
                },
              ),
            ),

            // ✅ X-Axis
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  const labels = [
                    '10%', '20%', '30%', '40%', '50%',
                    '60%', '70%', '80%', '90%', '100%'
                  ];
                  return Text(
                    labels[value.toInt() % labels.length],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ Two bars per group (Recovered vs Due)
          barGroups: List.generate(recoveredData.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                // Recovered bar
                BarChartRodData(
                  toY: recoveredData[index],
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreenAccent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                // Due bar
                BarChartRodData(
                  toY: dueData[index],
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.orange],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 4,
            );
          }),
        ),
      ),
    );
  }
}
