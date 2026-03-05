import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/vm_screen/detail_vm_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/vm_screen/vm_screen.dart';

class VmRouter extends StatefulWidget {
  const VmRouter({super.key});

  @override
  State<VmRouter> createState() => _VmRouterState();
}

class _VmRouterState extends State<VmRouter> {
  bool isDetailScreen = false;
  VmModel? _selectedVm;

  void _navigateToDetail(VmModel vm) {
    setState(() {
      _selectedVm = vm;
      isDetailScreen = true;
    });
  }

  void _navigateBack() {
    setState(() {
      isDetailScreen = false;
      _selectedVm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDetailScreen && _selectedVm != null) {
      return VmDetailScreen(vm: _selectedVm!, back: _navigateBack);
    }

    return VmScreen(onVmSelected: _navigateToDetail);
  }
}
