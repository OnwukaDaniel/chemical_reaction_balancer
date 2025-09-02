import 'package:chemical_reaction_balancer/imports.dart';

class DashboardViewModel extends BaseViewModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController equationController = TextEditingController();

  String displayText = '';

  String? validateEquation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a chemical equation';
    }

    // Check if at least one valid separator exists
    bool hasValidSeparator =
        value.contains('->') || value.contains('=>') || value.contains('=');

    if (!hasValidSeparator) {
      return 'Please enter a valid chemical equation with "->" or "=>" or "="';
    }

    String separator =
        value.contains('->') ? '->' : (value.contains('=>') ? '=>' : '=');

    List<String> parts = value.split(separator);
    if (parts.length != 2 ||
        parts[0].trim().isEmpty ||
        parts[1].trim().isEmpty) {
      return 'Equation must have reactants and products separated by "$separator"';
    }
    return null;
  }

  callFormValidator() => formKey.currentState?.validate();

  doAction() {
    debugPrint('--------------- DO ACTION ---------------');
    if (formKey.currentState?.validate() ?? false) {
      final input = equationController.text.trim();
      displayText = 'Getting reactants...';
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), () {
        displayText = Solver.getReactantsList(input).join(' + ');
        notifyListeners();
      });
    } else {
      displayText = '';
      notifyListeners();
    }
  }
}
