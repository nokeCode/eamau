import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/student/dashboard_model.dart';
import '../../models/student/dashboard_notification_model.dart';
import '../../models/student/menu_item_model.dart';
import '../../models/student/quick_stat_model.dart';

class DashboardService {
  static const String endpoint = 'api/user/dashboard';

  Future<DashboardModel> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
      );

      if (response.statusCode == 200) {
        return DashboardModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return fallbackDashboard;
    } catch (_) {
      return fallbackDashboard;
    }
  }
}

final DashboardModel fallbackDashboard = DashboardModel(
  firstName: 'Germain',
  matricule: 'ETU-2026-00124',

  quickStats: const [
    QuickStatModel(
      title: 'Inscriptions',
      subtitle: 'en cours',
      count: 3,
      icon: 'description',
      color: '#DCEEFF',
    ),
    QuickStatModel(
      title: 'Notifications',
      subtitle: 'non lues',
      count: 5,
      icon: 'notifications',
      color: '#FFF7C9',
    ),
    QuickStatModel(
      title: 'Évaluations',
      subtitle: 'en attente',
      count: 2,
      icon: 'edit_square',
      color: '#DDF8DD',
    ),
  ],

  menu: const [
    MenuItemModel(
      title: 'Mes inscriptions',
      subtitle: 'Voir mes cours\net modules',
      icon: 'description',
      route: '/registrations',
    ),
    MenuItemModel(
      title: 'Mes résultats',
      subtitle: 'Consulter mes\nnotes',
      icon: 'bar_chart',
      route: '/results',
    ),
    MenuItemModel(
      title: 'Calendrier académique',
      subtitle: 'Dates et\névènements',
      icon: 'calendar_month',
      route: '/calendar',
    ),
    MenuItemModel(
      title: 'Évaluation des enseignants',
      subtitle: 'Donner mon\navis',
      icon: 'groups',
      route: '/evaluations',
    ),
    MenuItemModel(
      title: 'Actualités',
      subtitle: 'Nouvelles et\nannonces',
      icon: 'article',
      route: '/news',
    ),
  ],

  notifications: const [
    DashboardNotificationModel(
      title: 'Votre dossier est en cours d’examen.',
      message: '',
      icon: 'school',
      time: 'Il y a 2 heures',
      unread: true,
    ),
    DashboardNotificationModel(
      title: 'Rentrée universitaire 2026-2027.',
      message: '',
      icon: 'description',
      time: 'Il y a 1 jour',
      unread: true,
    ),
    DashboardNotificationModel(
      title: 'Votre dossier est en cours d’examen.',
      message: '',
      icon: 'calendar_month',
      time: 'Il y a 2 jours',
      unread: true,
    ),
  ],
);