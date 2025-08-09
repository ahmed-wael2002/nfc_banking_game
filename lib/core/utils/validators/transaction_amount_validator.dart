class TransactionAmountValidator {
  TransactionAmountValidator({
    required this.currentBalance,
    required this.isWithdrawal,
  });

  final double currentBalance;
  final bool isWithdrawal;

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter an amount';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed <= 0) {
      return 'Amount must be greater than 0';
    }
    if (isWithdrawal && parsed > currentBalance) {
      return 'Amount exceeds balance';
    }
    return null;
  }
}
