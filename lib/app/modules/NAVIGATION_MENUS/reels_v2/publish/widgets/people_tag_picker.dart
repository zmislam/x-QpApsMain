import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Tag people in reel — search users and add tags.
class PeopleTagPicker extends StatelessWidget {
  final RxList<Map<String, String>> taggedPeople;
  final void Function(String userId, String name) onAdd;
  final void Function(String userId) onRemove;

  const PeopleTagPicker({
    super.key,
    required this.taggedPeople,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tagged people chips
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...taggedPeople.map((person) => Chip(
                      avatar: const CircleAvatar(
                        radius: 12,
                        child: Icon(Icons.person, size: 14),
                      ),
                      label: Text(person['name'] ?? ''),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => onRemove(person['userId']!),
                    )),
                ActionChip(
                  avatar: const Icon(Icons.person_add_outlined, size: 16),
                  label: const Text('Tag'),
                  onPressed: () => _showPeopleSearch(context),
                ),
              ],
            )),
      ],
    );
  }

  void _showPeopleSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PeopleSearchSheet(
        onAdd: onAdd,
        alreadyTagged: taggedPeople.map((p) => p['userId']!).toSet(),
      ),
    );
  }
}

class _PeopleSearchSheet extends StatefulWidget {
  final void Function(String userId, String name) onAdd;
  final Set<String> alreadyTagged;

  const _PeopleSearchSheet({
    required this.onAdd,
    required this.alreadyTagged,
  });

  @override
  State<_PeopleSearchSheet> createState() => _PeopleSearchSheetState();
}

class _PeopleSearchSheetState extends State<_PeopleSearchSheet> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _loading = false;

  void _search(String query) {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    // Simulate user search — real impl calls user search API
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _results = List.generate(
          5,
          (i) => {
            'userId': 'user_${query}_$i',
            'name': '$query User $i',
            'avatar': '',
          },
        );
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search people...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final user = _results[index];
                  final already =
                      widget.alreadyTagged.contains(user['userId']);
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user['name']!),
                    trailing: already
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.add),
                    onTap: already
                        ? null
                        : () {
                            widget.onAdd(user['userId']!, user['name']!);
                            Navigator.pop(context);
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
