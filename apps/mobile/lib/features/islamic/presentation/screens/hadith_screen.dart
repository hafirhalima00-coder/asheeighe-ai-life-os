import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../widgets/hadith_card.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithNotifier>().loadHadithCollection('bukhari');
      context.read<HadithNotifier>().loadDailyHadith();
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
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4AF37),
        title: const Text('Hadith', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Bukhari'),
            Tab(text: 'Muslim'),
            Tab(text: 'Abu Dawud'),
            Tab(text: 'Tirmidhi'),
            Tab(text: 'Ibn Majah'),
          ],
          onTap: (index) {
            final collections = ['bukhari', 'muslim', 'abu-dawud', 'tirmidhi', 'ibn-majah'];
            context.read<HadithNotifier>().loadHadithCollection(collections[index]);
          },
        ),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: Consumer<HadithNotifier>(
              builder: (context, hadith, child) {
                if (hadith.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: hadith.hadiths.length,
                  itemBuilder: (context, index) {
                    final hadithItem = hadith.hadiths[index];
                    return HadithCard(hadith: hadithItem);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<HadithNotifier>(
      builder: (context, hadith, child) {
        final categories = hadith.getCategories();
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat['id'] == hadith.selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text('${cat['icon']} ${cat['name']}'),
                  selected: isSelected,
                  onSelected: (_) {
                    hadith.filterByCategory(cat['id'] as String);
                  },
                  selectedColor: const Color(0xFFD4AF37).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFD4AF37),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
