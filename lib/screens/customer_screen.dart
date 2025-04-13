// lib/screens/customer_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/customer_provider.dart';
import 'package:rm_veriphy/widgets/customer_list.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedProductType;
  String? _selectedStatus;
  String? _selectedAgeing;

  @override
  void initState() {
    super.initState();
    // Load customers when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          if (_selectedProductType != null ||
              _selectedStatus != null ||
              _selectedAgeing != null)
            _buildActiveFilters(),
          const Expanded(
            child: CustomerList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new customer
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedProductType != null)
            _buildFilterChip(
              label: 'Product: $_selectedProductType',
              onDeleted: () {
                setState(() {
                  _selectedProductType = null;
                });
                _applyFilters();
              },
            ),
          if (_selectedStatus != null)
            _buildFilterChip(
              label: 'Status: $_selectedStatus',
              onDeleted: () {
                setState(() {
                  _selectedStatus = null;
                });
                _applyFilters();
              },
            ),
          if (_selectedAgeing != null)
            _buildFilterChip(
              label: 'Ageing: $_selectedAgeing',
              onDeleted: () {
                setState(() {
                  _selectedAgeing = null;
                });
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
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
        builder: (context, setState) => Container(
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
