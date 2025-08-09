import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/create_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/delete_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/get_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/update_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/make_transaction_bloc.dart';
import 'package:nfc/features/home/presentation/widgets/nfc_scan_modal.dart';
import 'package:nfc/features/home/presentation/widgets/create_user_modal.dart';
import 'package:nfc/features/home/presentation/widgets/make_transaction_modal.dart';
import 'package:nfc/features/home/presentation/widgets/transfer_modal.dart';
import 'package:nfc/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getService<GetUserBloc>()),
        BlocProvider(create: (context) => getService<UpdateUserBloc>()),
        BlocProvider(create: (context) => getService<DeleteUserBloc>()),
        BlocProvider(create: (context) => getService<CreateUserBloc>()),
      ],
      child: const HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Banking Game'),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF160005)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.25),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome to Ultimate Banking Game',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your NFC banking experience',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWide = constraints.maxWidth >= 600;
                    final int crossAxisCount = isWide ? 3 : 2;
                    final double childAspectRatio = isWide ? 1.4 : 1.0;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                      padding: const EdgeInsets.only(bottom: 8),
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.qr_code_scanner,
                          title: 'Scan Card',
                          subtitle: 'Read card data',
                          onTap: () => _showNfcScanModal(context),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.person_add,
                          title: 'Register User',
                          subtitle: 'Create new user',
                          onTap: () => _showCreateUserModal(context),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.payments,
                          title: 'Transaction',
                          subtitle: 'Deposit or withdraw',
                          onTap: () => _showTransactionModal(context),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.swap_horiz,
                          title: 'Transfer',
                          subtitle: 'Move money between cards',
                          onTap: () => _showTransferModal(context),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              spreadRadius: 2,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNfcScanModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => getService<GetUserBloc>(),
        child: const NfcScanModal(),
      ),
    );
  }

  void _showCreateUserModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => getService<CreateUserBloc>(),
        child: const CreateUserModal(),
      ),
    );
  }

  void _showTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (_) => getService<MakeTransactionBloc>(),
        child: const MakeTransactionModal(),
      ),
    );
  }

  void _showTransferModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (_) => getService<MakeTransactionBloc>(),
        child: const TransferModal(),
      ),
    );
  }
}
