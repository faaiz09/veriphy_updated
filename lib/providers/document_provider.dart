// lib/providers/document_provider.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/models/document/document_info.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';

class DocumentProvider with ChangeNotifier {
  final ApiService _apiService;
  CustomerData? _userInfo;  // Changed from UserLoanInfo to CustomerData
  List<UserDocument> _requiredDocuments = [];
  List<DocumentInfo> _availableDocuments = [];
  Map<String, List<DocumentFile>> _folderFiles = {};
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;

  DocumentProvider(this._apiService);

  // Getters
  CustomerData? get userInfo => _userInfo;  // Changed return type
  List<UserDocument> get requiredDocuments => List.unmodifiable(_requiredDocuments);
  List<DocumentInfo> get availableDocuments => List.unmodifiable(_availableDocuments);
  Map<String, List<DocumentFile>> get folderFiles => Map.unmodifiable(_folderFiles);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserId => _currentUserId;

  Future<void> loadUserDocuments(String userId) async {
    if (userId.isEmpty) {
      _error = 'Invalid user ID';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      _currentUserId = userId;
      notifyListeners();

      final data = await _apiService.getUserAndDocInfo(userId);

      _userInfo = data['userLoanInfo'] as CustomerData?;
      _requiredDocuments =
          (data['requiredDocuments'] as List<UserDocument>?) ?? [];
      _availableDocuments = (data['documentList'] as List<DocumentInfo>?) ?? [];
      _folderFiles =
          (data['folderFiles'] as Map<String, List<DocumentFile>>?) ?? {};

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DocumentFile> getDocumentsForType(String documentType) {
    return _folderFiles.values
        .expand((files) => files)
        .where((file) => file.fileType == documentType)
        .toList();
  }

  bool isDocumentVerified(String documentType) {
    return getDocumentsForType(documentType)
        .any((file) => file.verificationStatus.toLowerCase() == 'verified');
  }

  double get documentCompletionPercentage {
    if (_requiredDocuments.isEmpty) return 0;
    final verifiedCount = _requiredDocuments
        .where((doc) => isDocumentVerified(doc.documentName))
        .length;
    return (verifiedCount / _requiredDocuments.length) * 100;
  }

  Future<void> updateDocumentStatus(
    DocumentFile document, {
    required String documentType,
    String? rejectReason,
    String? rejectionMessage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get the updated file data after status change
      final result = await _apiService.tagDocument(
        userId: _currentUserId!,
        documentId: document.id,
        documentType: documentType,
        rejectReason: rejectReason,
        rejectionMessage: rejectionMessage,
      );

      // Reload documents to get updated status
      await loadUserDocuments(_currentUserId!);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNewDocument(String documentName) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _apiService.tagDocument(
        userId: _currentUserId!,
        documentId: "new",
        documentType: documentName,
      );

      await loadUserDocuments(_currentUserId!);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refreshDocuments() async {
    if (_currentUserId != null) {
      await loadUserDocuments(_currentUserId!);
    }
  }

  @override
  void dispose() {
    _currentUserId = null;
    super.dispose();
  }
}
