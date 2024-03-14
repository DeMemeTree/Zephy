import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'assetsState.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({Key? key}) : super(key: key);

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final AssetsState viewModel = AssetsState(
    assets: [
      CryptoAsset(
          name: "Zephyr",
          icon: 'assets/zephyr-logo.png',
          unit: "ZEPH",
          lockedAmount: 0.5,
          unlockedAmount: 1.5),
      CryptoAsset(
          name: "Zephyr Stable Dollars",
          icon: 'assets/zsd-logo.png',
          unit: "ZSD",
          lockedAmount: 0.0,
          unlockedAmount: 1.5),
      CryptoAsset(
          name: "Zephyr Reserve Dollar",
          icon: 'assets/zrs-logo.png',
          unit: "ZRS",
          lockedAmount: 0.5,
          unlockedAmount: 1.5)
    ],
    node: BlockchainNode(currentBlockHeight: 123456, syncProgress: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _buildNodeStatus(viewModel.node),
            _buildAssetsList(viewModel.assets),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildNodeStatus(BlockchainNode? node) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _iconBasedOnNodeStatus(node),
                const SizedBox(width: 8),
                _titleBasedOnNodeStatus(node),
              ],
            ),
          ),
          _settingsIcon(),
        ],
      ),
    );
  }

  Widget _titleBasedOnNodeStatus(BlockchainNode? node) {
    if (node == null) {
      return const Text('Not Connected to Blockchain Node',
          style: TextStyle(color: Colors.white));
    } else if (node.syncProgress < 1.0) {
      return Text(
        'Syncing: ${(node.syncProgress * 100).toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.white),
      );
    } else {
      return Text('Block Height: ${node.currentBlockHeight}',
          style: const TextStyle(color: Colors.white));
    }
  }

  Widget _iconBasedOnNodeStatus(BlockchainNode? node) {
    if (node == null) {
      return const Icon(Icons.error, color: Colors.red);
    } else if (node.syncProgress < 1.0) {
      return Container(); // Optionally return a placeholder or progress icon
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }

  Widget _settingsIcon() {
    return IconButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        context.go("/home/settings");
      },
    );
  }

  Widget _buildAssetsList(List<CryptoAsset> assets) {
    return Column(
      children: assets.map((asset) => _buildAssetTile(asset)).toList(),
    );
  }

  Widget _buildAssetTile(CryptoAsset asset) {
    return ListTile(
      leading: SizedBox(
          height: 45,
          width: 45,
          child: Image.asset(asset.icon, fit: BoxFit.contain)),
      title: Row(children: [
        _assetList(asset),
        const Spacer(),
        Text(
          asset.unit,
          style: const TextStyle(color: Colors.grey),
        )
      ]),
    );
  }

  Widget _assetList(CryptoAsset asset) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${asset.unlockedAmount}',
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
        if (asset.lockedAmount > 0)
          Text(
            'LOCKED: ${asset.lockedAmount}',
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }
}
