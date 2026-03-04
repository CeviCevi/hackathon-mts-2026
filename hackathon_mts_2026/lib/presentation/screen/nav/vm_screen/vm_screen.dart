import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/vm_screen/widget/vm_item.dart';

class VmScreen extends StatefulWidget {
  const VmScreen({super.key});

  @override
  State<VmScreen> createState() => _VmScreenState();
}

class _VmScreenState extends State<VmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const .symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: 10,
          padding: const .only(top: 20),
          itemBuilder: (context, index) => VmItem(
            vm: VmModel(
              id: 0,
              name: "name $index",
              idSsh: 123,
              ram: 10,
              rom: 100,
              cors: 5,
              password: "password",
              status: index,
              os: "Ubuntu",
            ),
          ),
        ),
      ),
    );
  }
}
