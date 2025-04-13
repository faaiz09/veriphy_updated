// lib/screens/customer_details_screen.dart
// ignore_for_file: library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/providers/customer_provider.dart';
import 'package:rm_veriphy/providers/activity_provider.dart';
// import 'package:rm_veriphy/screens/activity_timeline_screen.dart';
import 'package:intl/intl.dart';
import 'package:rm_veriphy/screens/activity_timeline_screen.dart';
import 'package:rm_veriphy/widgets/dialogs/stage_selection_dialog.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerData customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().loadUserActivity(
            widget.customer.userDetails.id,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.customer.userDetails.fullName),
            Text(
              widget.customer.productInfo.productType,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Product'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProductTab(),
          _buildActivityTab(),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handleProcessAction('initiate', 'Are you sure you want to initiate the process?'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Initiate'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showStageSelection(),
                icon: const Icon(Icons.edit),
                label: const Text('Update Stage'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTab() {
    final product = widget.customer.productInfo;
    final formatCurrency = NumberFormat.currency(
      symbol: 'INR ',
      decimalDigits: 0,
      locale: 'en_IN',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Product Details',
            [
              _buildInfoRow('Product Name', product.productName),
              _buildInfoRow('Product Type', product.productType),
              _buildInfoRow(
                'Product Amount',
                formatCurrency.format(product.productAmount),
              ),
              _buildInfoRow(
                'Annual Premium',
                product.productAnnualPremium != '0'
                    ? formatCurrency
                        .format(double.parse(product.productAnnualPremium))
                    : 'N/A',
              ),
              _buildInfoRow('Tenure', '${product.productTenure} years'),
              _buildInfoRow(
                'Interest Rate',
                product.interestRate > 0
                    ? '${product.interestRate.toStringAsFixed(2)}%'
                    : 'N/A',
              ),
              _buildInfoRow('Profit Category', product.productProfit),
              if (product.channelSource != null)
                _buildInfoRow('Channel Source', product.channelSource!),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Additional Details',
            [
              _buildInfoRow(
                'Eligibility Amount',
                product.eligibilityAmount > 0
                    ? formatCurrency.format(product.eligibilityAmount)
                    : 'N/A',
              ),
              _buildInfoRow(
                'EMI Amount',
                product.emiAmount > 0
                    ? formatCurrency.format(product.emiAmount)
                    : 'N/A',
              ),
              _buildInfoRow(
                'Sanction Letter',
                product.isSanctionLetterGenerated == '1'
                    ? 'Generated'
                    : 'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildCustomerInfo() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildInfoSection(
  //           'Personal Information',
  //           [
  //             _buildInfoRow(
  //               'Name',
  //               widget.customer.userDetails.fullName,
  //               Icons.person,
  //             ),
  //             _buildInfoRow(
  //               'Email',
  //               widget.customer.userDetails.email,
  //               Icons.email,
  //             ),
  //             _buildInfoRow(
  //               'Phone',
  //               widget.customer.userDetails.phone,
  //               Icons.phone,
  //             ),
  //             _buildInfoRow(
  //               'Address',
  //               widget.customer.userDetails.address,
  //               Icons.location_on,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildInfoSection(
  //           'Loan Details',
  //           [
  //             _buildInfoRow(
  //               'Product Type',
  //               widget.customer.productType,
  //               Icons.account_balance,
  //             ),
  //             _buildInfoRow(
  //               'Loan Amount',
  //               'INR ${widget.customer.loanAmount.toStringAsFixed(0)}',
  //               Icons.attach_money,
  //             ),
  //             if (widget.customer.emiAmount > 0)
  //               _buildInfoRow(
  //                 'EMI Amount',
  //                 'INR ${widget.customer.emiAmount.toStringAsFixed(0)}',
  //                 Icons.calendar_today,
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Timeline',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityTimelineScreen(
                        userId: widget.customer.userDetails.id,
                        userName:
                            widget.customer.userDetails.fullName,
                      ),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<ActivityProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.activities.isEmpty) {
                return Center(
                  child: Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }

              // Show latest 3 activities only
              final recentActivities = provider.activities.take(3).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  return ActivityTimelineItem(
                    activity: recentActivities[index],
                    isLast: index == recentActivities.length - 1,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProcessActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Process Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                'Initiate',
                Icons.play_arrow,
                'initiate',
                'Are you sure you want to initiate the process?',
                isPrimary: true,
              ),
              _buildActionButton(
                'Reinitiate',
                Icons.refresh,
                'reinitiate',
                'Are you sure you want to reinitiate the process?',
                isPrimary: true,
              ),
              _buildActionButton(
                'Complete',
                Icons.check,
                'complete',
                'Are you sure you want to complete the process?',
                isPrimary: true,
              ),
              _buildActionButton(
                'Reset',
                Icons.restart_alt,
                'reset',
                'Are you sure you want to reset this customer?\nThis action cannot be undone.',
                isDangerous: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    String action,
    String confirmMessage, {
    bool isPrimary = false,
    bool isDangerous = false,
  }) {
    final ButtonStyle style = isDangerous
        ? OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          )
        : isPrimary
            ? ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              )
            : OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              );

    final Widget button = isPrimary
        ? ElevatedButton.icon(
            onPressed: () => _handleProcessAction(action, confirmMessage,
                isDangerous: isDangerous),
            icon: Icon(icon),
            label: Text(label),
            style: style,
          )
        : OutlinedButton.icon(
            onPressed: () => _handleProcessAction(action, confirmMessage,
                isDangerous: isDangerous),
            icon: Icon(icon),
            label: Text(label),
            style: style,
          );

    return button;
  }

  Future<void> _handleProcessAction(
    String action,
    String confirmationMessage, {
    bool isDangerous = false
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isDangerous ? 'Warning' : 'Confirm Action'),
        content: Text(confirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final customerProvider = context.read<CustomerProvider>();

    try {
      switch (action) {
        case 'initiate':
          await customerProvider
              .initiateProcess(widget.customer.userDetails.id);
          break;
        case 'reinitiate':
          await customerProvider
              .reinitiateProcess(widget.customer.userDetails.id);
          break;
        case 'complete':
          await customerProvider
              .completeProcess(widget.customer.userDetails.id);
          break;
        case 'reset':
          await customerProvider
              .resetCustomer(widget.customer.userDetails.id);
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Process ${action}d successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showStageSelection() async {
    final newStage = await showDialog<String>(
      context: context,
      builder: (context) => StageSelectionDialog(
        currentStage: widget.customer.stageState,
      ),
    );

    if (newStage != null && mounted) {
      try {
        await context.read<CustomerProvider>().updateCustomerStage(
              userId: widget.customer.userDetails.id,
              stageName: newStage,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stage updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Personal Information',
            [
              _buildInfoRow('Full Name', widget.customer.userDetails.fullName),
              _buildInfoRow('Email', widget.customer.userDetails.email),
              _buildInfoRow('Phone', widget.customer.userDetails.phone),
              _buildInfoRow('Address', widget.customer.userDetails.address),
              _buildInfoRow('City', widget.customer.userDetails.city),
              _buildInfoRow('State', widget.customer.userDetails.state),
              _buildInfoRow(
                  'Postal Code', widget.customer.userDetails.postalCode),
              _buildInfoRow('Country', widget.customer.userDetails.country),
              if (widget.customer.userDetails.dob != null)
                _buildInfoRow(
                    'Date of Birth', widget.customer.userDetails.dob!),
              if (widget.customer.userDetails.age != null)
                _buildInfoRow('Age', widget.customer.userDetails.age!),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Status Information',
            [
              _buildInfoRow('Stage', widget.customer.stageState),
              _buildInfoRow('Status', widget.customer.userDetails.status),
              _buildInfoRow('Ageing', widget.customer.ageing),
              _buildInfoRow('Region', widget.customer.region ?? 'N/A'),
              _buildInfoRow('Source', widget.customer.source ?? 'N/A'),
              _buildInfoRow(
                'Created At',
                DateFormat('MMM dd, yyyy HH:mm')
                    .format(widget.customer.userDetails.creationDate),
              ),
              _buildInfoRow(
                'Last Updated',
                DateFormat('MMM dd, yyyy HH:mm')
                    .format(widget.customer.userDetails.updatedAt),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDocumentProgress(),
        ],
      ),
    );
  }

  Widget _buildDocumentProgress() {
    final progress =
        widget.customer.collectedDocuments / widget.customer.requiredDocuments;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.customer.collectedDocuments}/${widget.customer.requiredDocuments} Documents',
                ),
                Text('${(progress * 100).toStringAsFixed(0)}%'),
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
        ),
      ),
    );
  }

  // Widget _buildSection({
  //   required String title,
  //   required List<Widget> children,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             children: children,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildInfoTile({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  // }) {
  //   final theme = Theme.of(context);
  //   final isDarkMode = theme.brightness == Brightness.dark;

  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: isDarkMode
  //                 ? Colors.grey[900]
  //                 : theme.primaryColor.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(
  //             icon,
  //             color: theme.primaryColor,
  //             size: 20,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 value,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActivityTab() {
    return Consumer<ActivityProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.activities.isEmpty) {
          return const Center(child: Text('No activity history available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.activities.length,
          itemBuilder: (context, index) {
            final activity = provider.activities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(activity.activity),
                subtitle: Text(activity.description),
                trailing: Text(
                  DateFormat('MMM dd, HH:mm').format(activity.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
