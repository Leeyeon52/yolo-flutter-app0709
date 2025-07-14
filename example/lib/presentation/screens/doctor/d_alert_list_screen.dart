import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/viewmodel/doctor/d_alert_viewmodel.dart';
import '../../widgets/app_drawer.dart';

class DAlertListScreen extends StatelessWidget {
  const DAlertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DAlertViewModel()..fetchAlerts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('비대면 진료 알림')),
        drawer: const AppDrawer(),
        body: Consumer<DAlertViewModel>(
          builder: (context, vm, _) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.alerts.isEmpty) {
              return const Center(child: Text('알림이 없습니다.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: vm.alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final a = vm.alerts[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('${a.name} | ${a.description}'),
                    subtitle: Text('${a.date} (${a.statusText})'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 상세 진료 페이지 이동
                    },
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
