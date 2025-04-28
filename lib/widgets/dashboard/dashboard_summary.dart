// lib/widgets/dashboard/dashboard_summary.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/models/dashboard/dashboard_data.dart';
import 'package:rm_veriphy/providers/dashboard_provider.dart';
import 'package:rm_veriphy/widgets/stage/stage_chart.dart';
import 'package:rm_veriphy/models/stage/stage_data.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadDashboard(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.dashboardData == null) {
          return const Center(child: Text('No dashboard data available'));
        }

        final data = provider.dashboardData!;

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Performance Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildRevenueChip(data.totalProductAmount),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: _buildStageChart(data),
                ),
                const SizedBox(height: 24),
                _buildMetricsGrid(data),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStageChart(DashboardData data) {
    // Convert DashboardData to StageData
    final stageData = StageData(
      jumpStart: data.jumpStartCount,
      inProgress: data.inProgressCount,
      review: data.reviewCount,
      approved: data.approvedCount,
      signAndPay: data.signAndPayCount,
      submittedAllDocuments: 0, // Set default or get from data
      specialRequests: 0, // Set default or get from data
      uwDocumentRequest: 0, // Set default or get from data
      awaitingMedicalTests: 0, // Set default or get from data
      completed: data.completedCount,
    );

    return StageChart(stageData: stageData);
  }

  Widget _buildRevenueChip(double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'INR ${(amount / 100000).toStringAsFixed(1)}L Revenue',
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(DashboardData data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'JumpStart',
          data.jumpStartCount.toString(),
          Icons.rocket_launch,
          Colors.blue,
        ),
        _buildMetricCard(
          'In Progress',
          data.inProgressCount.toString(),
          Icons.trending_up,
          Colors.orange,
        ),
        _buildMetricCard(
          'Review',
          data.reviewCount.toString(),
          Icons.rate_review,
          Colors.purple,
        ),
        _buildMetricCard(
          'Approved',
          data.approvedCount.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildMetricCard(
          'Sign & Pay',
          data.signAndPayCount.toString(),
          Icons.paid,
          Colors.red,
        ),
        _buildMetricCard(
          'Completed',
          data.completedCount.toString(),
          Icons.task_alt,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
