// lib/models/document/document_info.dart

class DocumentInfo {
  final String id;
  final String documentName;
  final String companyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentInfo({
    required this.id,
    required this.documentName,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) {
    return DocumentInfo(
      id: json['id']?.toString() ?? '',
      documentName: json['documentname']?.toString() ?? '',
      companyId: json['company']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class UserDocument {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final String documentId;
  final String documentName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDocument({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.documentId,
    required this.documentName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      id: json['id']?.toString() ?? '',
      userId: json['userid']?.toString() ?? '',
      productId: json['productid']?.toString() ?? '',
      productName: json['productname']?.toString() ?? '',
      documentId: json['documentid']?.toString() ?? '',
      documentName: json['documentname']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class DocumentFile {
  final String id;
  final String companyId;
  final String folderId;
  final String uploadedBy;
  final DateTime uploadedOn;
  final String name;
  final String filename;
  final String extension;
  final String size;
  final String documentKey;
  final String status;
  final String fileType;
  final String verificationStatus;
  final String? rejectReason;

  DocumentFile({
    required this.id,
    required this.companyId,
    required this.folderId,
    required this.uploadedBy,
    required this.uploadedOn,
    required this.name,
    required this.filename,
    required this.extension,
    required this.size,
    required this.documentKey,
    required this.status,
    required this.fileType,
    required this.verificationStatus,
    this.rejectReason,
  });

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      id: json['id']?.toString() ?? '',
      companyId: json['company']?.toString() ?? '',
      folderId: json['folder']?.toString() ?? '',
      uploadedBy: json['uploaded_by']?.toString() ?? '',
      uploadedOn:
          DateTime.tryParse(json['uploaded_on'] ?? '') ?? DateTime.now(),
      name: json['name']?.toString() ?? '',
      filename: json['filename']?.toString() ?? '',
      extension: json['extension']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      documentKey: json['document_key']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fileType: json['file_type']?.toString() ?? '',
      verificationStatus: json['verification_status']?.toString() ?? '',
      rejectReason: json['reason_of_reject']?.toString(),
    );
  }
}
