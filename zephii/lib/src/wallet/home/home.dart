import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';
import './assets/assets.dart';
import './transactions/transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ZephiiColors.zephPurp,
        centerTitle: true,
        title: const Text('Zephyr Protocol'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _topText(),
            _buttonView(context),
            const Divider(color: Colors.white, thickness: 1),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text("swipe to change view",
                    style: TextStyle(color: Colors.grey))),
            _bottomView(context),
          ],
        ),
      ),
    );
  }

  Widget _topText() {
    return const Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(children: [
            Text(
              "The private untraceable stablecoin",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(height: 10),
            Text("\$0.00",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ]),
        ),
        SizedBox(height: 15),
        AssetsScreen(),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buttonView(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ZButton(text: "SEND", onPressed: () {}),
          const Spacer(),
          ZButton(text: "RECEIVE", onPressed: () {
            context.go("/home/receive");
          })
        ]));
  }

  Widget _bottomView(BuildContext context) {
    return SizedBox(
      height: 420,
      child: PageView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _viewOne(context),
          const TransactionsScreen()
        ],
      ),
    );
  }

  Widget _viewOne(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          _section(
            title: 'Zephyr Price',
            spot: '\$21.20',
            movingAverage: '\$21.20',
          ),
          _section(
              title: 'Zephyr Stable Dollars',
              spot: '0.04323',
              movingAverage: '0.04322',
              unit: "ZEPH"),
          _section(
              title: 'Zephyr Reserve Shares',
              spot: '1.34322',
              movingAverage: '1.34322',
              unit: "ZEPH"),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String spot,
    required String movingAverage,
    String? unit,
  }) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _titleWithOptionalUnit(title, unit),
            const SizedBox(height: 10),
            _valuesWithLabels(spot, movingAverage),
          ],
        ),
      ),
    );
  }

  Widget _titleWithOptionalUnit(String title, String? unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (unit != null)
          Text(
            unit,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _valuesWithLabels(String spot, String movingAverage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text(
              "Spot",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              spot,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "MA",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              movingAverage,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
