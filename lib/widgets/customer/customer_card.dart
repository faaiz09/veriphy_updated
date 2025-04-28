// lib/widgets/customer/customer_card.dart

import 'package:flutter/material.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/screens/customer_details_screen.dart';
// import 'package:timeago/timeago.dart' as timeago;

class CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const CustomerCard({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDetailsScreen(customer: customer),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildProductInfo(context),
              const SizedBox(height: 16),
              _buildProgressSection(context),
              if (customer.source != null || customer.region != null)
                _buildAdditionalInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.userDetails.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customer.userDetails.phone,
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (customer.userDetails.age != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Age: ${customer.userDetails.age}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
        _buildStatusBadge(context),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(customer.stageState).withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        customer.stageState,
        style: TextStyle(
          color: _getStatusColor(customer.stageState),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.productInfo.productName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    customer.productInfo.productType,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'INR ${customer.productInfo.productAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (customer.productInfo.productAnnualPremium != '0')
                  Text(
                    'Premium: ${customer.productInfo.productAnnualPremium}/yr',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progress = customer.collectedDocuments / customer.requiredDocuments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Documents: ${customer.collectedDocuments}/${customer.requiredDocuments}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Ageing: ${customer.ageing}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress == 1 ? Colors.green : Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (customer.source != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Source: ${customer.source}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
          if (customer.region != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Region: ${customer.region}',
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'jumpstart':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'review':
        return Colors.purple;
      case 'approved':
        return Colors.green;
      case 'sign & pay':
        return Colors.red;
      case 'completed':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
