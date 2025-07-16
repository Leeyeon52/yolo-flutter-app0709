import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/presentation/viewmodel/doctor/d_dashboard_viewmodel.dart';

class DoctorDrawer extends StatelessWidget {
  final String baseUrl;

  const DoctorDrawer({Key? key, required this.baseUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'TOOTH AI 닥터 메뉴',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      context.go('/login');
                    },
                    tooltip: '로그아웃',
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: '홈',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_home', extra: baseUrl);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.personal_injury,
            title: '비대면 진료 신청',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_dashboard', extra: baseUrl);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.assignment,
            title: '진료 결과',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_inference_result', extra: baseUrl);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.event,
            title: '진료 캘린더',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_calendar', extra: baseUrl);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: '환자 목록',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_patients', extra: baseUrl);
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: '설정',
            onTap: () {
              Navigator.pop(context);
              context.go('/d_settings', extra: baseUrl);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey[700]),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blueGrey[800],
            ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.white,
      hoverColor: Colors.blue.withOpacity(0.1),
    );
  }
}

class DRealHomeScreen extends StatefulWidget {
  final String baseUrl;

  const DRealHomeScreen({Key? key, required this.baseUrl}) : super(key: key);

  @override
  State<DRealHomeScreen> createState() => _DRealHomeScreenState();
}

class _DRealHomeScreenState extends State<DRealHomeScreen> {
  bool showNewConsultations = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<DoctorDashboardViewModel>(context, listen: false);
      viewModel.loadDashboardData(widget.baseUrl);
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
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.go('/d_notifications');
            },
          )
        ],
      ),
      drawer: DoctorDrawer(baseUrl: widget.baseUrl),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '환영합니다, 의사 선생님!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              '연결된 서버: ${widget.baseUrl}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 진료 현황',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(context, '신규 환자', viewModel.newPatientsToday.toString()),
                        _buildStatItem(context, '진료 완료', viewModel.completedConsultationsToday.toString()),
                        _buildStatItem(context, '대기 환자', viewModel.pendingConsultations.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDashboardListItem(context, Icons.person_add, '새로운 진료 요청', () {
                    setState(() {
                      showNewConsultations = !showNewConsultations;
                    });
                  }),
                  if (showNewConsultations)
                    _buildExpandableSection(context, '진료 요청 목록', [
                      '환자 A - 증상: 통증',
                      '환자 B - 증상: 출혈'
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ],
    );
  }

  Widget _buildDashboardListItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 30),
              const SizedBox(width: 15),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(BuildContext context, String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () => context.go('/d_dashboard', extra: widget.baseUrl),
                  child: Text(
                    '• $item',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
ㄹㄹㄹㄹ