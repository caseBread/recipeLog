import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_log/constants.dart';
import 'package:recipe_log/utils/http_client.dart';
import 'package:recipe_log/widgets/common_bottom_nav.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? query;
  List<dynamic> searchResults = [];
  bool isLoading = false; // ✅ 추가
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = Uri.base;
    final q = uri.queryParameters['q'];
    if (q != null && q.isNotEmpty) {
      query = q;

      setState(() {
        _controller.text = q;
      });

      _fetchSearchResults(q);
    }
  }

  Future<void> _fetchSearchResults(String q) async {
    setState(() {
      isLoading = true; // ✅ 검색 시작 시 로딩 true
    });

    final url = Uri.parse('$BASE_URL/recipes?query=$q');

    try {
      final res = await httpClient.get(url);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));

        setState(() {
          searchResults = data;
          isLoading = false; // ✅ 완료 시 false
        });
      } else {
        setState(() {
          searchResults = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  void _onSearch(String text) {
    final encoded = Uri.encodeComponent(text);
    Navigator.pushReplacementNamed(context, '/search?q=$encoded');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색결과'), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: '레시피를 검색해주세요.',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child:
                isLoading // ✅ 로딩 중이면 로더 표시
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.separated(
                    itemCount: searchResults.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
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
          ),
        ],
      ),
      bottomNavigationBar: const CommonBottomNav(currentIndex: 1),
    );
  }
}
