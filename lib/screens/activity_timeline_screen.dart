// lib/screens/activity_timeline_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/activity_provider.dart';
import 'package:rm_veriphy/models/activity/activity_data.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTimelineScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ActivityTimelineScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ActivityTimelineScreen> createState() => _ActivityTimelineScreenState();
}

class _ActivityTimelineScreenState extends State<ActivityTimelineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().loadUserActivity(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Activity Timeline'),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ActivityProvider>().refreshActivity();
            },
          ),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.activities.isEmpty) {
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshActivity(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activity history',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshActivity,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.activities.length,
              itemBuilder: (context, index) {
                return ActivityTimelineItem(
                  activity: provider.activities[index],
                  isLast: index == provider.activities.length - 1,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ActivityTimelineItem extends StatelessWidget {
  final ActivityData activity;
  final bool isLast;

  const ActivityTimelineItem({
    super.key,
    required this.activity,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeline(context),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.activity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(activity.description),
                    const SizedBox(height: 8),
                    Text(
                      timeago.format(activity.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
      ],
    );
  }
}
