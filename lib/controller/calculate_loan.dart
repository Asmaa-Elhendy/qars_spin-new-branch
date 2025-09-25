import 'dart:math';

class LoanCalculator {
  /// Calculates the monthly payment for a loan
  ///
  /// [principal] - The loan amount (car price - down payment)
  /// [annualRate] - Annual interest rate as a percentage (e.g., 5.0 for 5%)
  /// [termInMonths] - Loan term in months
  static double calculateMonthlyPayment(
      double principal,
      double annualRate,
      int termInMonths
      ) {
    if (principal <= 0 || termInMonths <= 0) return 0;

    // Convert annual rate to monthly and to decimal
    final monthlyRate = (annualRate / 12) / 100;

    // Handle 0% interest case
    if (monthlyRate == 0) {
      return principal / termInMonths;
    }

    // Calculate monthly payment using the formula
    final rateFactor = pow(1 + monthlyRate, termInMonths).toDouble();
    final monthlyPayment = principal * (monthlyRate * rateFactor) / (rateFactor - 1);

    return monthlyPayment;
  }

  /// Calculates total payment over the life of the loan
  static double calculateTotalPayment(double monthlyPayment, int termInMonths) {
    return monthlyPayment * termInMonths;
  }

  /// Calculates total interest paid
  static double calculateTotalInterest(double principal, double totalPayment) {
    return totalPayment - principal;
  }

  /// Generates an amortization schedule
  static List<Map<String, dynamic>> generateAmortizationSchedule(
      double principal,
      double annualRate,
      int termInMonths,
      ) {
    final monthlyPayment = calculateMonthlyPayment(principal, annualRate, termInMonths);
    final monthlyRate = (annualRate / 12) / 100;
    double balance = principal;
    final  schedule = <Map<String, dynamic>>[];

    for (int month = 1; month <= termInMonths; month++) {
      final interestPayment = balance * monthlyRate;
      final principalPayment = monthlyPayment - interestPayment;
      balance -= principalPayment;

      // Handle final payment adjustment for floating point inaccuracies
      if (month == termInMonths) {
        balance = 0;
      }

      schedule.add({
        'month': month,
        'payment': monthlyPayment,
        'principal': principalPayment,
        'interest': interestPayment,
        'balance': balance > 0 ? balance : 0,
      });
    }

    return schedule;
  }
}