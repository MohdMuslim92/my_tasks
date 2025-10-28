import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef AuthFormSubmit = Future<void> Function({
  required String email,
  required String password,
});

class AuthForm extends StatefulWidget {
  final bool isRegister;
  final String submitLabel;
  final AuthFormSubmit onSubmit;

  // Initial values (for demo credentials)
  final String? initialEmail;
  final String? initialPassword;

  // When this value changes, AuthForm will force-clear and prefill controllers.
  final int prefillNonce;

  const AuthForm({
    super.key,
    required this.onSubmit,
    this.isRegister = false,
    this.submitLabel = 'Submit',
    this.initialEmail,
    this.initialPassword,
    this.prefillNonce = 0,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Set initial values if provided
    if (widget.initialEmail != null) _emailCtl.text = widget.initialEmail!;
    if (widget.initialPassword != null) {
      _passCtl.text = widget.initialPassword!;
      _confirmCtl.text = widget.initialPassword!;
    }
  }

  @override
  void didUpdateWidget(covariant AuthForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If parent updated initial values, reflect them in controllers.
    // This previous behavior only updated when values changed; but we also
    // support a prefillNonce to force re-apply initial values even if identical.
    final emailChanged = widget.initialEmail != oldWidget.initialEmail;
    final passChanged = widget.initialPassword != oldWidget.initialPassword;
    final forcePrefill = widget.prefillNonce != oldWidget.prefillNonce;

    if (emailChanged || forcePrefill) {
      _emailCtl
        ..clear()
        ..text = widget.initialEmail ?? '';
    }

    if (passChanged || forcePrefill) {
      _passCtl
        ..clear()
        ..text = widget.initialPassword ?? '';
      _confirmCtl
        ..clear()
        ..text = widget.initialPassword ?? '';
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  String _friendlyFirebaseAuthMessage(FirebaseAuthException e) {
    if (!widget.isRegister) {
      const loginGeneric = 'Invalid email or password.';
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
          return loginGeneric;
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return 'Authentication failed. Please check your credentials.';
      }
    } else {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already in use. Try signing in or use a different email.';
        case 'invalid-email':
          return 'Enter a valid email address.';
        case 'weak-password':
          return 'Password is too weak. Use a stronger password (6+ chars).';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled.';
        default:
          return 'Registration failed. Please try again.';
      }
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtl.text.trim();
    final password = _passCtl.text;

    if (widget.isRegister) {
      if (_confirmCtl.text != password) {
        setState(() => _error = 'Passwords do not match');
        return;
      }
    }

    setState(() => _loading = true);

    try {
      await widget.onSubmit(email: email, password: password);
      // parent handles navigation/binding
    } on FirebaseAuthException catch (e) {
      // Show friendly mapped message instead of raw e.message
      setState(() => _error = _friendlyFirebaseAuthMessage(e));
    } catch (e) {
      // Generic fallback for network / unexpected errors
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: _emailCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Email'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
              return null;
            },
            enabled: !_loading,
          ),
          const SizedBox(height: 12),

          // Password
          TextFormField(
            controller: _passCtl,
            obscureText: _obscure,
            decoration: _inputDecoration('Password').copyWith(
              suffixIcon: IconButton(
                tooltip: _obscure ? 'Show password' : 'Hide password',
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 4) return 'Password must be 4+ chars';
              return null;
            },
            enabled: !_loading,
          ),
          const SizedBox(height: 12),

          // Confirm password displayed on register only
          if (widget.isRegister)
            Column(
              children: [
                TextFormField(
                  controller: _confirmCtl,
                  obscureText: _obscure,
                  decoration: _inputDecoration('Confirm password'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm password';
                    if (v.length < 4) return 'Password must be 4+ chars';
                    return null;
                  },
                  enabled: !_loading,
                ),
                const SizedBox(height: 12),
              ],
            ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleSubmit,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(widget.submitLabel),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
