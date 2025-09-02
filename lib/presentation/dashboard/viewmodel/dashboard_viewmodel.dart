import 'package:chemical_reaction_balancer/imports.dart';

class DashboardViewModel extends BaseViewModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController equationController = TextEditingController();

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
}
