class CryptoAsset {
  final String name;
  final String icon;
  final String unit;
  final double lockedAmount;
  final double unlockedAmount;

  CryptoAsset({
    required this.name,
    required this.icon,
    required this.unit,
    required this.lockedAmount,
    required this.unlockedAmount,
  });
}

class BlockchainNode {
  int currentBlockHeight;
  double syncProgress; // 0.0 to 1.0 for 0% to 100%

  BlockchainNode({
    required this.currentBlockHeight,
    required this.syncProgress,
  });
}

class AssetsState {
  List<CryptoAsset> assets = [];
  BlockchainNode? node;

  AssetsState({
    required this.assets,
    this.node,
  });
}
