// lib/models/document/document_type.dart
class DocumentType {
  final String id;
  final String name;
  final String description;
  final List<String> allowedExtensions;
  final int maxSizeInMB;
  final bool isRequired;
  final List<String> validationRules;

  const DocumentType({
    required this.id,
    required this.name,
    required this.description,
    required this.allowedExtensions,
    this.maxSizeInMB = 5,
    this.isRequired = true,
    this.validationRules = const [],
  });

  static const List<DocumentType> defaultTypes = [
    DocumentType(
      id: 'aadhar',
      name: 'Aadhaar Card',
      description: 'Government issued 12-digit unique identity number',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'Both sides required',
        'Should not be expired',
      ],
    ),
    DocumentType(
      id: 'pan',
      name: 'PAN Card',
      description: 'Permanent Account Number card',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'Should not be expired',
      ],
    ),
    DocumentType(
      id: 'driving_license',
      name: 'Driving License',
      description: 'Valid driving license',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'Both sides required',
        'Should be valid and not expired',
      ],
    ),
    DocumentType(
      id: 'passport',
      name: 'Passport',
      description: 'Valid passport',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'First and last page required',
        'Should be valid and not expired',
      ],
    ),
    DocumentType(
      id: 'bank_statement',
      name: 'Bank Statement',
      description: 'Last 6 months bank statement',
      allowedExtensions: ['pdf'],
      validationRules: [
        'Must be clearly visible',
        'Should be last 6 months',
        'All pages must be included',
      ],
    ),
    DocumentType(
      id: 'address_proof',
      name: 'Address Proof',
      description: 'Valid address proof document',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'Should be recent (within last 3 months)',
      ],
    ),
    DocumentType(
      id: 'income_proof',
      name: 'Income Proof',
      description: 'Valid income proof document',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      validationRules: [
        'Must be clearly visible',
        'Should be latest',
      ],
    ),
    DocumentType(
      id: 'photo',
      name: 'Photo ID',
      description: 'Recent passport size photograph',
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      maxSizeInMB: 2,
      validationRules: [
        'Must be clearly visible',
        'Should be recent',
        'White background preferred',
      ],
    ),
  ];

  bool isValidExtension(String extension) {
    return allowedExtensions.contains(extension.toLowerCase());
  }

  bool isValidSize(int sizeInBytes) {
    return sizeInBytes <= (maxSizeInMB * 1024 * 1024);
  }

  static DocumentType? getById(String id) {
    try {
      return defaultTypes.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }

  static DocumentType? getByName(String name) {
    try {
      return defaultTypes.firstWhere(
        (type) => type.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
