import 'package:flutter/material.dart';

class MonthlyDividendsChart extends StatelessWidget {
  final List<double> monthlyDividends;
  
  const MonthlyDividendsChart({
    super.key,
    required this.monthlyDividends,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 300,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  //           child: BarChart(
  //             BarChartData(
  //               alignment: BarChartAlignment.spaceAround,
  //               maxY: monthlyDividends.reduce((a, b) => a > b ? a : b) * 1.2,
  //               groupsSpace: 12,
  //               gridData: FlGridData(show: false),
  //               titlesData: FlTitlesData(
  //                 leftTitles: AxisTitles(
  //                   sideTitles: SideTitles(showTitles: false),
  //                 ),
  //                 bottomTitles: AxisTitles(
  //                   sideTitles: SideTitles(
  //                     showTitles: true,
  //                     reservedSize: 30,
  //                     getTitlesWidget: (value, meta) {
  //                       const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //                                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  //                       return Padding(
  //                         padding: const EdgeInsets.only(top: 8.0),
  //                         child: Text(
  //                           months[value.toInt()],
  //                           style: const TextStyle(fontSize: 12),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //                 topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //               ),
  //               borderData: FlBorderData(show: false),
  //               barGroups: monthlyDividends.asMap().entries.map((entry) {
  //                 return BarChartGroupData(
  //                   x: entry.key,
  //                   barRods: [
  //                     BarChartRodData(
  //                       toY: entry.value,
  //                       color: Theme.of(context).primaryColor,
  //                       width: 16,
  //                       borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
  //                     ),
  //                   ],
  //                 );
  //               }).toList(),
  //               barTouchData: BarTouchData(
  //                 enabled: true,
  //                 touchTooltipData: BarTouchTooltipData(
  //                   tooltipRoundedRadius: 8,
  //                   tooltipBorder: BorderSide(
  //                     color: Colors.grey.shade300,
  //                     width: 1,
  //                   ),
  //                   tooltipPadding: const EdgeInsets.all(8),
  //                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
  //                     return BarTooltipItem(
  //                       '\$${rod.toY.toStringAsFixed(2)}',
  //                       TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  }
