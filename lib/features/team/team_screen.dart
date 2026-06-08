import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom/safe_lottie.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class TeamMember {
  final String id, name, role, department;
  final String avatarInitials;
  final Color avatarColor;
  final bool isOnline;
  final int tasksCompleted;
  final String joinedDate;
  final List<String> skills;
  final String email;
  final String? photoUrl;

  const TeamMember({
    required this.id, required this.name, required this.role,
    required this.department, required this.avatarInitials,
    required this.avatarColor, required this.isOnline,
    required this.tasksCompleted, required this.joinedDate,
    required this.skills, required this.email, this.photoUrl,
  });
}

const teamMembers = [
  TeamMember(id: 't1', name: 'Priya Sharma', role: 'Flutter Dev', department: 'Engineering', avatarInitials: 'PS', avatarColor: Color(0xFF7C3AED), isOnline: true, tasksCompleted: 18, joinedDate: 'May 2026', skills: ['Flutter', 'Dart', 'Firebase'], email: 'priya.s@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t1'),
  TeamMember(id: 't2', name: 'Rohan Gupta', role: 'UI/UX Designer', department: 'Design', avatarInitials: 'RG', avatarColor: Color(0xFFEC4899), isOnline: true, tasksCompleted: 22, joinedDate: 'May 2026', skills: ['Figma', 'Lottie', 'Prototyping'], email: 'rohan.g@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t2'),
  TeamMember(id: 't3', name: 'Arjun Mehta', role: 'Backend Dev', department: 'Engineering', avatarInitials: 'AM', avatarColor: Color(0xFF10B981), isOnline: false, tasksCompleted: 15, joinedDate: 'May 2026', skills: ['Node.js', 'Firebase', 'REST API'], email: 'arjun.m@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t3'),
  TeamMember(id: 't4', name: 'Sneha Patel', role: 'Product Manager', department: 'Product', avatarInitials: 'SP', avatarColor: Color(0xFFFFB84C), isOnline: true, tasksCompleted: 30, joinedDate: 'Apr 2026', skills: ['Jira', 'Scrum', 'Analytics'], email: 'sneha.p@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t4'),
  TeamMember(id: 't5', name: 'Karan Singh', role: 'Data Analyst', department: 'Analytics', avatarInitials: 'KS', avatarColor: Color(0xFF00D9F5), isOnline: false, tasksCompleted: 12, joinedDate: 'May 2026', skills: ['Python', 'SQL', 'Tableau'], email: 'karan.s@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t5'),
  TeamMember(id: 't6', name: 'Ananya Roy', role: 'QA Engineer', department: 'Quality', avatarInitials: 'AR', avatarColor: Color(0xFFFF6B6B), isOnline: true, tasksCompleted: 25, joinedDate: 'May 2026', skills: ['Testing', 'Selenium', 'Flutter Test'], email: 'ananya.r@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t6'),
  TeamMember(id: 't7', name: 'Vikram Nair', role: 'DevOps Intern', department: 'Infrastructure', avatarInitials: 'VN', avatarColor: Color(0xFF6366F1), isOnline: false, tasksCompleted: 9, joinedDate: 'Jun 2026', skills: ['Docker', 'CI/CD', 'AWS'], email: 'vikram.n@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t7'),
  TeamMember(id: 't8', name: 'Pooja Yadav', role: 'iOS Developer', department: 'Engineering', avatarInitials: 'PY', avatarColor: Color(0xFFF59E0B), isOnline: true, tasksCompleted: 20, joinedDate: 'May 2026', skills: ['Swift', 'SwiftUI', 'Xcode'], email: 'pooja.y@nexus.io', photoUrl: 'https://i.pravatar.cc/150?u=t8'),
];

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: const LottieHamburger(),
              title: Row(children: [
                Text('Team', style: Theme.of(context).textTheme.headlineLarge),
                const Spacer(),
                const SafeLottie(assetPath: 'assets/lottie/team_connect.json',
                  width: 40, height: 40,
                  fallback: Icon(Icons.group_rounded,
                    color: AppColors.neonCyan, size: 28)),
              ]),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  _TeamStat(
                    label: 'Members', value: '${teamMembers.length}',
                    icon: Icons.people_rounded, color: AppColors.neonCyan),
                  const SizedBox(width: 12),
                  _TeamStat(
                    label: 'Online',
                    value: '${teamMembers.where((m) => m.isOnline).length}',
                    icon: Icons.circle, color: AppColors.neonGreen),
                  const SizedBox(width: 12),
                  _TeamStat(
                    label: 'Tasks Done',
                    value: '${teamMembers.fold(0, (int s, m) => s + m.tasksCompleted)}',
                    icon: Icons.task_alt_rounded, color: AppColors.neonAmber),
                ]).animate().fadeIn(delay: 200.ms),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12, mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final member = teamMembers[i];
                    return GestureDetector(
                      onTap: () => _showMemberDetail(context, member),
                      child: Hero(
                        tag: 'team_member_${member.id}',
                        child: _TeamMemberCard(member: member)
                          .animate(delay: (80 * i).ms)
                          .fadeIn().slideY(begin: 0.3),
                      ),
                    );
                  },
                  childCount: teamMembers.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDetail(BuildContext ctx, TeamMember member) {
    showModalBottomSheet(
      context: ctx,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MemberDetailSheet(member: member),
    );
  }
}

class _TeamStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _TeamStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.orbitron(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberCard extends StatefulWidget {
  final TeamMember member;
  const _TeamMemberCard({required this.member});

  @override
  State<_TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<_TeamMemberCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.diagonal3Values(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.member.isOnline
            ? AppColors.neonGreen.withValues(alpha: 0.3)
            : Colors.transparent),
        boxShadow: _isHovered ? [
          BoxShadow(
            color: widget.member.avatarColor.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ] : [],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: widget.member.avatarColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.member.avatarColor, width: 2),
                ),
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                child: widget.member.photoUrl == null
                  ? Text(widget.member.avatarInitials,
                      style: GoogleFonts.orbitron(
                        color: widget.member.avatarColor,
                        fontSize: 22, fontWeight: FontWeight.w700))
                  : CachedNetworkImage(
                      imageUrl: widget.member.photoUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => CircularProgressIndicator(color: widget.member.avatarColor, strokeWidth: 2),
                      errorWidget: (context, url, error) => Text(widget.member.avatarInitials, style: GoogleFonts.orbitron(color: widget.member.avatarColor, fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
              ),
              if (widget.member.isOnline)
                Positioned(
                  bottom: 2, right: 2,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        width: 2)),
                  ).animate(onPlay: (c) => c.repeat())
                   .scaleXY(begin: 0.85, end: 1.1, duration: 1000.ms)
                   .then().scaleXY(begin: 1.1, end: 0.85, duration: 1000.ms),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.member.name,
            style: GoogleFonts.sora(
              fontWeight: FontWeight.w700, fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
            maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: widget.member.avatarColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20)),
            child: Text(widget.member.role,
              style: GoogleFonts.sora(
                fontSize: 11, color: widget.member.avatarColor,
                fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          // Email button with micro-interaction
          GestureDetector(
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) {
              setState(() => _isHovered = false);
              HapticFeedback.lightImpact();
              // Action: open email intent
            },
            onTapCancel: () => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _isHovered ? widget.member.avatarColor.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.member.avatarColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_rounded, size: 14, color: widget.member.avatarColor),
                  const SizedBox(width: 4),
                  Text('Email', style: GoogleFonts.sora(fontSize: 10, color: widget.member.avatarColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _MemberDetailSheet extends StatelessWidget {
  final TeamMember member;
  const _MemberDetailSheet({required this.member});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white24,
              borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Hero(
            tag: 'team_member_${member.id}',
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: member.avatarColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: member.avatarColor, width: 3),
              ),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              child: member.photoUrl == null
                ? Text(member.avatarInitials,
                    style: GoogleFonts.orbitron(
                      color: member.avatarColor,
                      fontSize: 32, fontWeight: FontWeight.w700))
                : CachedNetworkImage(
                    imageUrl: member.photoUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => CircularProgressIndicator(color: member.avatarColor, strokeWidth: 3),
                    errorWidget: (context, url, error) => Text(member.avatarInitials, style: GoogleFonts.orbitron(color: member.avatarColor, fontSize: 32, fontWeight: FontWeight.w700)),
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Text(member.name,
            style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface)),
          Text('${member.role} · ${member.department}',
            style: TextStyle(color: member.avatarColor)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: member.isOnline ? AppColors.neonGreen : Colors.grey,
                shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(member.isOnline ? 'Online now' : 'Offline',
              style: TextStyle(
                color: member.isOnline ? AppColors.neonGreen : Colors.grey,
                fontSize: 13)),
          ]),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 16, color: AppColors.lightSubtext),
              const SizedBox(width: 8),
              Text(member.email, style: const TextStyle(color: AppColors.lightSubtext)),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8, runSpacing: 8,
            alignment: WrapAlignment.center,
            children: member.skills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: member.avatarColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: member.avatarColor.withValues(alpha: 0.4))),
              child: Text(skill, style: TextStyle(
                color: member.avatarColor, fontSize: 12,
                fontWeight: FontWeight.w600)),
            )).toList(),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBadge(label: 'Tasks Done', value: '${member.tasksCompleted}', color: AppColors.neonAmber),
              _StatBadge(label: 'Joined', value: member.joinedDate, color: AppColors.neonCyan),
            ],
          ),
        ],
      ),
    );
  }
}
