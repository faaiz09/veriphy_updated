//lib/widgets/document_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/document_provider.dart';
import 'package:rm_veriphy/models/document/document_info.dart';
import 'package:rm_veriphy/screens/document_review_screen.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load image: ${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentPreviewDialog extends StatelessWidget {
  final DocumentFile file;

  const DocumentPreviewDialog({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(file.name),
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrl: file.documentKey,
                          title: file.name,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  file.documentKey,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error_outline, size: 48),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
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
                  onPressed: () => provider.loadUserDocuments(
                    provider.userInfo?.userDetails.id ?? '',
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildProgressHeader(context, provider),
            Expanded(
              child: ListView.builder(
                itemCount: provider.requiredDocuments.length,
                itemBuilder: (context, index) {
                  final document = provider.requiredDocuments[index];
                  return DocumentCard(
                    document: document,
                    files: provider.getDocumentsForType(document.documentName),
                    isVerified:
                        provider.isDocumentVerified(document.documentName),
                    userId: provider.userInfo?.userDetails.id ?? '',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressHeader(BuildContext context, DocumentProvider provider) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final percentage = provider.documentCompletionPercentage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? theme.cardColor : theme.primaryColor.withAlpha(26),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Document Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? null : theme.primaryColor,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? null : theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ],
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final UserDocument document;
  final List<DocumentFile> files;
  final bool isVerified;
  final String userId;

  const DocumentCard({
    super.key,
    required this.document,
    required this.files,
    required this.isVerified,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          document.documentName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          isVerified
              ? 'Verified'
              : files.isEmpty
                  ? 'Not Uploaded'
                  : 'Pending Verification',
          style: TextStyle(
            color: isVerified ? Colors.green : Colors.orange,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isVerified ? Icons.check_circle : Icons.description,
            color: isVerified ? Colors.green : theme.primaryColor,
          ),
        ),
        children: [
          if (files.isNotEmpty)
            ...files.map((file) => _buildFileItem(context, file)),
        ],
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, DocumentFile file) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        _getFileIcon(file.extension),
        color: theme.primaryColor,
      ),
      title: Text(file.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Size: ${_formatFileSize(file.size)}'),
          Text(
            'Status: ${file.verificationStatus}',
            style: TextStyle(
              color: file.verificationStatus.toLowerCase() == 'verified'
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () => _showDocumentPreview(context, file),
            tooltip: 'View Document',
          ),
          if (file.verificationStatus.toLowerCase() != 'verified')
            IconButton(
              icon: const Icon(Icons.rate_review),
              onPressed: () => _openDocumentReview(context, file),
              tooltip: 'Review Document',
            ),
        ],
      ),
    );
  }

  void _showDocumentPreview(BuildContext context, DocumentFile file) {
    showDialog(
      context: context,
      builder: (context) => DocumentPreviewDialog(file: file),
    );
  }

  void _openDocumentReview(BuildContext context, DocumentFile file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentReviewScreen(
          userId: userId,
          document: file,
          documentName: document.documentName,
        ),
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
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
