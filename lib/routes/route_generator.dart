import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../screens/splash_intro_screen.dart';
import '../screens/home_screen.dart';
import '../screens/professionals_screen.dart';
import '../screens/professional_details_screen.dart';
import '../screens/choose_procedure_screen.dart';
import '../screens/choose_date_screen.dart';
import '../screens/choose_time_screen.dart';
import '../screens/confirm_screen.dart';
import '../screens/success_screen.dart';
import '../screens/procedures_screen.dart';
// Telas antigas
import '../screens/about_screen.dart';
import '../screens/services_screen.dart';
import '../screens/contact_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.intro:
      case '/': // Mantido para compatibilidade
        return _buildFadeRoute(
          const SplashIntroScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return _buildSlideRoute(
          const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.professionals:
        return _buildSlideRoute(
          const ProfessionalsScreen(),
          settings: settings,
        );

      case AppRoutes.professionalDetails:
        return _buildFadeRoute(
          const ProfessionalDetailsScreen(),
          settings: settings,
        );

      case AppRoutes.procedures:
        return _buildSlideRoute(
          const ProceduresScreen(),
          settings: settings,
        );

      case AppRoutes.chooseProcedure:
      case '/choose-procedure': // Mantido para compatibilidade
        return _buildSlideRoute(
          const ChooseProcedureScreen(),
          settings: settings,
        );

      case AppRoutes.date:
      case '/choose-date': // Mantido para compatibilidade
        return _buildSlideRoute(
          const ChooseDateScreen(),
          settings: settings,
        );

      case AppRoutes.time:
      case '/choose-time': // Mantido para compatibilidade
        return _buildSlideRoute(
          const ChooseTimeScreen(),
          settings: settings,
        );

      case AppRoutes.confirm:
        return _buildFadeRoute(
          const ConfirmScreen(),
          settings: settings,
        );

      case AppRoutes.success:
        return _buildFadeRoute(
          const SuccessScreen(),
          settings: settings,
        );

      // Rotas antigas
      case AppRoutes.about:
        return _buildSlideRoute(
          const AboutScreen(),
          settings: settings,
        );

      case AppRoutes.services:
        return _buildSlideRoute(
          const ServicesScreen(),
          settings: settings,
        );

      case AppRoutes.contact:
        return _buildSlideRoute(
          const ContactScreen(),
          settings: settings,
        );

      default:
        return _buildFadeRoute(
          const SplashIntroScreen(),
          settings: settings,
        );
    }
  }

  // Método para transição Fade (FadeTransition)
  static Route<dynamic> _buildFadeRoute(
    Widget page, {
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animação de fade
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  // Método para transição Slide (SlideTransition)
  static Route<dynamic> _buildSlideRoute(
    Widget page, {
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 300),
    Offset beginOffset = const Offset(1.0, 0.0), // Slide da direita por padrão
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animação de slide
        final slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  // Método combinado: Fade + Slide (mantido para compatibilidade)
  static Route<dynamic> _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combinação de Fade e Slide
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var slideAnimation = Tween(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );

        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
