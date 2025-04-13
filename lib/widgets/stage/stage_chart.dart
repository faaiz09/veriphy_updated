// lib/widgets/stage/stage_chart.dart

import 'package:flutter/material.dart';
// import 'package:rm_veriphy/models/dashboard/dashboard_data.dart';
import 'package:rm_veriphy/models/stage/stage_data.dart';
import 'package:fl_chart/fl_chart.dart';

class StageChart extends StatelessWidget {
  final StageData stageData;

  const StageChart({
    super.key,
    required this.stageData,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxValue() * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 8,
            tooltipBorder: const BorderSide(color: Colors.blueGrey),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              String stage = _getStageNameByIndex(groupIndex);
              return BarTooltipItem(
                '$stage\n${rod.toY.toInt()}',
                const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _getBottomTitles,
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: _getMaxValue() / 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  String _getStageNameByIndex(int index) {
    switch (index) {
      case 0:
        return 'JumpStart';
      case 1:
        return 'In Progress';
      case 2:
        return 'Review';
      case 3:
        return 'Approved';
      case 4:
        return 'Sign & Pay';
      case 5:
        return 'Completed';
      default:
        return '';
    }
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JS';
        break;
      case 1:
        text = 'IP';
        break;
      case 2:
        text = 'RV';
        break;
      case 3:
        text = 'AP';
        break;
      case 4:
        text = 'SP';
        break;
      case 5:
        text = 'CP';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return [
      _makeBarGroup(0, stageData.jumpStart, Colors.blue),
      _makeBarGroup(1, stageData.inProgress, Colors.orange),
      _makeBarGroup(2, stageData.review, Colors.purple),
      _makeBarGroup(3, stageData.approved, Colors.green),
      _makeBarGroup(4, stageData.signAndPay, Colors.red),
      _makeBarGroup(5, stageData.completed, Colors.teal),
    ];
  }

  BarChartGroupData _makeBarGroup(int x, int y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: color,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  double _getMaxValue() {
    return [
      stageData.jumpStart,
      stageData.inProgress,
      stageData.review,
      stageData.approved,
      stageData.signAndPay,
      stageData.completed,
    ].reduce((max, value) => value > max ? value : max).toDouble();
  }
}
