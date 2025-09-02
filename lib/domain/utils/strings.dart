mixin Strings {
  String get appName => 'Chemical Reaction Balancer';

  String get balanceEquation => 'Balance Equation';

  String get periodicTable => 'Periodic Table';

  String get sampleEquation => 'H2SO4 + CaCl -> CaSO4 + HCl';
  static String balancerInfo = """How to Use the Chemical Equation Balancer:
  
  1. Enter a chemical equation in the text field
     Example: H2 + O2 -> H2O
  
  2. Valid equation separators: ->, =>, or =
  
  3. Use proper chemical notation:
     • Chemical symbols (H, O, Na, Cl, etc.)
     • Numbers for coefficients and subscripts
     • Plus signs (+) between compounds
     • Parentheses () or brackets [] for complex groups
  
  4. Click "Balance Equation" to see the balanced result
  
  Tips:
  • Ensure both reactants and products are present
  • Spaces are optional but improve readability
  • Check the periodic table tab for element references
  """;
}
