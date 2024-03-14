import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';

class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});
  @override
  _UnlockScreenState createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = true;
  bool _isPasswordObscured = true;

  void _unlockWallet() {
    String password = _passwordController.text;
    print('Attempting to unlock with password: $password');
    context.go("/home");
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ZephiiColors.zephPurp,
        title: const Text('UNLOCK WALLET',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _textInputView(),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ZButton(text: "Unlock", width: 200, onPressed: _unlockWallet)
            )
          ],
        ),
      ),
    );
  }

  Widget _textInputView() {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordObscured,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7)), // For better visibility
        errorText: _isPasswordValid ? null : 'Invalid password',
        suffixIcon: IconButton(
          icon: Icon(
            // Toggles the icon based on whether the password is obscured
            _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          // Ensures visibility on the dark background
          borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
