import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<({String path, IconData icon, IconData activeIcon, String label})> _tabs = [
    (path: '/home', icon: Icons.today_outlined, activeIcon: Icons.today, label: 'Hoy'),
    (path: '/exercises', icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: 'Ejercicios'),
    (path: '/routines', icon: Icons.list_alt_outlined, activeIcon: Icons.list_alt, label: 'Rutinas'),
    (path: '/profile', icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
  ];

  int _locationToIndex(String location) {
    if (location.startsWith('/exercises')) return 1;
    if (location.startsWith('/routines')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    _currentIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isActive = _currentIndex == i;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.path),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive
                              ? const Color(0xFFE65100)
                              : Colors.white38,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            color: isActive ? const Color(0xFFE65100) : Colors.white38,
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
