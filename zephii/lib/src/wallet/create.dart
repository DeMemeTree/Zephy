import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';
import 'seedgrid.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String _seedPhrase = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ZephiiColors.zephPurp,
        title: const Text('Create Wallet', style: TextStyle(color: Colors.white))
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _seedPhrase.isNotEmpty ? _buildSeedPhraseContent() : _buildPasswordInput()
      ),
    );
  }

  Widget _buildPasswordInput() {
  return Column(
    children: [
      _buildSubtitle(),
      TextField(
        controller: _passwordController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          focusColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.white),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        obscureText: !_showPassword,
      ),
      const SizedBox(height: 20),
      ZButton(text: 'Create Wallet', width: 200, onPressed: _createWallet)
    ],
  );
}


  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text('Create a password to encrypt your wallet.', style: TextStyle(color: Colors.white))
    );
  }

  Widget _buildSeedPhraseContent() {
    return Column(
      children: [
        const Text('Write down all 25 words and keep the seed phrase secure. You are the only one with access to this.', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        SeedList(seedPhrase: _seedPhrase),
        const SizedBox(height: 10),
        ZButton(text: "CONFIRM", width: 200, onPressed: _writtenDownSeedPhrase)
      ],
    );
  }

  void _createWallet() {
    setState(() {
      _seedPhrase = "mocked seed phrase mocked seed phrase mocked seed phrase mocked mocked seed phrase mocked seed phrase mocked seed phrase mocked phrase mocked seed phrase mocked";
    });
  }

  void _writtenDownSeedPhrase() {
    print("User has confirmed writing down the seed phrase.");
    context.go("/home");
  }
}
