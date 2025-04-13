// lib/widgets/customer_list.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/customer_provider.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/screens/customer_details_screen.dart';
import 'package:rm_veriphy/screens/chat_webview_screen.dart';
import 'package:rm_veriphy/services/chat_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerList extends StatelessWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
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
                ElevatedButton(
                  onPressed: () => provider.loadCustomers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.customers.isEmpty) {
          return const Center(
            child: Text('No customers found'),
          );
        }

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: false, // Important!
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              final customer = provider.customers[index];
              return _CustomerCard(customer: customer);
            },
          ),
        );
      },
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const _CustomerCard({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDarkMode),
              const SizedBox(height: 8),
              _buildInfoSection(context, isDarkMode),
              const SizedBox(height: 12),
              _buildProgressIndicator(context, isDarkMode),
              const SizedBox(height: 12),
              _buildActionButtons(context, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            customer.userDetails.fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isDarkMode
                ? theme.primaryColor.withOpacity(0.2)
                : theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            customer.productInfo.productType,
            style: TextStyle(
              color: isDarkMode
                  ? theme.primaryColor.withOpacity(0.9)
                  : theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          'Product Amount:',
          'INR ${customer.productInfo.productAmount.toStringAsFixed(0)}',
        ),
        _buildInfoRow(
          context,
          'Documents:',
          '${customer.collectedDocuments}/${customer.requiredDocuments}',
        ),
        _buildInfoRow(
          context,
          'Case Age:',
          customer.ageing,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    return LinearProgressIndicator(
      value: customer.collectedDocuments / customer.requiredDocuments,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(
        isDarkMode ? theme.primaryColor.withOpacity(0.8) : theme.primaryColor,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildCallButton(context),
            _buildChatButton(context),
          ],
        ),
        _buildDetailsButton(context, isDarkMode),
      ],
    );
  }

  Widget _buildCallButton(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () => _handleCall(context),
      icon: const Icon(Icons.phone),
      label: const Text('Call'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: BorderSide(color: theme.primaryColor),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: () => _handleChat(context),
      icon: const Icon(Icons.message),
      label: const Text('Message'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context, bool isDarkMode) {
    return TextButton.icon(
      onPressed: () => _navigateToDetails(context),
      icon: Icon(
        Icons.arrow_forward,
        color: isDarkMode ? Colors.white70 : null,
      ),
      label: Text(
        'View Details',
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : null,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDarkMode ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCall(BuildContext context) async {
    // Get the phone number and do basic validation
    final rawPhone = customer.userDetails.phone;
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number available')),
      );
      return;
    }

    // First, clean the phone number of any non-numeric characters except +
    String phoneNumber = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

    // Print the phone number for debugging
    print('Original phone: $rawPhone');
    print('Cleaned phone: $phoneNumber');

    // Make sure we have a properly formatted number
    if (!phoneNumber.startsWith('+')) {
      // Remove leading zeros if any
      phoneNumber = phoneNumber.replaceAll(RegExp(r'^0+'), '');

      // Check if it already has country code (91)
      if (phoneNumber.startsWith('91')) {
        phoneNumber = '+$phoneNumber';
      } else {
        phoneNumber = '+91$phoneNumber';
      }
    }

    // Print the final formatted number
    print('Formatted phone: $phoneNumber');

    try {
      // Create the phone call URL
      final String urlString = 'tel:$phoneNumber';
      final Uri phoneUri = Uri.parse(urlString);

      print('Attempting to launch: $urlString');

      // First check if we can launch
      if (await canLaunchUrl(phoneUri)) {
        // Try to launch the URL
        final bool launched = await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to launch dialer for: $phoneNumber'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot launch phone dialer for: $phoneNumber'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Error launching phone call: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleChat(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final chatService = context.read<ChatService>();
      final conversationId = await chatService.getConversationId(
        customer.userDetails.id,
      );

      if (context.mounted) {
        Navigator.pop(context);
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(customer: customer),
      ),
    );
  }
}
