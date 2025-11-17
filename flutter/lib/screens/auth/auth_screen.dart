import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/theme/app_theme.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/app_button.dart';
import 'package:inswing/widgets/common/app_text_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final bool isLoginMode;
  final String? phoneNumber;

  const AuthScreen({
    super.key,
    required this.isLoginMode,
    this.phoneNumber,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phoneNumber = _phoneController.text.trim();
      
      // Request OTP
      final success = await ref.read(authProvider.notifier).requestOtp(phoneNumber);
      
      if (success && mounted) {
        // Navigate to OTP verification
        context.push('/verify-otp', extra: phoneNumber);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send OTP. Please try again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleOtpSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phoneNumber = widget.phoneNumber!;
      final otp = _otpController.text.trim();
      
      // Verify OTP and login
      final success = await ref.read(authProvider.notifier).verifyOtpAndLogin(
        phoneNumber,
        otp,
      );
      
      if (success && mounted) {
        // Navigate to home
        context.go('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                // App logo/title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.sports_cricket,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'inSwing',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Real-time Cricket Scoring',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                // Title
                Text(
                  widget.isLoginMode ? 'Enter Phone Number' : 'Verify OTP',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isLoginMode
                      ? 'We\'ll send you an OTP to verify your number'
                      : 'Enter the 6-digit code sent to ${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Phone number input (login mode)
                if (widget.isLoginMode) ...[
                  AppTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    prefixIcon: const Icon(Icons.phone_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                
                // OTP input (verification mode)
                if (!widget.isLoginMode) ...[
                  AppTextField(
                    controller: _otpController,
                    label: 'OTP Code',
                    hint: '123456',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP code';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Resend OTP button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : () {
                          // Navigate back to phone input
                          context.pop();
                        },
                        child: const Text('Resend'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                
                const SizedBox(height: 32), // Replace Spacer with fixed height
                
                // Submit button
                AppButton(
                  onPressed: _isLoading 
                      ? null 
                      : (widget.isLoginMode ? _handlePhoneSubmit : _handleOtpSubmit),
                  text: _isLoading ? 'Processing...' : (widget.isLoginMode ? 'Send OTP' : 'Verify & Login'),
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Terms and privacy
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}