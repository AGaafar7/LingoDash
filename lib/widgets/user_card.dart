import 'package:flutter/material.dart';
import 'package:lingodash/providers/user_usage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserCard extends StatelessWidget {
  final User user;
  final UserUsage? usage;

  const UserCard({super.key, required this.user, this.usage});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      user.image != null ? NetworkImage(user.image!) : null,
                  child:
                      user.image == null
                          ? Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${user.id}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  user.online ? Icons.circle : Icons.circle_outlined,
                  color: user.online ? Colors.green : Colors.grey,
                  size: 12,
                ),
              ],
            ),
            if (user.extraData.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Additional Information:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...user.extraData.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
            if (usage != null) ...[
              const SizedBox(height: 16),
              Text('Usage:', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text('Total Units: ${usage!.totalUnits}'),
              Text('Used Units: ${usage!.usedUnits}'),
              Text('Translation Used: ${usage!.translationUsed}'),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Logic to end subscription
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subscription ended for ${user.name}'),
                  ),
                );
              },
              child: const Text('End Subscription'),
            ),
          ],
        ),
      ),
    );
  }
}
