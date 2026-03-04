import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/features/auth/presentation/auth_bloc.dart';
import 'package:pulse/features/auth/presentation/auth_intent.dart';
import 'package:pulse/features/auth/presentation/auth_state.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isPasswordObscured = ValueNotifier<bool>(true);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.goNamed('map');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          // BOTÓN DE RETROCESO: cierra el flujo de auth y regresa al mapa.
          // context.go('/') limpia la pila completa, evitando que login
          // quede vivo detrás si el usuario llegó desde un deep link.
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.go('/'),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Iniciar Sesión',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16.0),
                        DarkTextField(
                          label: 'Correo electrónico',
                          hint: 'example@correo.com',
                          controller: emailController,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 16.0),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPasswordObscured,
                          builder: (context, obscured, _) {
                            return DarkTextField(
                              label: 'Contraseña',
                              hint: '12345678',
                              controller: passwordController,
                              prefixIcon: const Icon(Icons.password),
                              obscureText: obscured,
                              suffixIcon: IconButton(
                                onPressed: () => isPasswordObscured.value =
                                    !isPasswordObscured.value,
                                icon: Icon(
                                  obscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: .centerEnd,
                          child: TextButton(
                            onPressed: isLoading ? null : () {},
                            child: const Text('¿Olvidaste tu contraseña?'),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      SignInIntent(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Iniciar Sesión'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                        children: [
                          const TextSpan(text: '¿No tienes una cuenta? '),
                          TextSpan(
                            text: 'Regístrate',
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.pushNamed(
                                RouterNames.signUp,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}