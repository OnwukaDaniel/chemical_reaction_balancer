import 'package:chemical_reaction_balancer/imports.dart';

class Solver {

  static divideReactantsProducts(String equation) {
    String separator =
        equation.contains('->') ? '->' : (equation.contains('=>') ? '=>' : '=');
    if (!equation.contains(separator)) {
      throw Exception('Equation does not contain a valid separator');
    }
    return equation.split(separator).map((e) => e.trim()).toList();
  }
  /// Only call when validator validates the equation has reactants and product
  static List<String> getReactantsList(String equation) {
    String separator =
        equation.contains('->') ? '->' : (equation.contains('=>') ? '=>' : '=');
    if (!equation.contains(separator)) {
      throw Exception('Equation does not contain a valid separator');
    }
    return equation
        .split(separator)[0]
        .trim()
        .split('+')
        .map((e) => e.trim())
        .toList();
  }

  /// Only call when validator validates the equation has reactants and product
  static List<String> getProductsList(String equation) {
    String separator =
        equation.contains('->') ? '->' : (equation.contains('=>') ? '=>' : '=');
    if (!equation.contains(separator)) {
      throw Exception('Equation does not contain a valid separator');
    }
    return equation
        .split(separator)[1]
        .trim()
        .split('+')
        .map((e) => e.trim())
        .toList();
  }

  static List<String> getElementsList(String equation) {
    final reactants = getReactantsList(equation);
    final products = getProductsList(equation);
    final elements = <String>{};
    for (var c in [...reactants, ...products]) {
      final regex = RegExp(r'([A-Z][a-z]*)');
      for (final match in regex.allMatches(c)) {
        elements.add(match.group(1)!);
      }
    }
    return elements.toList();
  }

  static List<String> getElementsListOnly(List<String> side) {
    final elements = <String>{};
    for (var c in side) {
      final regex = RegExp(r'([A-Z][a-z]*)');
      for (final match in regex.allMatches(c)) {
        elements.add(match.group(1)!);
      }
    }
    return elements.toList();
  }

  Map<String, int> parseCompound(String compound) {
    final regex = RegExp(r'([A-Z][a-z]*)(\d*)');
    final Map<String, int> counts = {};
    for (final match in regex.allMatches(compound)) {
      final element = match.group(1)!;
      final count = match.group(2)!.isEmpty ? 1 : int.parse(match.group(2)!);
      counts[element] = (counts[element] ?? 0) + count;
    }
    return counts;
  }

  // Build the element balance matrix
  List<List<Fraction>> buildMatrix(
    List<String> reactants,
    List<String> products,
  ) {
    final elements = <String>{};
    for (var c in [...reactants, ...products]) {
      elements.addAll(parseCompound(c).keys);
    }
    final elementList = elements.toList();

    final matrix = List.generate(
      elementList.length,
      (_) =>
          List.generate(reactants.length + products.length, (_) => Fraction(0)),
    );

    for (int j = 0; j < reactants.length; j++) {
      final counts = parseCompound(reactants[j]);
      for (int i = 0; i < elementList.length; i++) {
        matrix[i][j] = Fraction(counts[elementList[i]] ?? 0);
      }
    }
    for (int j = 0; j < products.length; j++) {
      final counts = parseCompound(products[j]);
      for (int i = 0; i < elementList.length; i++) {
        matrix[i][reactants.length + j] = Fraction(
          -(counts[elementList[i]] ?? 0),
        );
      }
    }
    return matrix;
  }

  // Gaussian elimination (row-reduction) to solve A*x = 0
  List<Fraction> solve(List<List<Fraction>> matrix) {
    final rows = matrix.length;
    final cols = matrix[0].length;
    int row = 0;

    for (int col = 0; col < cols && row < rows; col++) {
      // Find pivot
      int pivot = row;
      while (pivot < rows && matrix[pivot][col].isZero) pivot++;
      if (pivot == rows) continue;

      // Swap
      var tmp = matrix[row];
      matrix[row] = matrix[pivot];
      matrix[pivot] = tmp;

      // Normalize pivot row
      var pivotVal = matrix[row][col];
      for (int j = col; j < cols; j++) {
        matrix[row][j] = matrix[row][j] / pivotVal;
      }

      // Eliminate other rows
      for (int i = 0; i < rows; i++) {
        if (i != row && !matrix[i][col].isZero) {
          var factor = matrix[i][col];
          for (int j = col; j < cols; j++) {
            matrix[i][j] = matrix[i][j] - matrix[row][j] * factor;
          }
        }
      }

      row++;
    }

    // Free variable approach: set last variable = 1
    List<Fraction> solution = List.generate(cols, (_) => Fraction(0));
    solution[cols - 1] = Fraction(1);

    for (int i = rows - 1; i >= 0; i--) {
      int leadingCol = matrix[i].indexWhere((x) => !x.isZero);
      if (leadingCol == -1) continue;

      Fraction rhs = Fraction(0);
      for (int j = leadingCol + 1; j < cols; j++) {
        rhs += matrix[i][j] * solution[j];
      }
      solution[leadingCol] = rhs * Fraction(-1);
    }

    // Scale to integers
    int lcm = solution.map((f) => f.den).reduce(_lcm);
    List<int> intSolution =
        solution.map((f) => f.num * (lcm ~/ f.den)).toList();

    // Normalize gcd
    int g = intSolution.map((e) => e.abs()).reduce(_gcd);
    intSolution = intSolution.map((e) => e ~/ g).toList();

    return intSolution.map((e) => Fraction(e)).toList();
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  int _lcm(int a, int b) => (a * b) ~/ _gcd(a, b);
}
