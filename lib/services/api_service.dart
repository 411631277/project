import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdvancedSearchPageState createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  late Future<List<dynamic>> _searchResults;

  // 從後端 API 獲取資料
Future<List<dynamic>> fetchData() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:3000/advanced_search'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('無法加載資料，錯誤碼：${response.statusCode}');
    }
  } catch (e) {
    throw Exception('發生錯誤: $e');
  }
}

  @override
  void initState() {
    super.initState();
    _searchResults = fetchData(); // 在頁面初始化時加載資料
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Search')),
      body: FutureBuilder<List<dynamic>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤：${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('沒有資料'));
          } else {
            final results = snapshot.data!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final search = results[index];
                return ListTile(
                  title: Text(search['search_name']),
                  subtitle: Text('出生日期: ${search['search_birthdate']}'),
                );
              },
            );
          }
        },
     
      ),
      
    );
  }
}
