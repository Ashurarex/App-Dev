import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/habit_service.dart';
import '../services/premium_service.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_form.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget _buildHeader(String name, BuildContext context, int habitCount) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppTheme.primary.withOpacity(0.2),
                  AppTheme.secondary.withOpacity(0.15),
                  AppTheme.primary.withOpacity(0.1),
                ]
              : [
                  AppTheme.primary.withOpacity(0.15),
                  AppTheme.secondary.withOpacity(0.1),
                  AppTheme.accent.withOpacity(0.08),
                  AppTheme.primary.withOpacity(0.12),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.2 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your habits',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$habitCount ${habitCount == 1 ? 'habit' : 'habits'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    themeProv.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => themeProv.toggle(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final habitService = Provider.of<HabitService>(context, listen: false);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Habitual',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, size: 24),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded, size: 24),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/statistics');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_rounded, size: 24),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_rounded, size: 24),
              title: const Text('Achievements'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/achievements');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, size: 24),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
              ),
              title: const Text('Go Premium'),
              subtitle: const Text('Unlock all features'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/premium');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 24),
              title: const Text('Logout'),
              onTap: () async {
                final navigator = Navigator.of(context);
                await auth.signOut();
                if (!mounted) return;
                navigator.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E293B), // Slate
                    const Color(0xFF334155), // Slate 700
                    const Color(0xFF475569), // Slate 600
                    const Color(0xFF1E293B), // Back to slate
                  ]
                : [
                    const Color(0xFFF0F9FF), // Sky 50
                    const Color(0xFFE0F2FE), // Sky 100
                    const Color(0xFFBAE6FD), // Sky 200
                    const Color(0xFFF0F9FF), // Back to sky 50
                  ],
          ),
        ),
        child: user == null
            ? const Center(child: Text('No user'))
            : StreamBuilder<List<Habit>>(
              stream: habitService.streamHabits(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  debugPrint('StreamBuilder error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error loading habits: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                final habits = snapshot.data ?? [];
                final premiumService = Provider.of<PremiumService>(context);
                final isPremium = premiumService.isPremium;
                const freeHabitLimit = 3;
                final canAddMore = isPremium || habits.length < freeHabitLimit;
                debugPrint('Habits count: ${habits.length}');
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          _buildHeader(user.displayName ?? 'Friend', context, habits.length)
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .moveX(begin: -20, end: 0, duration: 400.ms),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.primary, AppTheme.secondary],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              icon: Icon(
                                canAddMore ? Icons.add_rounded : Icons.lock_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                              label: Text(
                                canAddMore
                                    ? 'Add Habit'
                                    : 'Upgrade for Unlimited Habits',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: canAddMore
                                  ? () => _openHabitForm(user.uid)
                                  : () => Navigator.pushNamed(context, '/premium'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 400.ms)
                              .scale(delay: 100.ms, begin: const Offset(0.95, 0.95), duration: 400.ms),
                          if (!isPremium && habits.length >= freeHabitLimit)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accent.withOpacity(0.2),
                                    AppTheme.primary.withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.accent.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: AppTheme.accent,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Free limit reached ($freeHabitLimit habits)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Upgrade to Premium for unlimited habits',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(context, '/premium'),
                                    child: const Text('Upgrade'),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 150.ms, duration: 400.ms)
                                .scale(delay: 150.ms, begin: const Offset(0.95, 0.95), duration: 400.ms),
                          const SizedBox(height: 12),
                          Expanded(
                            child: habits.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primary.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 64,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'No habits yet',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Start by adding your first habit!',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn().scale(delay: 200.ms)
                                : LayoutBuilder(builder: (context, constraints) {
                                    final isWide = constraints.maxWidth > 600;
                                    return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isWide ? 2 : 1,
                                        childAspectRatio: isWide ? 4 : 5,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                      ),
                                      itemCount: habits.length,
                                      itemBuilder: (context, i) => HabitCard(
                                            habit: habits[i],
                                          )
                                              .animate()
                                              .fadeIn(delay: (i * 100).ms)
                                              .scale(
                                                delay: (i * 100).ms,
                                                begin: const Offset(0.9, 0.9),
                                                duration: 400.ms,
                                              ),
                                    );
                                  }),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  void _openHabitForm(String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: HabitForm(userId: userId),
      ),
    );
  }
}
