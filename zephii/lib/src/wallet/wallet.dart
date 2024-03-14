import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:zephii/src/uiwidgets/zbutton.dart';
import 'package:zephii/src/extensions/color.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<String> wallets = [
    "Wallet 1",
    "Wallet 2",
    "Wallet 3",
    "Wallet 4",
    "Wallet 5",
    "Wallet 6",
    "Wallet 7",
    "Wallet 8",
    "Wallet 9"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text('Zephii',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          _buildLogo(),
          const SizedBox(height: 20),
          _buildWalletsList(),
          _buildActionButtons(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
      SizedBox(
        width: 100,
        height: 100,
        child: Image.asset('assets/zephyr-logo.png', fit: BoxFit.contain),
      ),
      const SizedBox(height: 10),
      const Text(
        'Privately store, and transfer assets without ever relinquishing custody.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      )
    ]);
  }

  Widget _buildWalletsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final item = wallets[index];
          return ListTile(
            title: Text(item,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              context.go("/wallet/unlock");
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ZButton(
            text: "RESTORE",
            width: MediaQuery.of(context).size.width * 0.4,
            onPressed: () {
              context.go("/wallet/restore");
            }),
        const SizedBox(width: 20),
        ZButton(
            text: "CREATE NEW",
            width: MediaQuery.of(context).size.width * 0.4,
            onPressed: () {
              context.go("/wallet/create");
            })
      ],
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Wallet'),
          content: Text('Are you sure you want to delete ${wallets[index]}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => wallets.removeAt(index));
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
