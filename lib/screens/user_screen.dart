import 'package:flutter/material.dart';

import '../../models/user/account_status_model.dart';
import '../../models/user/dashboard_user_model.dart';
import '../../models/user/notification_preview_model.dart';
import '../../services/user/dashboard_service.dart';
import '../../widgets/user/dashboard_header.dart';
import '../../widgets/user/loading_dashboard.dart';
import '../../widgets/user/notification_list.dart';
import '../../widgets/user/status_card.dart';
import '../../widgets/user/welcome_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardUserModel> _dashboardFuture;

  final DashboardService _service = DashboardService();

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _service.getDashboard();
  }

  Future<void> _refresh() async {
    setState(() {
      _dashboardFuture = _service.getDashboard();
    });

    await _dashboardFuture;
  }

  void _onNotificationTap(NotificationPreviewModel notification) {
    // TODO
  }

  void _onCompleteProfile() {
    // TODO
  }

  void _onStatusTap(AccountStatusModel status) {
    // TODO
  }

  void _onSeeAllNotifications() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: FutureBuilder<DashboardUserModel>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingDashboard();
            }

            if (snapshot.hasError) {
              return Center(
                child: ElevatedButton(
                  onPressed: _refresh,
                  child: const Text("Réessayer"),
                ),
              );
            }

            final user =
                snapshot.data ?? DashboardUserModel.fallback();

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(
                      logoPath: "assets/logos/eamau_logo.gif",
                      notificationCount:
                      user.notifications.where((e) => e.unread).length,
                      onNotificationTap: _onSeeAllNotifications,
                    ),

                    const SizedBox(height: 10),

                    WelcomeCard(
                      user: user,
                      onCompleteProfile: _onCompleteProfile,
                    ),

                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "État de votre compte",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...user.statuses.map(
                          (status) => StatusCard(
                        status: status,
                        onTap: () => _onStatusTap(status),
                      ),
                    ),

                    const SizedBox(height: 25),

                    NotificationList(
                      notifications: user.notifications,
                      onSeeAll: _onSeeAllNotifications,
                      onNotificationTap: _onNotificationTap,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}