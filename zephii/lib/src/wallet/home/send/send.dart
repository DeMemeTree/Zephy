import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';

class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  _SendViewState createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  String selectedAsset = 'ZEPH';
  final Map<String, String> assets = {
    'ZEPH': 'assets/zephyr-logo.png',
    'ZSD': 'assets/zsd-logo.png',
    'ZRS': 'assets/zrs-logo.png',
  };
  double availableBalance = 5.0; // Example balance
  String sendingAmount = '0.0';
  double estimatedFee = 0.0;
  final TextEditingController _amountController = TextEditingController();
  String recipientAddress = '';
  bool isConfirming = false;

  void _setMaxAmount() {
    setState(() {
      sendingAmount = availableBalance.toString();
      _amountController.text = sendingAmount;
    });
  }

  void _confirmSend() {
    setState(() {
      isConfirming = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      // Simulate sending process
      print('Sending $sendingAmount $selectedAsset to $recipientAddress');
      // Reset state after sending
      setState(() {
        isConfirming = false;
        sendingAmount = '0.0';
        _amountController.text = '';
        recipientAddress = '';
      });

      context.go("/home");
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
          backgroundColor: ZephiiColors.zephPurp,
          foregroundColor: Colors.white,
          title: Text(isConfirming ? 'CONFIRM' : 'SEND',
              style: const TextStyle(color: Colors.white))),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isConfirming ? _confirmationView() : _sendView(),
      ),
    );
  }

  Widget _sendView() {
    return Padding(padding: const EdgeInsets.all(20),
    child: 
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Select Asset:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Spacer(),
            DropdownButton<String>(
              dropdownColor: ZephiiColors.zephPurp,
              style: const TextStyle(color: Colors.white),
              value: selectedAsset,
              onChanged: (String? newValue) {
                setState(() {
                  selectedAsset = newValue!;
                });
              },
              items: assets.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Image.asset(assets[value]!, width: 24),
                      const SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            )
          ]),
          const SizedBox(height: 20),
          _amountAndBalanceRow(),
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.grey),
                labelText: 'Recipient Address'),
            onChanged: (value) {
              setState(() {
                recipientAddress = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ZButton(
              text: "ESTIMATE FEE",
              onPressed: () => setState(() => isConfirming = true))
        ],
      ));
  }

  Widget _amountAndBalanceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey),
              labelText: 'Available: $availableBalance $selectedAsset',
            ),
            onChanged: (value) {
              setState(() {
                sendingAmount = value;
              });
            },
          ),
        ),
        TextButton(
          onPressed: _setMaxAmount,
          child: const Text('MAX'),
        )
      ],
    );
  }

  Widget _confirmationView() {
    // Calculate estimated fee here or obtain it from a previous step
    estimatedFee = 0.1; // Example fixed fee for demonstration

    return Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            title: const Text('Selected Asset',
                style: TextStyle(color: Colors.grey)),
            subtitle: Text(selectedAsset,
                style: const TextStyle(color: Colors.white)),
            leading: Image.asset(assets[selectedAsset]!),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            title: const Text('Amount', style: TextStyle(color: Colors.grey)),
            subtitle: Text(sendingAmount,
                style: const TextStyle(color: Colors.white)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            title: const Text('Recipient Address (scroll horizontally)',
                style: TextStyle(color: Colors.grey)),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [Text(recipientAddress,
                  style: const TextStyle(color: Colors.white)), const SizedBox(width: 20)]),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            title: const Text('Estimated Fee',
                style: TextStyle(color: Colors.grey)),
            subtitle: Text('$estimatedFee $selectedAsset',
                style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ZButton(text: "CONFIRM", onPressed: _confirmSend)),
          const SizedBox(height: 10),
          ZButton(
            text: 'CANCEL',
            width: 200,
            onPressed: () => setState(() => isConfirming = false),
            isCancel: true,
          ),
        ],
      );
  }
}
