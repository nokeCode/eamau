import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/routes/app_routes.dart';

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

  Future<void> _logout(AuthProvider authProvider) async {
    await authProvider.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _showUserMenu(AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (authProvider.user != null)
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: authProvider.user!.avatar != null
                              ? NetworkImage(authProvider.user!.avatar!)
                              : null,
                          child: authProvider.user!.avatar == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          authProvider.user!.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.user!.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Mon profil'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Paramètres'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Déconnexion',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _logout(authProvider);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
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

            final user = snapshot.data ?? DashboardUserModel.fallback();

            return Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            DashboardHeader(
                              logoPath: "assets/logos/eamau_logo.gif",
                              notificationCount: user.notifications
                                  .where((e) => e.unread)
                                  .length,
                              onNotificationTap: _onSeeAllNotifications,
                            ),
                            Positioned(
                              top: 16,
                              right: 20,
                              child: GestureDetector(
                                onTap: () => _showUserMenu(authProvider),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 28,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
            );
          },
        ),
      ),
    );
  }
}