import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '/presentation/viewmodel/auth_viewmodel.dart'; // 기존 AuthViewModel 임포트
import 'd_patient_list_screen.dart'; // ✅ PatientListScreen 임포트 추가 (경로 확인 필요)

// 임시 DoctorDashboardViewModel (실제 Viewmodel로 교체 필요)
// 실제 프로젝트에 맞는 경로와 로직으로 대체해야 합니다.
enum DoctorMenu { telemedicineRequests, calendar, patientList }

class DoctorDashboardViewModel with ChangeNotifier {
  DoctorMenu _selectedMenu = DoctorMenu.telemedicineRequests;

  DoctorMenu get selectedMenu => _selectedMenu;

  void setSelectedMenu(DoctorMenu menu) {
    _selectedMenu = menu;
    notifyListeners();
  }
}

// 임시 화면들 (실제 화면으로 교체 필요)
// TelemedicineRequestListScreen은 더 이상 사용되지 않으므로 제거하거나 주석 처리합니다.
/*
class TelemedicineRequestListScreen extends StatelessWidget {
  const TelemedicineRequestListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('환자 진료 요청 목록 화면 (임시)'));
  }
}
*/

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('진료 캘린더 화면 (임시)'));
  }
}

// PatientListScreen은 이제 실제 PatientListScreen을 사용합니다.
/*
class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('환자 목록 화면 (임시)'));
  }
}
*/


class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DoctorDashboardViewModel>();

    Widget mainContent;
    switch (dashboardViewModel.selectedMenu) {
      case DoctorMenu.telemedicineRequests:
        mainContent = const PatientListScreen(); // ✅ PatientListScreen으로 변경
        break;
      case DoctorMenu.calendar:
        mainContent = const CalendarScreen();
        break;
      case DoctorMenu.patientList:
        mainContent = const PatientListScreen(); // ✅ PatientListScreen으로 변경
        break;
    }

    return Scaffold(
      body: Row(
        children: [
          // 좌측 내비게이션 바
          Container(
            width: 250,
            color: Colors.blueGrey[800],
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  alignment: Alignment.center,
                  child: const Text(
                    'TOOTH AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.list_alt,
                  title: '환자 진료',
                  isSelected: dashboardViewModel.selectedMenu == DoctorMenu.telemedicineRequests,
                  onTap: () {
                    dashboardViewModel.setSelectedMenu(DoctorMenu.telemedicineRequests);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today,
                  title: '진료 캘린더',
                  isSelected: dashboardViewModel.selectedMenu == DoctorMenu.calendar,
                  onTap: () {
                    dashboardViewModel.setSelectedMenu(DoctorMenu.calendar);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_alt,
                  title: '환자 목록',
                  isSelected: dashboardViewModel.selectedMenu == DoctorMenu.patientList,
                  onTap: () {
                    dashboardViewModel.setSelectedMenu(DoctorMenu.patientList);
                  },
                ),
                const Spacer(),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: '로그아웃',
                  isSelected: false,
                  onTap: () {
                    context.read<AuthViewModel>().logout();
                    context.go('/login');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // 메인 콘텐츠 영역
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.blueGrey[200]),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blueGrey[200],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
