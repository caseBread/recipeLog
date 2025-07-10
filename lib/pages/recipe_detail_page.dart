import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_log/constants.dart';
import 'package:recipe_log/utils/youtubeIframe.utils.dart';
import 'package:recipe_log/widgets/common_bottom_nav.dart';

class RecipeDetailPage extends StatefulWidget {
  final String id;

  const RecipeDetailPage({super.key, required this.id});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Map<String, dynamic>? recipe;
  bool isLoading = true;
  bool hasError = false;

  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController();
    _fetchRecipeDetail();
  }

  Future<void> _fetchRecipeDetail() async {
    try {
      final url = Uri.parse('$BASE_URL/recipes/${widget.id}');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          recipe = data;
          noteController.text = data['note'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _saveNote() async {
    final newNote = noteController.text;

    try {
      final url = Uri.parse('$BASE_URL/recipes/${widget.id}');
      final res = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'note': newNote}),
      );

      if (res.statusCode == 200) {
        setState(() {
          recipe!['note'] = newNote;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('노트가 저장되었습니다.')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('노트 저장에 실패했습니다.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('네트워크 오류가 발생했습니다.')));
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError || recipe == null) {
      return const Scaffold(body: Center(child: Text('레시피를 불러오지 못했습니다.')));
    }

    final title = recipe!['title'] ?? '';
    final description = recipe!['description'] ?? '';
    final youtuber = recipe!['youtuber'] ?? '';
    final views = recipe!['view_count']?.toString() ?? '';
    final published = recipe!['published_at'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 레시피 추가하기 버튼 클릭 시 처리
            },
            child: const Text('레시피 추가하기', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 315,
              child: buildYoutubeIframe(recipe!['id']),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'By $youtuber',
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(width: 8),
                Text(
                  '· $views views',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  '· $published',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            const Text(
              '나의 레시피 노트',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: noteController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: '나만의 레시피를 작성해보세요!',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveNote,
                    child: const Text('저장하기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomNav(currentIndex: null),
    );
  }
}
