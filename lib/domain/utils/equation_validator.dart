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
    final sides = Solver.divideReactantsProducts(value);
    final reactants = sides[0];
    final products = sides[1];
    // Replace the current check with this improved validation
    if (!isValidChemicalNotation(reactants)) {
      return 'Reactant side contains invalid symbols. Only use elements, numbers, +, (), [], and spaces';
    }
    if (!isValidChemicalNotation(products)) {
      return 'Product side contains invalid symbols. Only use elements, numbers, +, (), [], and spaces';
    }
    if (reactantList.any((r) => !RegExp(r'^[A-Za-z0-9+\s]+$').hasMatch(r))) {
      return 'Reactant side contains invalid symbols';
    }
    if (productList.any((r) => !RegExp(r'^[A-Za-z0-9+\s]+$').hasMatch(r))) {
      return 'Product side contains invalid symbols';
    }
    if (Solver.getElementsListOnly(productList).contains('')) {
      return 'Product side has an error';
    }
    return null;
  }

  static bool isValidChemicalNotation(String input) {
    final validPattern = RegExp(r'^[A-Za-z0-9\+\(\)\[\]\{\}\s]*$');
    return validPattern.hasMatch(input);
  }
}