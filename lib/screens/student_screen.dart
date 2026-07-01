import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student/dashboard_provider.dart';
import '../widgets/student/dashboard_app_bar.dart';
import '../widgets/student/dashboard_menu.dart';
import '../widgets/student/notification_section.dart';
import '../widgets/student/quick_stats_section.dart';
import '../widgets/student/dashboard_app_bar.dart';
import '../widgets/student/student_header.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });
  }

  Future<void> _refresh() async {
    await context.read<DashboardProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        onNotificationPressed: () {
          Navigator.pushNamed(
            context,
            '/notifications',
          );
        },
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.dashboard == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null &&
              provider.dashboard == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.loadDashboard,
                      child: const Text(
                        'Réessayer',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final dashboard = provider.dashboard;

          if (dashboard == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  StudentHeader(
                    firstName: dashboard.firstName,
                    matricule: dashboard.matricule,
                  ),

                  const SizedBox(height: 24),

                  QuickStatsSection(
                    stats: dashboard.quickStats,
                  ),

                  const SizedBox(height: 28),

                  DashboardMenu(
                    menu: dashboard.menu,
                    onItemTap: (item) {
                      Navigator.pushNamed(
                        context,
                        item.route,
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  NotificationSection(
                    notifications:
                    dashboard.notifications,
                    onSeeAll: () {
                      Navigator.pushNamed(
                        context,
                        '/notifications',
                      );
                    },
                    onTap: (notification) {
                      // Détail de la notification
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}