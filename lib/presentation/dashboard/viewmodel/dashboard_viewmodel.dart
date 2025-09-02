import 'package:chemical_reaction_balancer/domain/utils/overlay_tooltip_manager.dart';
import 'package:chemical_reaction_balancer/imports.dart';

class DashboardViewModel extends BaseViewModel {
  final GlobalKey infoKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController equationController = TextEditingController();
  String info = '';
  String displayText = '';

  callFormValidator() => formKey.currentState?.validate();

  doAction() {
    debugPrint('--------------- DO ACTION ---------------');
    if (formKey.currentState?.validate() ?? false) {
      final input = equationController.text.trim();
      displayText = 'Getting elements...';
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), () {
        displayText = Solver.getElementsList(input).join(' + ');
        notifyListeners();
      });
    } else {
      displayText = '';
      notifyListeners();
    }
  }

  showBalanceToolTip(
    BuildContext context,
    GlobalKey<State<StatefulWidget>> buttonKey,
    String message, {
    bool autoDismiss = false,
  }) {
    OverlayTooltipManager.showTooltip(
      buttonKey: buttonKey,
      context: context,
      message: message,
      position: TooltipPosition.bottomRight,
      duration: const Duration(seconds: 3),
      showArrow: true,
      autoDismiss: false,
    );
  }
}
