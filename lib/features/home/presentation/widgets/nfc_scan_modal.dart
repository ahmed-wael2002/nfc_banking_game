import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/get_user_bloc.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';

class NfcScanModal extends StatefulWidget {
  const NfcScanModal({super.key});

  @override
  State<NfcScanModal> createState() => _NfcScanModalState();
}

class _NfcScanModalState extends State<NfcScanModal> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Start scanning when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _startScan();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _startScan() {
    if (!_isDisposed && mounted) {
      try {
        context.read<GetUserBloc>().getUser();
      } catch (e) {
        // Handle any errors that might occur during scan initiation
        print('Error starting NFC scan: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Scan NFC Card',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content - Make it scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<GetUserBloc, RequestState<UserEntity>>(
                builder: (context, state) {
                  return state.when(
                    initial: () => _buildScanningState(),
                    loading: () => _buildScanningState(),
                    success: (user) => _buildUserData(user),
                    failure: (failure) => _buildErrorState(failure.message),
                  );
                },
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isDisposed ? null : _handleScanAgain,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

  void _handleScanAgain() {
    if (_isDisposed || !mounted) return;

    try {
      // Reset the bloc state using a public API, then start a fresh scan
      final bloc = context.read<GetUserBloc>();
      bloc.reset();
      // Immediately trigger scan again
      _startScan();
    } catch (e) {
      // ignore
    }
  }

  Widget _buildScanningState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.nfc,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Scanning NFC Card...',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Please hold your NFC card near the device',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildUserData(UserEntity user) {
    return Column(
      children: [
        // Success icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, size: 64, color: Colors.green),
        ),
        const SizedBox(height: 24),

        Text(
          'Card Data Retrieved Successfully!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // User data card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow('User ID', user.id),
              const SizedBox(height: 12),
              _buildDataRow('Name', user.name),
              const SizedBox(height: 12),
              _buildDataRow('Balance', '\$${user.balance.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    // Check if it's an NFC availability error
    final isNfcAvailabilityError =
        errorMessage.contains('NFC is not available') ||
        errorMessage.contains('NFC is turned off') ||
        errorMessage.contains('Failed to check NFC availability');

    // Check if it's a tag capacity error
    final isCapacityError = errorMessage.contains('capacity too small');

    // Check if it's a no data error
    final isNoDataError =
        errorMessage.contains('No data found') ||
        errorMessage.contains('No NDEF records found');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isNfcAvailabilityError
                ? Colors.orange.withOpacity(0.1)
                : isCapacityError
                ? Colors.blue.withOpacity(0.1)
                : isNoDataError
                ? Colors.grey.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isNfcAvailabilityError
                ? Icons.nfc
                : isCapacityError
                ? Icons.storage
                : isNoDataError
                ? Icons.credit_card
                : Icons.error,
            size: 64,
            color: isNfcAvailabilityError
                ? Colors.orange
                : isCapacityError
                ? Colors.blue
                : isNoDataError
                ? Colors.grey
                : Colors.red,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isNfcAvailabilityError
              ? 'NFC Not Available'
              : isCapacityError
              ? 'Tag Capacity Issue'
              : isNoDataError
              ? 'No Data Found'
              : 'Scan Failed',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isNfcAvailabilityError
                ? Colors.orange
                : isCapacityError
                ? Colors.blue
                : isNoDataError
                ? Colors.grey
                : Colors.red,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          errorMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (isNfcAvailabilityError)
          Text(
            'Please enable NFC in your device settings and try again.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          )
        else if (isCapacityError)
          Text(
            'This tag does not have enough space. Try using a different tag or reduce the data size.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          )
        else if (isNoDataError)
          Text(
            'This tag appears to be empty. Try writing data to it first.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          )
        else
          Text(
            'Please make sure your NFC card is properly positioned and try again.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
