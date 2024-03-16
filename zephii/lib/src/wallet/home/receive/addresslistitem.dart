import 'package:flutter/material.dart';
import 'address.dart';

class AddressListItem extends StatefulWidget {
  final Address address;
  final VoidCallback onCopy;
  final VoidCallback onShowQR;
  final Function(String) onEditLabel;

  const AddressListItem({
    required this.address,
    required this.onCopy,
    required this.onShowQR,
    required this.onEditLabel,
    super.key,
  });

  @override
  State<AddressListItem> createState() => _AddressListItemState();
}

class _AddressListItemState extends State<AddressListItem> {
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address.label);
  }

  void _editLabel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Label'),
        content: TextField(
          controller: _labelController,
          decoration: const InputDecoration(hintText: 'Enter new label'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onEditLabel(_labelController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(widget.address.address,
            style: const TextStyle(color: Colors.white)),
      ),
      subtitle: Text(widget.address.label,
          style: const TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.edit),
            onPressed: () => _editLabel(context),
            tooltip: 'Edit Label',
          ),
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.qr_code),
            onPressed: widget.onShowQR,
            tooltip: 'Show QR Code',
          ),
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.copy),
            onPressed: widget.onCopy,
            tooltip: 'Copy Address',
          ),
        ],
      ),
    );
  }
}
