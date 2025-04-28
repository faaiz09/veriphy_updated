// lib/screens/document_review_screen.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/models/document/document_info.dart';
import 'package:rm_veriphy/services/document_service.dart';
import 'package:rm_veriphy/utils/error_utils.dart';

class DocumentReviewScreen extends StatefulWidget {
  final String userId;
  final DocumentFile document;
  final String documentName;

  const DocumentReviewScreen({
    super.key,
    required this.userId,
    required this.document,
    required this.documentName,
  });

  @override
  State<DocumentReviewScreen> createState() => _DocumentReviewScreenState();
}

class _DocumentReviewScreenState extends State<DocumentReviewScreen> {
  String? selectedDocumentType;
  final TextEditingController _rejectionMessageController =
      TextEditingController();
  String? rejectionReason;
  bool _isLoading = false;

  // List of supported document types
  final List<String> documentTypes = [
    'Aadhaar Card',
    'PAN Card',
    'Driving License',
    'Passport',
    'Bank Statement',
    'Address Proof',
    'Income Proof',
    'Photo ID',
    'Other'
  ];

  // List of rejection reasons
  final List<String> rejectionReasons = [
    'Blurred Document',
    'Incorrect Document',
    'Partially Cut',
    'Invalid Format',
    'Poor Quality',
    'Expired Document',
    'Other'
  ];

  @override
  void dispose() {
    _rejectionMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${widget.documentName}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDocumentPreview(),
            _buildDocumentInfo(),
            _buildDocumentTypeSelector(),
            if (widget.document.verificationStatus.toLowerCase() != 'verified')
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(30)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.document.documentKey,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: Colors.grey.withAlpha(50)),
                const SizedBox(height: 16),
                Text('Failed to load document',
                    style: TextStyle(color: Colors.grey.withAlpha(70))),
              ],
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocumentInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('File Name:', widget.document.name),
          _buildInfoRow('Size:', _formatFileSize(widget.document.size)),
          _buildInfoRow('Type:', widget.document.fileType),
          _buildInfoRow('Status:', widget.document.verificationStatus),
          if (widget.document.rejectReason != null)
            _buildInfoRow('Reject Reason:', widget.document.rejectReason!),
        ],
      ),
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
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedDocumentType,
            decoration: InputDecoration(
              hintText: 'Select document type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: documentTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDocumentType = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _showRejectionDialog,
              icon: const Icon(Icons.close),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _handleDocumentAction(isApproval: true),
              icon: const Icon(Icons.check),
              label: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Approve'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select Rejection Reason'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: rejectionReasons.map((reason) {
              return ListTile(
                title: Text(reason),
                onTap: () {
                  Navigator.pop(context, reason);
                },
              );
            }).toList(),
          ),
        ),
      ),
    ).then((reason) {
      if (reason != null) {
        setState(() => rejectionReason = reason);
        _showRejectionMessageDialog();
      }
    });
  }

  void _showRejectionMessageDialog() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Reject ${widget.documentName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason: $rejectionReason',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _rejectionMessageController,
              decoration: InputDecoration(
                hintText: 'Add a message for the customer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject Document'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _handleDocumentAction(isApproval: false);
      }
    });
  }

  Future<void> _handleDocumentAction({required bool isApproval}) async {
    if (!isApproval && (rejectionReason == null || rejectionReason!.isEmpty)) {
      ErrorUtils.showError(context, 'Please select a rejection reason');
      return;
    }

    if (selectedDocumentType == null) {
      ErrorUtils.showError(context, 'Please select a document type');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<DocumentService>().tagDocument(
            userId: widget.userId,
            documentId: widget.document.id,
            documentType: selectedDocumentType!,
            rejectReason: isApproval ? null : rejectionReason,
            rejectionMessage:
                isApproval ? null : _rejectionMessageController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        _showSuccessDialog(
          isApproval
              ? 'Document approved successfully'
              : 'Document rejected successfully',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorUtils.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(String size) {
    final sizeInBytes = int.tryParse(size) ?? 0;
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}
