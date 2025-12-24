import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/game_state.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final inventory = gameState.inventory;

    // Group items by count
    final Map<String, int> itemCounts = {};
    for (var item in inventory) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: inventory.isEmpty
          ? const Center(child: Text('Empty Pockets! Buy items in the Shop.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: itemCounts.length,
              itemBuilder: (context, index) {
                String itemId = itemCounts.keys.elementAt(index);
                int count = itemCounts[itemId]!;
                return _InventoryItemCard(
                  itemId: itemId,
                  count: count,
                  onUse: () {
                    bool result = gameState.useItem(itemId);
                    if (result) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Used $itemId!')));
                    }
                  },
                );
              },
            ),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  final String itemId;
  final int count;
  final VoidCallback onUse;

  const _InventoryItemCard({
    required this.itemId,
    required this.count,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String name;

    switch (itemId) {
      case 'potion_xp':
        icon = Icons.science;
        color = Colors.purpleAccent;
        name = 'XP Potion';
        break;
      case 'ticket_refill':
        icon = Icons.confirmation_number;
        color = Colors.blueAccent;
        name = 'Ticket Refill';
        break;
      default:
        icon = Icons.question_mark;
        color = Colors.grey;
        name = 'Unknown';
    }

    return GestureDetector(
      onTap: onUse,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(icon, size: 48, color: color),
                if (count > 1)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Tap to Use',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
