import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../providers/notification_provider.dart';
import '../../widgets/notification/notification_app_bar.dart';
import '../../widgets/notification/notification_section.dart';
import '../../widgets/notification/notification_tabs.dart';
import '../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: const NotificationAppBar(),

      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final today = provider.todayNotifications;
          final week = provider.weekNotifications;

          final hasNotifications =
              today.isNotEmpty || week.isNotEmpty;

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: hasNotifications
                ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: NotificationTabs(),
                  ),

                  const SizedBox(height: 12),

                  NotificationSection(
                    title: "Aujourd'hui",
                    notifications: today,
                  ),

                  NotificationSection(
                    title: "Cette semaine",
                    notifications: week,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            )
                : ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),

                Icon(
                  Icons.notifications_none_rounded,
                  size: 90,
                  color: Colors.grey,
                ),

                SizedBox(height: 20),

                Center(
                  child: Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Text(
                      "Vous n'avez aucune notification pour le moment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}