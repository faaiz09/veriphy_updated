class Report {
  final String id;
  final String title;
  final String description;
  final String icon; 
  final DateTime date;
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.date,
    required this.data,
  });

  static List<Report> getSampleReports() {
    return [
      Report(
        id: '1',
        title: 'Monthly Performance',
        description: 'View detailed statistics for the current month',
        icon: 'bar_chart', // Changed from hex to string key
        date: DateTime.now(),
        data: {
          'totalRevenue': 210000,
          'policiesIssued': 11,
          'averagePremium': 19090.91,
        },
      ),
      Report(
        id: '2',
        title: 'Policy Summary',
        description: 'Overview of all active policies',
        icon: 'policy', // Changed from hex to string key
        date: DateTime.now(),
        data: {
          'totalPolicies': 150,
          'activePolicies': 142,
          'pendingRenewals': 8,
        },
      ),
      Report(
        id: '3',
        title: 'Revenue Analysis',
        description: 'Track revenue trends and patterns',
        icon: 'trending_up', // Changed from hex to string key
        date: DateTime.now(),
        data: {
          'currentMonth': 210000,
          'previousMonth': 185000,
          'growth': 13.51,
        },
      ),
    ];
  }
}