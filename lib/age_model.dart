class Age {
  final int years;
  final int months;
  final int days;

  const Age({required this.years, required this.months, required this.days});

  @override
  String toString() {
    return '$years Years, $months Months, $days Days';
  }
}

class AgeCalculator {
  /// Calculates age from [birthDate] to [targetDate].
  static Age calculateAge(DateTime birthDate, DateTime targetDate) {
    // If birthDate > targetDate, we technically handle it,
    // but the result might be negative or 0 depending on usage.
    // For standard Age Calculator, we assume birthDate <= targetDate.
    // However, if swapped, let's just swap them or return negative?
    // The user didn't specify. Standard behavior: show error or negative.
    // This logic handles negative results naturally if simple subtraction,
    // but the borrow logic assumes forward progression.

    // Let's ensure valid calculation
    if (birthDate.isAfter(targetDate)) {
      // Allow negative age or just return 0?
      // Let's returning mostly 0s or handle negative years?
      // Let's just run the logic. It will produce negative years/months/days potentially
      // but the 'borrow' logic might act weird.
      // E.g. 2021 (Target) - 2022 (Birth) = -1.
      // Let's leave it to caller to validate inputs.
    }

    int years = targetDate.year - birthDate.year;
    int months = targetDate.month - birthDate.month;
    int days = targetDate.day - birthDate.day;

    if (days < 0) {
      // Borrow days from previous month of targetDate
      // DateTime(year, month, 0) is the last day of the previous month.
      // Example: target is March 1st (month 3). Prev is Feb (month 2).
      // DateTime(2024, 3, 0) -> Feb 29.
      int daysInPrevMonth = DateTime(targetDate.year, targetDate.month, 0).day;

      days += daysInPrevMonth;
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return Age(years: years, months: months, days: days);
  }
}
