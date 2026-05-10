import 'package:entrenaop/core/di/injection_container.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://izzsttrrgrowktfjssqv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml6enN0dHJyZ3Jvd2t0Zmpzc3F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzMjYzNTksImV4cCI6MjA5MzkwMjM1OX0.Q84u4AogvIta5rRwe3m-sbZo_yLlkIkD9udnbUEXaoc',
  );

  await initDependencies();

  runApp(const EntrenaOpApp());
}

class EntrenaOpApp extends StatelessWidget {
  const EntrenaOpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EntrenaOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    );
  }
}
