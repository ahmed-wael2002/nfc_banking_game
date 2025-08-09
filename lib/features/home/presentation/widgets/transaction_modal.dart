import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/core/utils/validators/transaction_amount_validator.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/presentation/blocs/get_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/update_user_bloc.dart';
import 'package:nfc/service_locator.dart';

class TransactionModal extends StatefulWidget {
  const TransactionModal({super.key});

  @override
  State<TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends State<TransactionModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool _isDisposed = false;
  bool _isWithdrawal = true; // default to withdraw

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startInitialScan());
  }

  @override
  void dispose() {
    _isDisposed = true;
    _amountController.dispose();
    super.dispose();
  }

  void _startInitialScan() {
    if (!_isDisposed && mounted) {
      context.read<GetUserBloc>().getUser();
    }
  }

  void _scanAgain() {
    if (_isDisposed || !mounted) return;
    final getBloc = context.read<GetUserBloc>();
    getBloc.reset();
    _startInitialScan();
  }

  Future<void> _startTransaction(UserEntity user) async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final double newBalance = _isWithdrawal
        ? (user.balance - amount)
        : (user.balance + amount);
    final updated = UserEntity(
      id: user.id,
      name: user.name,
      balance: newBalance,
    );

    // Use a dialog-scoped UpdateUserBloc to avoid lifecycle/routing issues
    final UpdateUserBloc updateBloc = getService<UpdateUserBloc>();
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          // Start update immediately and show progress
          updateBloc.updateUser(updated);
          return BlocProvider<UpdateUserBloc>.value(
            value: updateBloc,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocConsumer<UpdateUserBloc, RequestState<void>>(
                  listener: (dialogCtx, state) {
                    state.when(
                      initial: () {},
                      loading: () {},
                      success: (_) {
                        Navigator.of(ctx).pop();
                        if (mounted) Navigator.of(context).pop();
                      },
                      failure: (f) {
                        Navigator.of(ctx).pop();
                        // Keep modal open; show snackbar
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(f.message)));
                      },
                    );
                  },
                  builder: (dialogCtx, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.nfc,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hold card near device',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Writing transaction to NFC card...',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    } finally {
      // Ensure bloc is closed when dialog is dismissed to avoid emitting to closed sink later
      await updateBloc.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(
                  Icons.payments,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Make Transaction',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<GetUserBloc, RequestState<UserEntity>>(
                builder: (context, state) {
                  return state.when(
                    initial: () => _buildScanning(),
                    loading: () => _buildScanning(),
                    success: (user) => _buildForm(user),
                    failure: (f) => _buildScanError(f.message),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _scanAgain,
                    child: const Text('Scan Again'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanning() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Scanning card...'),
        ],
      ),
    );
  }

  Widget _buildScanError(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 48),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _scanAgain, child: const Text('Try Again')),
      ],
    );
  }

  Widget _buildForm(UserEntity user) {
    final validator = TransactionAmountValidator(
      currentBalance: user.balance,
      isWithdrawal: _isWithdrawal,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${user.name}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Balance: ${user.balance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ToggleButtons(
            isSelected: [_isWithdrawal, !_isWithdrawal],
            onPressed: (index) {
              setState(() {
                _isWithdrawal = index == 0;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Withdraw'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Deposit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Transaction amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: validator.call,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startTransaction(user),
              child: Text(_isWithdrawal ? 'Withdraw' : 'Deposit'),
            ),
          ),
        ],
      ),
    );
  }
}
