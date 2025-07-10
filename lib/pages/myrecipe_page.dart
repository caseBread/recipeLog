import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_log/constants.dart';
import 'package:recipe_log/utils/http_client.dart';
import 'package:recipe_log/widgets/common_bottom_nav.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  List<dynamic> myRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyRecipes();
  }

  Future<void> _fetchMyRecipes() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$BASE_URL/myRecipes');

    try {
      final res = await httpClient.get(url);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));

        setState(() {
          myRecipes = data;
          isLoading = false;
        });
      } else {
        setState(() {
          myRecipes = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        myRecipes = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 레시피'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : myRecipes.isEmpty
          ? const Center(child: Text('저장한 레시피가 없습니다.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: myRecipes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = myRecipes[index];
                return ListTile(
                  leading: Image.network(
                    item['thumbnailUrl'] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'By ${item['youtuber'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    final id = item['id'];
                    if (id != null) {
                      Navigator.pushNamed(context, '/recipes/$id');
                    }
                  },
                );
              },
            ),
      bottomNavigationBar: const CommonBottomNav(currentIndex: 2),
    );
  }
}
