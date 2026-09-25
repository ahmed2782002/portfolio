import 'package:flutter/widgets.dart';

/// Owns a [ChangeNotifier] ViewModel for the lifetime of this widget and
/// rebuilds [builder] whenever it notifies.
///
/// The ViewModel is created once, on first build, and disposed with the widget
/// — the View never has to manage its lifecycle by hand.
class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  const ViewModelBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.child,
  });

  final T Function(BuildContext context) create;
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;

  /// A subtree that does not depend on the ViewModel, built once.
  final Widget? child;

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier>
    extends State<ViewModelBuilder<T>> {
  late final T _viewModel = widget.create(context);

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, child) => widget.builder(context, _viewModel, child),
    child: widget.child,
  );
}
