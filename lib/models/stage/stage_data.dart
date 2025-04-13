// lib/models/stage/stage_data.dart

class StageData {
  final int jumpStart;
  final int inProgress;
  final int review;
  final int approved;
  final int signAndPay;
  final int submittedAllDocuments;
  final int specialRequests;
  final int uwDocumentRequest;
  final int awaitingMedicalTests;
  final int completed;

  StageData({
    required this.jumpStart,
    required this.inProgress,
    required this.review,
    required this.approved,
    required this.signAndPay,
    required this.submittedAllDocuments,
    required this.specialRequests,
    required this.uwDocumentRequest,
    required this.awaitingMedicalTests,
    required this.completed,
  });

  factory StageData.fromJson(Map<String, dynamic> json) {
    return StageData(
      jumpStart: int.tryParse(json['JumpStart'] ?? '0') ?? 0,
      inProgress: int.tryParse(json['In Progress'] ?? '0') ?? 0,
      review: int.tryParse(json['Review'] ?? '0') ?? 0,
      approved: int.tryParse(json['Approved'] ?? '0') ?? 0,
      signAndPay: int.tryParse(json['Sign & Pay'] ?? '0') ?? 0,
      submittedAllDocuments:
          int.tryParse(json['Submitted All Documents'] ?? '0') ?? 0,
      specialRequests: int.tryParse(json['Special Requests'] ?? '0') ?? 0,
      uwDocumentRequest: int.tryParse(json['UW Document Request'] ?? '0') ?? 0,
      awaitingMedicalTests:
          int.tryParse(json['Awaiting Medical Tests'] ?? '0') ?? 0,
      completed: int.tryParse(json['Completed'] ?? '0') ?? 0,
    );
  }
}
