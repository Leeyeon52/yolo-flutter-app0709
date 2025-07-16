import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/presentation/viewmodel/doctor/doctor_dashboard_viewmodel.dart';
import 'doctor_drawer.dart';

class DRealHomeScreen extends StatefulWidget {
  final String baseUrl;
  const DRealHomeScreen({Key? key, required this.baseUrl}) : super(key: key);

  @override
  State<DRealHomeScreen> createState() => _DRealHomeScreenState();
}

class _DRealHomeScreenState extends State<DRealHomeScreen> {
  bool showNewConsultations = false;
  bool showPastRecords = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorDashboardViewModel>(context, listen: false)
          .loadDashboardData(widget.baseUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorDashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('의사 대시보드 홈'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: viewModel.hasNewNotification ? Colors.red : Colors.white,
            ),
            onPressed: () {
              viewModel.clearNotifications();
            },
            tooltip: '알림',
          )
        ],
      ),
      drawer: DoctorDrawer(baseUrl: widget.baseUrl),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '환영합니다, 의사 선생님!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 10),
            Text('연결된 서버: ${widget.baseUrl}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            _buildStatCard(viewModel),
            const SizedBox(height: 20),

            /// 새로운 진료 요청
            ExpansionTile(
              initiallyExpanded: showNewConsultations,
              onExpansionChanged: (value) {
                setState(() => showNewConsultations = value);
              },
              leading: const Icon(Icons.person_add),
              title: const Text('새로운 진료 요청 확인'),
              children: viewModel.newConsultations.map((e) {
                return ListTile(
                  title: Text(e),
                  leading: const Icon(Icons.medical_information),
                );
              }).toList(),
            ),

            /// 과거 진료 기록
            ExpansionTile(
              initiallyExpanded: showPastRecords,
              onExpansionChanged: (value) {
                setState(() => showPastRecords = value);
              },
              leading: const Icon(Icons.history),
              title: const Text('과거 진료 기록 조회'),
              children: viewModel.pastConsultations.map((e) {
                return ListTile(
                  title: Text(e),
                  leading: const Icon(Icons.assignment_turned_in),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(DoctorDashboardViewModel viewModel) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('신규 환자', viewModel.newPatientsToday.toString()),
            _buildStatItem('진료 완료', viewModel.completedConsultationsToday.toString()),
            _buildStatItem('대기 환자', viewModel.pendingConsultations.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            )),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
