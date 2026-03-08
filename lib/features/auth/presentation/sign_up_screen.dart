import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/features/auth/presentation/auth_bloc.dart';
import 'package:pulse/features/auth/presentation/auth_error_l10n.dart';
import 'package:pulse/features/auth/presentation/auth_intent.dart';
import 'package:pulse/features/auth/presentation/auth_state.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';
import 'package:pulse/l10n/app_localizations.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isPasswordObscured = ValueNotifier<bool>(true);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.goNamed('map');
        } else if (state is AuthError) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeAuthError(state.message, l10n)),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
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
                          l10n.signUpTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16.0),
                        DarkTextField(
                          label: l10n.usernameLabel,
                          hint: l10n.usernameHint,
                          controller: usernameController,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        const SizedBox(height: 16.0),
                        DarkTextField(
                          label: l10n.emailLabel,
                          hint: l10n.emailHint,
                          controller: emailController,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 16.0),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPasswordObscured,
                          builder: (context, obscured, _) {
                            return DarkTextField(
                              label: l10n.passwordLabel,
                              hint: l10n.passwordHint,
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
                        ValueListenableBuilder<bool>(
                          valueListenable: isPasswordObscured,
                          builder: (context, obscured, _) {
                            return DarkTextField(
                              label: l10n.confirmPasswordLabel,
                              hint: l10n.passwordHint,
                              controller: confirmPasswordController,
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
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      SignUpIntent(
                                        username: usernameController.text,
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
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
                                : Text(l10n.signUpButton),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                        children: [
                          TextSpan(text: '${l10n.hasAccountPrompt} '),
                          TextSpan(
                            text: l10n.signInLink,
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.pop(),
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