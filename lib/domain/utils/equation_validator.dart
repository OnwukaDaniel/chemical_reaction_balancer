import '../../imports.dart';

class EquationValidator {
  static String? validateEquation(String? value) {
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

    final reactantList = Solver.getReactantsList(value);
    final productList = Solver.getProductsList(value);
    if (Solver.getElementsListOnly(reactantList).isEmpty) {
      return 'Reactant side has no compounds/element';
    }
    if (Solver.getElementsListOnly(productList).isEmpty) {
      return 'Product side has no compounds/element';
    }
    return null;
  }
}