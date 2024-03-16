import 'package:flutter/material.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _selectorButton('ZEPH', 0),
              _selectorButton('ZSD', 1),
              _selectorButton('ZRS', 2),
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
    return ZButton(
      text: title,
      onPressed: () {
       setState(() {
          _selectedIndex = index;
        });
      }
    );
  }
}
