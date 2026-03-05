import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/vm_service.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/animated_card.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/selection_title.dart';

class VmsTab extends StatefulWidget {
  const VmsTab({super.key});

  @override
  State<VmsTab> createState() => _VmsTabState();
}

class _VmsTabState extends State<VmsTab> {
  final VmService _vmService = VmService();

  Future<void> _approveVm(VmModel vm) async {
    await _vmService.buildVm(vm);
    setState(() {});
  }

  // Future<void> _rejectVm(VmModel vm) async {
  //   vm.status = 3;
  //   await _vmService.updateStatus(vm);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectionTitle(title: "ВМ НА МОДЕРАЦИИ"),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
            future: _vmService.getAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.deepOrange),
                );
              }

              final vms =
                  snapshot.data?.where((vm) => vm.status == 0).toList() ?? [];

              if (vms.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "Нет ВМ на модерации",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: vms.length,
                itemBuilder: (context, index) => AnimatedCard(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.cloud,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vms[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    vms[index].os,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _approveVm(vms[index]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Одобрить"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
