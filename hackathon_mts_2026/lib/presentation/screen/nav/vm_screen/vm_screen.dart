import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/vm_service.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/vm_screen/widget/empty_vm_item.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/vm_screen/widget/vm_item.dart';

class VmScreen extends StatefulWidget {
  const VmScreen({super.key});

  @override
  State<VmScreen> createState() => _VmScreenState();
}

class _VmScreenState extends State<VmScreen> {
  final VmService service = VmService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: service.getVmListByUserId(0),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              );
            }

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.only(top: 20),
                itemBuilder: (context, index) =>
                    VmItem(vm: snapshot.data![index]),
              );
            } else {
              return EmptyVmItem();
            }
          },
        ),
      ),
    );
  }
}
