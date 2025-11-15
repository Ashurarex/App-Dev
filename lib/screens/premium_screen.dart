import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../utils/theme_provider.dart';
import '../services/premium_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String _selectedPlan = 'yearly'; // 'monthly' or 'yearly'
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProv = Provider.of<ThemeProvider>(context);
    final premiumService = Provider.of<PremiumService>(context);
    final isPremium = premiumService.isPremium;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                    const Color(0xFF6366F1).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFFFFFFF),
                    const Color(0xFF6366F1).withOpacity(0.1),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            themeProv.isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                          ),
                          onPressed: () => themeProv.toggle(),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .moveX(begin: -20, end: 0, duration: 400.ms),
                    const SizedBox(height: 20),
                    // Premium Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.secondary],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .scale(delay: 200.ms, duration: 500.ms)
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                    Text(
                      isPremium
                          ? 'You\'re a Premium Member!'
                          : 'Unlock Premium Features',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, duration: 600.ms),
                    const SizedBox(height: 12),
                    if (isPremium &&
                        premiumService.getDaysRemaining().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.success.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: AppTheme.success,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              premiumService.getDaysRemaining(),
                              style: const TextStyle(
                                color: AppTheme.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        isPremium
                            ? 'Enjoy all premium features'
                            : 'Take your habit tracking to the next level',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms)
                          .moveY(begin: 20, end: 0, duration: 600.ms),
                    const SizedBox(height: 40),
                    // Features List
                    _buildFeatureList(isDark)
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, duration: 600.ms),
                    if (!isPremium) ...[
                      const SizedBox(height: 40),
                      // Plan Selector
                      _buildPlanSelector(isDark)
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 600.ms)
                          .moveY(begin: 20, end: 0, duration: 600.ms),
                      const SizedBox(height: 32),
                      // Pricing Cards
                      _buildPricingCards(isDark)
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 600.ms)
                          .moveY(begin: 20, end: 0, duration: 600.ms),
                      const SizedBox(height: 24),
                    ],
                    // Subscribe Button or Manage Subscription
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: double.infinity,
                      child: isPremium
                          ? ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Manage Subscription'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Plan: ${premiumService.planType?.toUpperCase() ?? "N/A"}'),
                                        const SizedBox(height: 8),
                                        if (premiumService.expiryDate != null)
                                          Text(
                                            'Expires: ${_formatDate(premiumService.expiryDate!)}',
                                          ),
                                        const SizedBox(height: 16),
                                        TextButton(
                                          onPressed: () async {
                                            await premiumService
                                                .cancelPremium();
                                            if (!mounted) return;
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Premium subscription cancelled'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child:
                                              const Text('Cancel Subscription'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: AppTheme.success,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings_rounded, size: 22),
                                  SizedBox(width: 12),
                                  Text(
                                    'Manage Subscription',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () async {
                                      setState(() => _isProcessing = true);
                                      // Activate premium subscription
                                      final success = await premiumService
                                          .activatePremium(_selectedPlan);
                                      if (!mounted) return;
                                      setState(() => _isProcessing = false);

                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: Colors.white),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    'Premium activated! Enjoy all features.',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: AppTheme.success,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to activate premium. Please try again.'),
                                            backgroundColor: AppTheme.error,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: _isProcessing
                                    ? const SizedBox(
                                        key: ValueKey('loading'),
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Row(
                                        key: ValueKey('button'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star_rounded, size: 22),
                                          SizedBox(width: 12),
                                          Text(
                                            'Subscribe to Premium',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, duration: 600.ms),
                    const SizedBox(height: 16),
                    // Restore Purchases
                    if (!isPremium)
                      TextButton(
                        onPressed: () async {
                          setState(() => _isProcessing = true);
                          final restored =
                              await premiumService.restorePurchases();
                          if (!mounted) return;
                          setState(() => _isProcessing = false);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                restored
                                    ? 'Premium subscription restored!'
                                    : 'No previous purchases found.',
                              ),
                              backgroundColor: restored
                                  ? AppTheme.success
                                  : Colors.grey[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );

                          if (restored) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Restore Purchases'),
                      ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
                    const SizedBox(height: 24),
                    // Terms
                    Text(
                      'By subscribing, you agree to our Terms of Service and Privacy Policy. Subscription will auto-renew unless cancelled.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildFeatureList(bool isDark) {
    final features = [
      {
        'icon': Icons.analytics_rounded,
        'text': 'Advanced Analytics & Insights'
      },
      {'icon': Icons.notifications_active_rounded, 'text': 'Smart Reminders'},
      {'icon': Icons.cloud_sync_rounded, 'text': 'Cloud Sync Across Devices'},
      {'icon': Icons.palette_rounded, 'text': 'Custom Themes & Colors'},
      {'icon': Icons.workspace_premium_rounded, 'text': 'Unlimited Habits'},
      {'icon': Icons.attach_money_rounded, 'text': 'Export Data & Reports'},
      {'icon': Icons.group_rounded, 'text': 'Share Habits with Friends'},
      {'icon': Icons.support_agent_rounded, 'text': 'Priority Support'},
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  feature['text'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 24,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = 'monthly'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedPlan == 'monthly'
                      ? AppTheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedPlan == 'monthly'
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = 'yearly'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedPlan == 'yearly'
                      ? AppTheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Yearly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedPlan == 'yearly'
                            ? Colors.white
                            : (isDark ? Colors.grey[300] : Colors.grey[700]),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_selectedPlan == 'yearly')
                      Text(
                        'Save 20%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCards(bool isDark) {
    const monthlyPrice = '₹499';
    const yearlyPrice = '₹3,999';
    const yearlyMonthly = '₹333';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        if (isWide) {
          return Row(
            children: [
              Expanded(
                child: _buildPricingCard(
                  isDark: isDark,
                  price: monthlyPrice,
                  period: 'per month',
                  isSelected: _selectedPlan == 'monthly',
                  onTap: () => setState(() => _selectedPlan = 'monthly'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPricingCard(
                  isDark: isDark,
                  price: yearlyPrice,
                  period: 'per year',
                  monthlyEquivalent: yearlyMonthly,
                  isSelected: _selectedPlan == 'yearly',
                  isPopular: true,
                  onTap: () => setState(() => _selectedPlan = 'yearly'),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildPricingCard(
                isDark: isDark,
                price: monthlyPrice,
                period: 'per month',
                isSelected: _selectedPlan == 'monthly',
                onTap: () => setState(() => _selectedPlan = 'monthly'),
              ),
              const SizedBox(height: 16),
              _buildPricingCard(
                isDark: isDark,
                price: yearlyPrice,
                period: 'per year',
                monthlyEquivalent: yearlyMonthly,
                isSelected: _selectedPlan == 'yearly',
                isPopular: true,
                onTap: () => setState(() => _selectedPlan = 'yearly'),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPricingCard({
    required bool isDark,
    required String price,
    required String period,
    String? monthlyEquivalent,
    required bool isSelected,
    bool isPopular = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : (isDark ? Colors.grey[800] : Colors.white),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : (isDark
                    ? (Colors.grey[700] ?? Colors.grey)
                    : (Colors.grey[300] ?? Colors.grey)),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primary : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            if (monthlyEquivalent != null) ...[
              const SizedBox(height: 8),
              Text(
                '$monthlyEquivalent/month',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
