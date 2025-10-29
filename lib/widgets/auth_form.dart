import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    if (!widget.isRegister) {
      const loginGeneric = 'Invalid email or password.';
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
          return loc.authInvalidCredentials;
        case 'too-many-requests':
          return loc.authTooManyRequests;
        default:
          return loc.authGenericFailure;
      }
    } else {
      switch (e.code) {
        case 'email-already-in-use':
          return loc.registerEmailInUse;
        case 'invalid-email':
          return loc.registerInvalidEmail;
        case 'weak-password':
          return loc.registerWeakPassword;
        case 'operation-not-allowed':
          return loc.registerOperationNotAllowed;
        default:
          return loc.registerGenericFailure;
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
        setState(() => _error = AppLocalizations.of(context)!.passwordsDoNotMatch);
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
      setState(() => _error = AppLocalizations.of(context)!.unexpectedError);
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
    final loc = AppLocalizations.of(context)!;
    const minLen = 4;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: _emailCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(loc.emailLabel),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return loc.emailRequired;
              final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(v.trim())) return loc.enterValidEmail;
              return null;
            },
            enabled: !_loading,
          ),
          const SizedBox(height: 12),

          // Password
          TextFormField(
            controller: _passCtl,
            obscureText: _obscure,
            decoration: _inputDecoration(loc.passwordLabel).copyWith(
              suffixIcon: IconButton(
                tooltip: _obscure ? loc.showPassword : loc.hidePassword,
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return loc.passwordRequired;
              if (v.length < minLen) return loc.passwordMinLength(minLen);
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
                  decoration: _inputDecoration(loc.confirmPasswordLabel),
                  validator: (v) {
                    if (v == null || v.isEmpty) return loc.passwordRequired;
                    if (v.length < minLen) return loc.passwordMinLength(minLen);
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
