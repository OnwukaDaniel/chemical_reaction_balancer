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
    if (formKey.currentState?.validate() ?? false) {
      final input = equationController.text.trim();
      displayText = 'Getting elements...';
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), () {
        final reactants = Solver.getReactantsList(input);
        final products = Solver.getProductsList(input);
        displayText = Solver.getElementsList(input).join(' + ');
        final matrix = Solver.buildMatrix(reactants, products);
        debugPrint('Matrix: *************** $matrix');
        final solution = Solver.solve(matrix); // returns Fractions scaled to ints

        // Print nice
        String side(List<String> chems, int offset) =>
            List.generate(chems.length, (i) {
              final coeff = solution[offset + i].num; // integer after scaling
              return "${coeff == 1 ? '' : coeff.toString()}${chems[i]}";
            }).join(" + ");
        displayText = '${side(reactants, 0)} -> ${side(products, reactants.length)}';
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
