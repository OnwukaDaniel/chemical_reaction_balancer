import 'package:chemical_reaction_balancer/imports.dart';

extension on int {
  Widget get h => SizedBox(height: toDouble());

  Widget get w => SizedBox(width: toDouble());
}

extension on double {
  Widget get h => SizedBox(height: this);

  Widget get w => SizedBox(width: this);
}
