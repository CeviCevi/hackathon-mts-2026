import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/vm_service.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final VmService _vmService = VmService();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              color: Colors.deepOrange,
              onRefresh: _refreshList,
              child: FutureBuilder(
                future: _vmService.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<VmModel> data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: data[index].status == 0
                                ? Colors.orange
                                : Colors.deepOrange.withAlpha(100),
                          ),
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.black87),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: data[index].status == 0
                                          ? Colors.orange.withAlpha(50)
                                          : Colors.green.withAlpha(50),
                                    ),
                                    child: Text(
                                      data[index].status == 0
                                          ? "На модерации"
                                          : "Активна",
                                      style: TextStyle(
                                        color: data[index].status == 0
                                            ? Colors.orange
                                            : Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (data[index].status == 0)
                              ElevatedButton(
                                onPressed: () async {
                                  await _vmService.updateStatus(data[index]);
                                  _refreshList();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Одобрить"),
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Нет ВМ для модерации",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
