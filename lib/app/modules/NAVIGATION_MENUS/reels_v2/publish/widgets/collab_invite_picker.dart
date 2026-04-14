import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Collab invite picker — search and invite a co-author for the reel.
class CollabInvitePicker extends StatelessWidget {
  final Rx<String?> collabUserName;
  final void Function(String userId, String name) onInvite;
  final VoidCallback onRemove;

  const CollabInvitePicker({
    super.key,
    required this.collabUserName,
    required this.onInvite,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (collabUserName.value != null) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.group_outlined, color: Colors.purple),
          title: Text('Collab with ${collabUserName.value}'),
          subtitle: const Text('Pending invite'),
          trailing: IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
          ),
        );
      }
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.group_add_outlined),
        title: const Text('Invite Collaborator'),
        subtitle: const Text('Co-create with another user'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showSearch(context),
      );
    });
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _CollabSearchSheet(onInvite: onInvite),
    );
  }
}

class _CollabSearchSheet extends StatefulWidget {
  final void Function(String userId, String name) onInvite;

  const _CollabSearchSheet({required this.onInvite});

  @override
  State<_CollabSearchSheet> createState() => _CollabSearchSheetState();
}

class _CollabSearchSheetState extends State<_CollabSearchSheet> {
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Invite Collaborator',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
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
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user['name']!),
                    trailing: OutlinedButton(
                      onPressed: () {
                        widget.onInvite(user['userId']!, user['name']!);
                        Navigator.pop(context);
                      },
                      child: const Text('Invite'),
                    ),
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
