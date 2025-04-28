//lib/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/dashboard_provider.dart';
import 'package:rm_veriphy/providers/customer_provider.dart';
import 'package:rm_veriphy/widgets/customer_list.dart';
import 'package:rm_veriphy/widgets/mtd_summary_chart.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isInitialized = false;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedProductType;
  String? _selectedStatus;
  String? _selectedAgeing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadInitialData();
      _isInitialized = true;
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    final dashboardProvider = context.read<DashboardProvider>();
    final customerProvider = context.read<CustomerProvider>();

    await Future.wait([
      dashboardProvider.loadDashboard(),
      customerProvider.loadCustomers(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Fixed content that scrolls with list
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDashboardSection(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                if (_hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildActiveFilters(),
                  ),
              ],
            ),
          ),

          // Customer list takes remaining space
          const Expanded(
            child: CustomerList(),
          ),
        ],
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedProductType != null ||
      _selectedStatus != null ||
      _selectedAgeing != null;

  Widget _buildDashboardSection() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final data = provider.dashboardData;

        if (data == null) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final chartData = {
          'Jumpstart': ChartData(
            label: 'Jumpstart',
            value: data.jumpStartCount,
            color: const Color(0xFFFF69B4),
          ),
          'In Progress': ChartData(
            label: 'In Progress',
            value: data.inProgressCount,
            color: const Color(0xFF4A90E2),
          ),
          'Review': ChartData(
            label: 'Review',
            value: data.reviewCount,
            color: const Color(0xFFFFA500),
          ),
          'Approved': ChartData(
            label: 'Approved',
            value: data.approvedCount,
            color: const Color(0xFF90EE90),
          ),
          'Sign & Pay': ChartData(
            label: 'Sign & Pay',
            value: data.signAndPayCount,
            color: const Color(0xFF9370DB),
          ),
        };

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MTD Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'INR ${(data.totalProductAmount / 1000).toStringAsFixed(0)}k Revenue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.completedCount} Policies Issued',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary.withAlpha(179),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CustomPaint(
                        painter: PieChartPainter(chartData),
                        child: Center(
                          child: Text(
                            chartData.values
                                .fold<int>(0, (sum, item) => sum + item.value)
                                .toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: chartData.entries.map((entry) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: entry.value.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${entry.value.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search customer name or Application ID',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterBottomSheet,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[100],
      ),
      onChanged: (value) {
        // TODO: Implement search functionality
      },
    );
  }

  Widget _buildActiveFilters() {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedProductType != null)
            _buildFilterChip(
              label: 'Product: $_selectedProductType',
              onDeleted: () {
                setState(() => _selectedProductType = null);
                _applyFilters();
              },
            ),
          if (_selectedStatus != null)
            _buildFilterChip(
              label: 'Status: $_selectedStatus',
              onDeleted: () {
                setState(() => _selectedStatus = null);
                _applyFilters();
              },
            ),
          if (_selectedAgeing != null)
            _buildFilterChip(
              label: 'Ageing: $_selectedAgeing',
              onDeleted: () {
                setState(() => _selectedAgeing = null);
                _applyFilters();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        onDeleted: onDeleted,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Theme.of(context).primaryColor.withAlpha(26),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Customers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Product Type',
                value: _selectedProductType,
                items: const ['Term Insurance', 'ULIP', 'Health Insurance'],
                onChanged: (value) =>
                    setState(() => _selectedProductType = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Status',
                value: _selectedStatus,
                items: const ['New', 'In Progress', 'Completed'],
                onChanged: (value) => setState(() => _selectedStatus = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Ageing',
                value: _selectedAgeing,
                items: const ['0-30 days', '30-60 days', '60+ days'],
                onChanged: (value) => setState(() => _selectedAgeing = value),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedProductType = null;
                          _selectedStatus = null;
                          _selectedAgeing = null;
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _applyFilters() {
    context.read<CustomerProvider>().filterCustomers(
          productType: _selectedProductType,
          status: _selectedStatus,
          ageing: _selectedAgeing,
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
