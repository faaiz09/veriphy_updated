// lib/widgets/case_card.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:rm_veriphy/widgets/aging_indicator.dart';
import 'package:rm_veriphy/widgets/status_badge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/screens/chat_webview_screen.dart';
import 'package:rm_veriphy/services/chat_service.dart';

class CaseCard extends StatelessWidget {
  final CustomerData customer;
  final VoidCallback? onTap;

  const CaseCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                          customer.userDetails.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          customer.userDetails.phone,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(type: customer.productInfo.productType),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loan Amount: ₹${customer.productInfo.productAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (customer.productInfo.emiAmount > 0)
                          Text(
                            'EMI: ₹${customer.productInfo.emiAmount.toStringAsFixed(0)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Documents: ${customer.collectedDocuments}/${customer.requiredDocuments}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      AgingIndicator(days: int.parse(customer.ageing)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCommunicationButton(
                    context,
                    icon: Icons.phone,
                    label: 'Call',
                    onPressed: () => _handleCall(context),
                    isOutlined: true,
                  ),
                  _buildCommunicationButton(
                    context,
                    icon: Icons.message,
                    label: 'Message',
                    onPressed: () => _handleMessage(context),
                    isOutlined: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          side: BorderSide(color: theme.primaryColor),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Future<void> _handleCall(BuildContext context) async {
    final phoneNumber = customer.userDetails.phone;
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number not available')),
      );
      return;
    }

    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (!formattedNumber.startsWith('+')) {
      formattedNumber = formattedNumber.startsWith('91')
          ? '+$formattedNumber'
          : '+91$formattedNumber';
    }

    final uri = Uri.parse('tel:$formattedNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not initiate call')),
        );
      }
    }
  }

  Future<void> _handleMessage(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final chatService = ChatService();
      final conversationId = await chatService.getConversationId(
        customer.userDetails.id,
      );

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWebViewScreen(
              userName: customer.userDetails.fullName,
              conversationId: conversationId,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
