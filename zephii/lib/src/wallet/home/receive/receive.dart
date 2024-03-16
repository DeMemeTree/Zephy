import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:zephii/src/extensions/color.dart';
import 'address.dart';
import 'addresslistitem.dart';
import 'qr.dart';

class ReceiveView extends StatefulWidget {
  const ReceiveView({super.key});

  @override
  _ReceiveViewState createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {
  final TextEditingController _filterController = TextEditingController();
  final List<Address> _addresses = [];
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _addresses.add(Address(id: "1", label: "My Wallet 1", address: "abc123"));
    _addresses.add(Address(id: "2", label: "My Wallet 2", address: "def456"));
  }

  void _addAddress() {
    setState(() {
      _addresses.add(Address(
        id: DateTime.now().toString(),
        label: "New Wallet ${_addresses.length + 1}",
        address: "xyz${_addresses.length + 1}789",
      ));
    });
  }

  void _filterAddresses(String enteredKeyword) {
    setState(() {
      _filter = enteredKeyword;
    });
  }

  List<Address> get _filteredAddresses => _addresses
      .where((address) =>
          address.label.toLowerCase().contains(_filter.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ZephiiColors.zephPurp,
        appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: ZephiiColors.zephPurp,
            title: const Text('Receive', style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addAddress,
                    tooltip: 'Add new address',
                  ))
            ]),
        body: _buildReceiveViewBody(context));
  }

  Widget _buildReceiveViewBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildFilterTextField(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredAddresses.length,
            itemBuilder: (context, index) {
              Address address = _filteredAddresses[index];
              return AddressListItem(
                address: address,
                onCopy: () => _copyAddressToClipboard(address.address, context),
                onShowQR: () => _showQRCode(context, address.address),
                onEditLabel: (newLabel) {
                  // TODO: Something here...
                  print(newLabel);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _copyAddressToClipboard(String address, BuildContext context) {
    FlutterClipboard.copy(address).then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
            content: Text('$address copied to clipboard!',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: ZephiiColors.zephPurp,
            duration: const Duration(seconds: 1))));
  }

  Widget _buildFilterTextField() {
    return TextField(
      controller: _filterController,
      style: const TextStyle(color: Colors.white), // Text color
      decoration: const InputDecoration(
        labelText: 'Filter by label',
        labelStyle: TextStyle(color: Colors.grey), // Label text color
        suffixIcon: Icon(Icons.search, color: Colors.white), // Icon color
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onChanged: _filterAddresses,
    );
  }

  void _showQRCode(BuildContext context, String data) {
    final Size screenSize = MediaQuery.of(context).size;
    final double dialogWidth = screenSize.width * 0.8;
    final double dialogHeight = screenSize.height * 0.8;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: QRView(data: data),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CLOSE', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          backgroundColor: ZephiiColors.zephPurp,
        );
      },
    );
  }
}
