// lib/models/case.dart
class Case {
  final String id;
  final String name;
  final String type;
  final String appId;
  final double premium;
  final int ageingDays;
  final String status;

  Case({
    required this.id,
    required this.name,
    required this.type,
    required this.appId,
    required this.premium,
    required this.ageingDays,
    required this.status,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      appId: json['appId']?.toString() ?? '',
      premium: double.tryParse(json['premium']?.toString() ?? '0') ?? 0.0,
      ageingDays: int.tryParse(json['ageingDays']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
    );
  }

  get phone => null;

  // Keep sample data for testing
  static List<Case> getSampleCases() {
    return [
      Case(
        id: '1',
        name: 'Ravi Mehta',
        type: 'Term Life',
        appId: 'TL1192282625',
        premium: 50000,
        ageingDays: 2,
        status: 'Jumpstart',
      ),
      Case(
        id: '2',
        name: 'Shivam S.',
        type: 'ULIP',
        appId: 'UL1192282626',
        premium: 75000,
        ageingDays: 1,
        status: 'Jumpstart',
      ),
    ];
  }
}
