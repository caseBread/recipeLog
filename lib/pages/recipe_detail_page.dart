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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError || recipe == null) {
      return const Scaffold(body: Center(child: Text('레시피를 불러오지 못했습니다.')));
    }

    final thumbnailUrl = recipe!['thumbnailUrl'] ?? '';
    final title = recipe!['title'] ?? '';
    final description = recipe!['description'] ?? '';
    final youtuber = recipe!['youtuber'] ?? '';
    final views = recipe!['view_count']?.toString() ?? '';
    final published = recipe!['published_at'] ?? '';
    final note = recipe!['note'] ?? '작성된 노트가 없습니다.';

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
            // 제목
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 작성자 및 조회수, 업로드 정보
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
            // 설명
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            // 나의 레시피 노트 제목
            const Text(
              '나의 레시피 노트',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 노트 내용
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(note, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomNav(currentIndex: null),
    );
  }
}
