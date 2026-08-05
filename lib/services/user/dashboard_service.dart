import '../../models/user/dashboard_user_model.dart';
import '../auth/auth_service.dart';

class DashboardService {
  DashboardService();

  Future<DashboardUserModel> getDashboard() async {
    final authService = AuthService();
    final currentUser = await authService.getCurrentUser();
    return DashboardUserModel.fromConnectedUser(currentUser);
  }
}