import 'package:flutter/material.dart';
import 'package:ngl_flutter/src/controllers/ngl_controller.dart';
import 'package:ngl_flutter/src/models/atom_info.dart';
import 'package:ngl_flutter/src/widgets/ngl_viewer_widget.dart';

class NglFlutter extends StatelessWidget {
  final String ligand;
  final NGLViewerController? controller;

  const NglFlutter(
      {super.key, required this.ligand,  this.controller});
  @override
  Widget build(BuildContext context) {
    return NGLViewerWidget(
      controller: controller,
      ligandId: ligand,
    );
  }
}
