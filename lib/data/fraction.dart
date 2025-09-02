class Fraction {
  int num;
  int den;

  Fraction(this.num, [this.den = 1]) {
    _normalize();
  }

  void _normalize() {
    if (den < 0) {
      num = -num;
      den = -den;
    }
    int g = _gcd(num.abs(), den.abs());
    num ~/= g;
    den ~/= g;
  }

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  Fraction operator +(Fraction other) =>
      Fraction(num * other.den + other.num * den, den * other.den);

  Fraction operator -(Fraction other) =>
      Fraction(num * other.den - other.num * den, den * other.den);

  Fraction operator *(Fraction other) =>
      Fraction(num * other.num, den * other.den);

  Fraction operator /(Fraction other) =>
      Fraction(num * other.den, den * other.num);

  bool get isZero => num == 0;

  @override
  String toString() => den == 1 ? "$num" : "$num/$den";
}