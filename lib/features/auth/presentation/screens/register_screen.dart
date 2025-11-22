import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validation_utils.dart';
import '../providers/auth_providers.dart';
import '../../../onboarding/presentation/widgets/space_parallax_background.dart';

/// Register screen with email/password signup and Google Sign-In
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions'),
        ),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim().isEmpty
              ? null
              : _displayNameController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.of(context).pop(); // Go back to login or let router handle it
    }
  }

  Future<void> _handleGoogleSignUp() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions'),
        ),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).signInWithGoogle();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created with Google!')),
      );
      Navigator.of(context).pop();
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Conditions', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Text(
            'By using StorySpace, you agree to:\n\n'
            '1. Use the app for personal, non-commercial purposes\n'
            '2. Create appropriate content suitable for children\n'
            '3. Respect intellectual property rights\n'
            '4. Not misuse or abuse the AI generation service\n'
            '5. Comply with all applicable laws and regulations\n\n'
            'StorySpace reserves the right to:\n'
            '- Modify or terminate the service at any time\n'
            '- Remove content that violates our policies\n'
            '- Update these terms with notice to users\n\n'
            'For full terms, visit: storyspace.app/terms',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Text(
            'StorySpace Privacy Policy:\n\n'
            'We collect:\n'
            '- Account information (email, name)\n'
            '- Kid profile information (name, age)\n'
            '- Story generation preferences\n'
            '- Usage analytics\n\n'
            'We use this data to:\n'
            '- Provide and improve our services\n'
            '- Generate personalized stories\n'
            '- Communicate with you about updates\n\n'
            'We do NOT:\n'
            '- Sell your personal information\n'
            '- Share data with third parties without consent\n'
            '- Use children\'s data for advertising\n\n'
            'For full privacy policy, visit: storyspace.app/privacy',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Space parallax background
          const SpaceParallaxBackground(
            pageOffset: 0.0,
            currentPage: 1,
          ),

          // Main content
          Column(
            children: [
              // Custom app bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          Text(
                            'Join StorySpace!',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your account to start your adventure',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: const Color(0xFFFFF8F0),
                              shadows: [
                                const Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Display name field (optional)
                          TextFormField(
                            controller: _displayNameController,
                            decoration: InputDecoration(
                              labelText: 'Name (Optional)',
                              hintText: 'Your name',
                              prefixIcon: const Icon(Icons.person_outlined),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'your@email.com',
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: ValidationUtils.validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            validator: ValidationUtils.validatePassword,
                          ),
                          const SizedBox(height: 16),

                          // Confirm password field
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleSignUp(),
                            validator: (value) => ValidationUtils.validatePasswordConfirmation(
                              value,
                              _passwordController.text,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Terms checkbox
                          CheckboxListTile(
                            value: _acceptedTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                            checkColor: Colors.white,
                            title: RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _showTermsAndConditions,
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _showPrivacyPolicy,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          if (authState.error != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.error),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: AppColors.error),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      authState.error!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Create account button
                          ElevatedButton(
                            onPressed: authState.isLoading ? null : _handleSignUp,
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Create Account'),
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Colors.white38)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(color: Colors.white38)),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Google Sign-In button
                          OutlinedButton.icon(
                            onPressed: authState.isLoading ? null : _handleGoogleSignUp,
                            icon: const Icon(Icons.account_circle, size: 24),
                            label: const Text('Continue with Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.white.withOpacity(0.1),
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white38),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Sign in link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
