import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/game_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Currency Display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '${gameState.coins} Coins',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          _ShopItem(
            title: 'XP Potion',
            description: 'Gives 500 XP when used.',
            cost: 300,
            icon: Icons.science,
            canBuy: gameState.coins >= 300,
            onBuy: () {
              if (gameState.coins >= 300) {
                gameState.addCoins(-300);
                gameState.addItem('potion_xp');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bought XP Potion!')),
                );
              }
            },
          ),

          _ShopItem(
            title: 'Ticket Refill',
            description: 'Refills tickets to max.',
            cost: 500,
            icon: Icons.confirmation_number,
            canBuy: gameState.coins >= 500,
            onBuy: () {
              if (gameState.coins >= 500) {
                gameState.addCoins(-500);
                gameState.addItem('ticket_refill');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bought Ticket Refill!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ShopItem extends StatelessWidget {
  final String title;
  final String description;
  final int cost;
  final IconData icon;
  final bool canBuy;
  final VoidCallback onBuy;

  const _ShopItem({
    required this.title,
    required this.description,
    required this.cost,
    required this.icon,
    required this.canBuy,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 48, color: Colors.white),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canBuy ? Colors.green : Colors.grey,
          ),
          onPressed: canBuy ? onBuy : null,
          child: Text('$cost Coins'),
        ),
      ),
    );
  }
}
