import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dhikr_provider.dart';
import '../widgets/dhikr_counter.dart';

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({super.key});

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        title: const Text('Adhkar', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Morning'),
            Tab(text: 'Evening'),
            Tab(text: 'Sleep'),
            Tab(text: 'Waking'),
          ],
          onTap: (index) {
            final categories = ['morning', 'evening', 'sleep', 'waking'];
            context.read<DhikrNotifier>().setCategory(categories[index]);
          },
        ),
      ),
      body: Column(
        children: [
          _buildStatsBar(),
          Expanded(
            child: Consumer<DhikrNotifier>(
              builder: (context, dhikr, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dhikr.currentAdhkar.length,
                  itemBuilder: (context, index) {
                    final dhikrItem = dhikr.currentAdhkar[index];
                    return DhikrCounter(
                      dhikr: dhikrItem,
                      onTap: () => dhikr.incrementDhikr(dhikrItem.id),
                      onReset: () => dhikr.resetDhikr(dhikrItem.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDhikrDialog(context),
        backgroundColor: const Color(0xFF7B1FA2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Consumer<DhikrNotifier>(
      builder: (context, dhikr, child) {
        final stats = dhikr.getCompletionStats();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Completed', '${stats['completed']}', const Color(0xFF2E7D32)),
              _buildStatItem('Total', '${stats['total']}', const Color(0xFF1565C0)),
              _buildStatItem('Progress', '${stats['percentage']}%', const Color(0xFFD4AF37)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _showAddDhikrDialog(BuildContext context) {
    final nameController = TextEditingController();
    final arabicController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Dhikr'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: arabicController,
              decoration: const InputDecoration(labelText: 'Arabic Text'),
            ),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(labelText: 'Target Count'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && targetController.text.isNotEmpty) {
                context.read<DhikrNotifier>().addCustomDhikr(
                  nameController.text,
                  arabicController.text,
                  nameController.text,
                  nameController.text,
                  int.parse(targetController.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
