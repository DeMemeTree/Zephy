import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _restoreHeightController =
      TextEditingController();
  final TextEditingController _customURLController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addNodeController = TextEditingController();

  List<String> _fetchedNodes = [];
  List<String> _addedNodes = [];
  String _selectedNode = '';
  String _appVersion = '';
  late TabController _tabController;

  bool _showNodesList = false; // Flag to control the visibility of the nodes list

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppVersion();
  }

  void _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  void _onNodeTap(String node) {
    setState(() {
      _selectedNode = node;
    });
  }

  void _fetchNodes() async {
    // Your actual fetch logic should go here
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      _fetchedNodes = [
        'Node 1',
        'Node 2',
        'Node 3'
      ]; // Update this list based on actual data fetched
      _showNodesList = true;
    });
  }

  void _addNode() {
    if (_addNodeController.text.isNotEmpty) {
      setState(() {
        _addedNodes.insert(0, _addNodeController.text);
        _addNodeController.clear();
      });
    }
  }

  void _deleteNode(String node) {
    setState(() {
      _addedNodes.remove(node);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ZephiiColors.zephPurp,
        title: const Text('Settings'),
        bottom: buildTabBar(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAppSettingsSection(),
          buildNodeSettingsSection(),
        ],
      ),
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      dividerColor: ZephiiColors.zephPurp,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      controller: _tabController,
      tabs: const [
        Tab(text: 'App Settings'),
        Tab(text: 'Node Settings'),
      ]
    );
  }

  Widget buildAppSettingsSection() => ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          buildAppVersionDisplay(),
          buildTextField(
              _restoreHeightController, 'Restore Height', TextInputType.number),
          const SizedBox(height: 20),
          ZButton(text: "RESCAN BLOCKCHAIN", onPressed: () {}),
          const SizedBox(height: 20),
          ZButton(text: "SHOW SEED PHRASE", onPressed: () {})
        ],
      );

  Widget buildAppVersionDisplay() => Text('App Version: $_appVersion',
      textAlign: TextAlign.center, style: const TextStyle(color: Colors.white));

  Widget buildTextField(TextEditingController controller, String labelText,
          TextInputType keyboardType) =>
      TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.grey)),
        keyboardType: keyboardType,
      );

  Widget buildNodeSettingsSection() => ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          buildTextField(
              _customURLController, 'Custom URL*', TextInputType.url),
          const SizedBox(height: 8),
          buildTextField(_portController, 'Port*', TextInputType.number),
          const SizedBox(height: 8),
          buildTextField(
              _usernameController, 'Username (Optional)', TextInputType.text),
          const SizedBox(height: 8),
          buildTextField(
              _passwordController, 'Password (Optional)', TextInputType.text),
          ZButton(text: "CONNECT", onPressed: () {}),
          const SizedBox(height: 40),
          const SizedBox(height: 20),
          buildTextField(_addNodeController, 'Add Node', TextInputType.text),
          const SizedBox(height: 8),
          ZButton(text: "ADD NODE", onPressed: _addNode),
          const SizedBox(height: 20),
          const Text("Added Nodes",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          ..._buildAddedNodeList(),

          ZButton(text: "FETCH NODE LIST", onPressed: _fetchNodes),
          const SizedBox(height: 20),
          if (_fetchedNodes.isNotEmpty) ...[
            const Text("Available Nodes",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            ..._fetchedNodes.map((node) => ListTile(
                  title:
                      Text(node, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    if (!_addedNodes.contains(node)) {
                      setState(() {
                        _addedNodes.add(node);
                      });
                    }
                  },
                )),
            const SizedBox(height: 20),
          ]
        ],
      );

  List<Widget> _buildAddedNodeList() {
    return _addedNodes
        .map((node) => ListTile(
              title: Text(node, style: const TextStyle(color: Colors.white)),
              trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteNode(node)),
              onTap: () => _onNodeTap(node),
              selected: _selectedNode == node,
              selectedTileColor: Colors.grey[800],
            ))
        .toList();
  }
}
