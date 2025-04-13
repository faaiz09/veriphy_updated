// lib/widgets/mtd_summary_card.dart
import 'package:flutter/material.dart';
import 'package:rm_veriphy/models/mtd_summary.dart';
import 'package:rm_veriphy/widgets/summary_item.dart';

class MTDSummaryCard extends StatelessWidget {
  final MTDSummary summary;
  final VoidCallback? onMorePressed;

  const MTDSummaryCard({
    super.key,
    required this.summary,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MTD Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: onMorePressed,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SummaryItem(
              value: '${summary.premiumRevenue / 1000}k',
              label: 'Premium Revenue',
            ),
            const SizedBox(height: 8),
            SummaryItem(
              value: '${summary.policiesIssued}',
              label: 'Policies Issued',
            ),
            const SizedBox(height: 8),
            SummaryItem(
              value: '${summary.tatPercentage}%',
              label: 'within TAT',
            ),
          ],
        ),
      ),
    );
  }
}
