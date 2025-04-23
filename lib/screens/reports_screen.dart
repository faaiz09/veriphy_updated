// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Reports & Analytics'),
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.share),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Metrics Grid
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MetricCard(title: "Documents Collected", value: "23"),
                _MetricCard(title: "This Week", value: "150"),
                _MetricCard(title: "This Month", value: "620"),
                _MetricCard(title: "Pending Escalations", value: "5"),
                _MetricCard(title: "Avg Turnaround Time", value: "2.1 hrs"),
              ],
            ),
            const SizedBox(height: 32),

            // Chart
            Text(
              "Documents Collected",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            "Sun",
                            "Mon",
                            "Tue",
                            "Wed",
                            "Thu",
                            "Fri",
                            "Sat"
                          ];
                          return Text(days[value.toInt() % days.length]);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    _barData(0, 14),
                    _barData(1, 17),
                    _barData(2, 23),
                    _barData(3, 21),
                    _barData(4, 0),
                    _barData(5, 18),
                    _barData(6, 13),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Leaderboard
            Text(
              "Team Leaderboard",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _LeaderboardItem(rank: 1, name: "Priya Agarwal"),
            const _LeaderboardItem(rank: 2, name: "Vivek Menon"),
            const _LeaderboardItem(rank: 3, name: "Akash Rana"),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _barData(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          width: 14,
          color: const Color(0xFFA7D222),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 4),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  )),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;

  const _LeaderboardItem({required this.rank, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text("$rank",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(width: 16),
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
