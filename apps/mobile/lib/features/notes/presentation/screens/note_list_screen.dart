import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';

class NoteListScreen extends ConsumerStatefulWidget {
  const NoteListScreen({super.key});

  @override
  ConsumerState<NoteListScreen> createState() =>
      _NoteListScreenState();
}

class _NoteListScreenState
    extends ConsumerState<NoteListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteProvider);
    final notifier = ref.read(noteProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(state.isGridView
                ? Icons.view_list
                : Icons.grid_view),
            onPressed: () =>
                notifier.setGridView(!state.isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primary))
                : RefreshIndicator(
                    onRefresh: () => notifier.loadNotes(),
                    child: _buildContent(state, notifier),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create note
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMd,
        AppConstants.paddingSm,
        AppConstants.paddingMd,
        AppConstants.paddingSm,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search notes...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(noteProvider.notifier)
                        .search('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 16),
        ),
        onChanged: (value) {
          ref.read(noteProvider.notifier).search(value);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildContent(
      NoteState state, NoteNotifier notifier) {
    if (state.isSearching) {
      return Center(
        child: CircularProgressIndicator(
            color: AppTheme.primary),
      );
    }

    final displayNotes = state.searchQuery.isNotEmpty
        ? state.searchResults
        : state.recentNotes;

    if (displayNotes.isEmpty && state.pinnedNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined,
                size: 64, color: AppTheme.textHint),
            const SizedBox(height: 16),
            const Text(
              'No notes yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to create your first note',
              style: TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (state.pinnedNotes.isNotEmpty &&
            state.searchQuery.isEmpty) ...[
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(
                AppConstants.paddingMd, 8, AppConstants.paddingMd, 4),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Pinned',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMd),
                itemCount: state.pinnedNotes.length,
                itemBuilder: (ctx, i) => SizedBox(
                  width: 180,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12),
                    child: NoteCard(
                      note: state.pinnedNotes[i],
                      onTap: () {},
                      onPin: () =>
                          notifier.togglePin(
                              state.pinnedNotes[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (state.searchQuery.isEmpty) ...[
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(
                AppConstants.paddingMd, 16, AppConstants.paddingMd, 4),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Recent Notes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
        state.isGridView
            ? SliverPadding(
                padding: const EdgeInsets.all(
                    AppConstants.paddingMd),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => NoteCard(
                      note: displayNotes[i],
                      onTap: () {},
                      onPin: () => notifier
                          .togglePin(displayNotes[i]),
                    ),
                    childCount: displayNotes.length,
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => NoteCard(
                    note: displayNotes[i],
                    onTap: () {},
                    onPin: () => notifier
                        .togglePin(displayNotes[i]),
                  ),
                  childCount: displayNotes.length,
                ),
              ),
      ],
    );
  }
}
