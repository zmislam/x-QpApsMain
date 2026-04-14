import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Location search & attach widget for publish screen.
class LocationTagPicker extends StatelessWidget {
  final Rx<String?> locationName;
  final void Function(String id, String name) onSelected;
  final VoidCallback onClear;

  const LocationTagPicker({
    super.key,
    required this.locationName,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (locationName.value != null) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.location_on, color: Colors.redAccent),
          title: Text(locationName.value!),
          trailing: IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 18),
          ),
        );
      }
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.location_on_outlined),
        title: const Text('Add Location'),
        onTap: () => _showLocationSearch(context),
      );
    });
  }

  void _showLocationSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _LocationSearchSheet(onSelected: onSelected),
    );
  }
}

class _LocationSearchSheet extends StatefulWidget {
  final void Function(String id, String name) onSelected;

  const _LocationSearchSheet({required this.onSelected});

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _loading = false;

  // Placeholder locations — real impl calls Places API
  final _sampleLocations = [
    {'id': 'loc_1', 'name': 'New York, NY'},
    {'id': 'loc_2', 'name': 'Los Angeles, CA'},
    {'id': 'loc_3', 'name': 'London, UK'},
    {'id': 'loc_4', 'name': 'Tokyo, Japan'},
    {'id': 'loc_5', 'name': 'Paris, France'},
    {'id': 'loc_6', 'name': 'Sydney, Australia'},
    {'id': 'loc_7', 'name': 'Mumbai, India'},
    {'id': 'loc_8', 'name': 'Dubai, UAE'},
  ];

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    // Simulate search delay + filter
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _results = _sampleLocations
            .where((l) =>
                l['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                  hintText: 'Search locations...',
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
                  final loc = _results[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(loc['name']!),
                    onTap: () {
                      widget.onSelected(loc['id']!, loc['name']!);
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
