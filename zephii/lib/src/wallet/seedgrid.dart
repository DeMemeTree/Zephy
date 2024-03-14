import 'package:flutter/material.dart';

class SeedList extends StatelessWidget {
  final String seedPhrase;
  const SeedList({required this.seedPhrase, super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SeedGrid(seedPhrase: seedPhrase),
      ),
    );
  }
}

class SeedGrid extends StatelessWidget {
  final String seedPhrase;
  const SeedGrid({required this.seedPhrase, super.key});

  Widget _buildGridItem(BuildContext context, int index, List<String> words) {
    return Card(
      child: Center(child: Text('${index + 1}. ${words[index]}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = seedPhrase.split(' ');
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable grid's own scroll
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: words.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildGridItem(context, index, words);
      },
    );
  }
}
