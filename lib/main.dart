import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final postsProvider = FutureProvider<List<dynamic>>((ref) async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load posts');
  }
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('API Call Example'),
      ),
      body: postsAsyncValue.when(
        data: (posts) {
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index]['title']),
                subtitle: Text(posts[index]['body']),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
