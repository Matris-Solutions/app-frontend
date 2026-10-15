import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import '../models/parish_model.dart';
import '../services/auth_service.dart';
import '../services/parish_service.dart';
import 'auth_screen.dart';
import 'parish_detail_screen.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final isAuthenticated = authService.isAuthenticated;
        final profile = authService.currentProfile;
        final user = authService.currentUser;

        final displayName = profile?.fullName?.isNotEmpty == true
            ? profile!.fullName!
            : (user?.email?.split('@').first ?? 'Guest User');

        final email = profile?.email ?? user?.email ?? 'Not signed in';

        String initials = 'GU';
        if (displayName.isNotEmpty) {
          final parts = displayName.trim().split(' ');
          if (parts.length >= 2) {
            initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
          } else if (parts[0].isNotEmpty) {
            initials = parts[0][0].toUpperCase();
          }
        }

        final roleText = profile?.role.replaceAll('_', ' ').toUpperCase() ?? 'PARISH MEMBER';

        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 118),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR ACCOUNT',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showNotificationsDialog(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_none, size: 22, color: AppColors.ink),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (!isAuthenticated) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.account_circle_outlined, size: 54, color: AppColors.green),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome to Parish Hub',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign in or create an account to save events, join parish activities, and connect with your local church community.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In / Create Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Member Identity
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(color: Color(0x3328553A), blurRadius: 24, offset: Offset(0, 8)),
                            ],
                            gradient: const RadialGradient(
                              center: Alignment(-0.3, -0.44),
                              radius: 0.28,
                              colors: [Color(0x2EFFFFFF), AppColors.green],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 3,
                          bottom: 5,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.parchment, width: 3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: 'Newsreader',
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      email,
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.greenPale,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        roleText,
                        style: const TextStyle(
                          color: AppColors.greenDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Faith Summary
              _buildFaithSummaryCard(context, profile?.assignedParishId),

              // Home Parish Card
              const SizedBox(height: 14),
              _buildHomeParishCard(context, profile?.assignedParishId),

              // My Parish Hub Section
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 2, bottom: 9),
                child: Text('My Parish Hub', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              ),
              _buildMenuSection([
                _MenuItem(
                  Icons.calendar_today,
                  'My events',
                  'Registrations and saved events',
                  false,
                  onTap: () => _showMyEventsDialog(context, profile?.assignedParishId),
                ),
                _MenuItem(
                  Icons.church,
                  'My ministries',
                  'Groups, schedules, and service',
                  true,
                  onTap: () => _showMyMinistriesDialog(context, profile?.assignedParishId),
                ),
              ]),

              // Account Section
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 2, bottom: 9),
                child: Text('Account', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              ),
              _buildMenuSection([
                _MenuItem(
                  Icons.person_outline,
                  'Personal information',
                  'Name, email, phone, and address',
                  false,
                  onTap: () => _showEditPersonalInformationDialog(context, authService),
                ),
                _MenuItem(
                  Icons.notifications_none,
                  'Notifications',
                  'Mass reminders, news, and events',
                  false,
                  onTap: () => _showNotificationsDialog(context),
                ),
              ]),

              // Support Section
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 2, bottom: 9),
                child: Text('Support', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              ),
              _buildMenuSection([
                _MenuItem(
                  Icons.lock_outline,
                  'Privacy & security',
                  'Password and security preferences',
                  false,
                  onTap: () => _showChangePasswordDialog(context, authService),
                ),
              ]),

              // Sign Out Button
              const SizedBox(height: 22),
              GestureDetector(
                onTap: () => authService.signOut(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9F6),
                    border: Border.all(color: const Color(0xFFEAD8D1)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign out',
                    style: TextStyle(color: Color(0xFF9A4B3B), fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Text(
              'Parish Hub · Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9AA19C), fontSize: 8),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFaithSummaryCard(BuildContext context, String? parishId) {
    if (parishId == null || parishId.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(17),
          boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: const [
                  Text('0', style: TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 21, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Saved events', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                ],
              ),
            ),
            Container(width: 1, height: 30, color: AppColors.line),
            Expanded(
              child: Column(
                children: const [
                  Text('0', style: TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 21, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Ministries', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<ParishModel?>(
      future: ParishService().getParishById(parishId),
      builder: (context, snapshot) {
        final parish = snapshot.data;
        final ministryCount = parish?.activities.length ?? 0;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(17),
            boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      ministryCount > 0 ? '$ministryCount' : '0',
                      style: const TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    const Text('Parish ministries', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: AppColors.line),
              Expanded(
                child: Column(
                  children: const [
                    Text('Active', style: TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Member Status', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeParishCard(BuildContext context, String? assignedParishId) {
    if (assignedParishId == null || assignedParishId.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'MY HOME PARISH',
              style: TextStyle(color: AppColors.gold, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.8),
            ),
            SizedBox(height: 6),
            Text(
              'No Home Parish Selected',
              style: TextStyle(fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
            ),
            SizedBox(height: 4),
            Text(
              'Go to Parishes tab & select "SET AS MY HOME PARISH"',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<ParishModel?>(
      future: ParishService().getParishById(assignedParishId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 78,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        final parish = snapshot.data;
        if (parish == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParishDetailScreen(parish: parish)),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: parish.imageUrl != null && parish.imageUrl!.isNotEmpty
                      ? Image.network(
                          parish.imageUrl!,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackIcon(),
                        )
                      : _buildFallbackIcon(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MY HOME PARISH',
                        style: TextStyle(color: AppColors.gold, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        parish.name,
                        style: const TextStyle(fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 13, color: AppColors.muted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              parish.locationSummary,
                              style: const TextStyle(color: AppColors.muted, fontSize: 9),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 19, color: AppColors.ink),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 58,
      height: 58,
      color: AppColors.greenPale,
      child: const Icon(Icons.church, color: AppColors.green, size: 28),
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x0B203527), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final int idx = entry.key;
          final _MenuItem item = entry.value;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: AppColors.line),
              GestureDetector(
                onTap: item.onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          color: item.isGold ? AppColors.goldPale : AppColors.greenPale,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(item.icon, size: 19, color: item.isGold ? const Color(0xFF8D6B2F) : AppColors.green),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.ink)),
                            const SizedBox(height: 2),
                            Text(item.subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 9), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      if (item.badgeText != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(item.badgeText!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(Icons.chevron_right, size: 17, color: AppColors.ink),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showEditPersonalInformationDialog(BuildContext context, AuthService authService) {
    final profile = authService.currentProfile;
    final user = authService.currentUser;
    final nameController = TextEditingController(text: profile?.fullName ?? '');
    final emailController = TextEditingController(text: profile?.email ?? user?.email ?? '');
    final phoneController = TextEditingController(text: profile?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'Update your profile details saved in Supabase',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email Address (Registered Account)',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Email is associated with your primary Supabase auth account',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authService.updateProfileInfo(
                      fullName: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Personal information updated!'),
                          backgroundColor: AppColors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update profile: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthService authService) {
    final userEmail = authService.currentUser?.email ?? authService.currentProfile?.email ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Password & Security',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'For security purposes, passwords can only be reset via a secure link sent to your registered email.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Email Reset Link Option
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.greenPale,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.mark_email_read_outlined, color: AppColors.green, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A password reset link will be sent to:\n$userEmail',
                      style: const TextStyle(fontSize: 12, color: AppColors.ink, height: 1.3),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (userEmail.isEmpty) return;
                          try {
                            await authService.sendPasswordResetEmail(userEmail);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Password reset link sent to $userEmail! Check your inbox.'),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error sending reset email: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.send, size: 16),
                        label: const Text('Send Password Reset Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        bool massReminders = true;
        bool parishNews = true;
        bool dailyReadings = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeThumbColor: AppColors.green,
                    title: const Text('Mass Schedule Reminders'),
                    subtitle: const Text('Get notified before Sunday and Weekday Mass'),
                    value: massReminders,
                    onChanged: (val) => setState(() => massReminders = val),
                  ),
                  SwitchListTile(
                    activeThumbColor: AppColors.green,
                    title: const Text('Parish Announcements & Events'),
                    subtitle: const Text('Updates on community events and feast days'),
                    value: parishNews,
                    onChanged: (val) => setState(() => parishNews = val),
                  ),
                  SwitchListTile(
                    activeThumbColor: AppColors.green,
                    title: const Text('Daily Liturgical Readings'),
                    subtitle: const Text('Morning notifications for daily Mass readings'),
                    value: dailyReadings,
                    onChanged: (val) => setState(() => dailyReadings = val),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification preferences saved!'),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMyEventsDialog(BuildContext context, String? parishId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Events & Registrations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'Events you have registered for or saved',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              const ListTile(
                leading: Icon(Icons.event, color: AppColors.green),
                title: Text('Parish Youth Retreat'),
                subtitle: Text('July 18–20 · Registered'),
              ),
              const ListTile(
                leading: Icon(Icons.event, color: AppColors.green),
                title: Text('Feast Day Celebration'),
                subtitle: Text('Upcoming Community Gathering'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMyMinistriesDialog(BuildContext context, String? parishId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Parish Ministries',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'Volunteering and parish service groups',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              const ListTile(
                leading: Icon(Icons.groups, color: AppColors.green),
                title: Text('Lector / Reader Ministry'),
                subtitle: Text('Active Member'),
              ),
              const ListTile(
                leading: Icon(Icons.volunteer_activism, color: AppColors.green),
                title: Text('Youth Choir & Music'),
                subtitle: Text('Weekly Rehearsals'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGold;
  final String? badgeText;
  final VoidCallback? onTap;

  _MenuItem(this.icon, this.title, this.subtitle, this.isGold, {this.badgeText, this.onTap});
}
