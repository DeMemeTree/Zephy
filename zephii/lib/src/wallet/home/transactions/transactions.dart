import 'package:flutter/material.dart';
import 'package:zephii/src/extensions/color.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _contentViews = const [
    Center(child: Text('ZEPH', style: TextStyle(color: Colors.white))),
    Center(child: Text('ZSD', style: TextStyle(color: Colors.white))),
    Center(child: Text('ZRS', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZephiiColors.zephPurp,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _selectorButton('ZEPH', 0)),
              Expanded(child: _selectorButton('ZSD', 1)),
              Expanded(child: _selectorButton('ZRS', 2)),
            ],
          ),
          Expanded(
            child: _contentViews[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _selectorButton(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ZephiiColors.zephPurp,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20), // Remove padding
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: isSelected
              ? const BorderSide(color: Colors.white, width: 2.0)
              : BorderSide.none,
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
    );
  }
}
