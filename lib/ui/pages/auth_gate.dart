import 'package:flutter/material.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_stream/auth_gate_stream.dart';
import 'package:socnet/ui/pages/splash_screen.dart';

import '../../logic/di.dart';
import '../widgets/z_stream_builder.dart';
import 'auth_page.dart';
import 'my_profile_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZStreamBuilder<AuthState>(
      stream: sl<AuthGateStream>(),
      loading: SplashScreen(),
      loadedBuilder: (authState) => authState.isAuthenticated ? MyProfilePage() : AuthPage(),
    );
  }
}
