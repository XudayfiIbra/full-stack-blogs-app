import 'dart:convert';

import 'package:blog/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<BlogLayout> blogs = [];

  Future getBlogs() async {
    var response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/blogs/'));
    var data = jsonDecode(response.body);

    for (var eachBlog in data) {
      final blog = BlogLayout(
          title: eachBlog['title'],
          author: eachBlog['author'],
          description: eachBlog['description'],
          body: eachBlog['body'],
          is_published: eachBlog['is_published']);

      blogs.add(blog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    blogs[index].title,
                  ),
                  subtitle: Text(blogs[index].description),
                  trailing: Text(blogs[index].is_published.toString()), 
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
