import 'package:flutter/material.dart';
import 'package:frontend/ui/viewmodel.dart';

abstract class ViewBase<T extends ViewModel> extends StatelessWidget {
  const ViewBase({super.key, required this.viewModel});

  final T viewModel;

  /// Builds the widget tree for the view.
  Widget buildView(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => buildView(context),
    );
  }
}
