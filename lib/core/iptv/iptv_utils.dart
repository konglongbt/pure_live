import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pure_live/core/iptv/src/m3u_item.dart';
import 'package:pure_live/core/iptv/src/m3u_list.dart';

class IptvUtils {
  static const String directoryPath = '/assets/iptv/';
  static const String category = 'category';
  static const String recomand = 'recomand';

  static Future<List<IptvCategory>> readCategory() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      final categories = File('${dir.path}${Platform.pathSeparator}categories.json');
      String jsonData = await categories.readAsString();
      List jsonArr = jsonData.isNotEmpty ? jsonDecode(jsonData) : [];
      List<IptvCategory> categoriesArr =
          jsonArr.map((e) => IptvCategory.fromJson(e)).toList();
      return categoriesArr;
    } catch (e) {
      return [];
    }
  }

  static Future<String> loadJsonFromAssets(String assetsPath) async {
    return await rootBundle.loadString(assetsPath);
  }

  static Future<List<M3uItem>> readCategoryItems(filePath) async {
    List<M3uItem> list = [];
    try {
      final m3uList = await M3uList.loadFromFile(filePath);
      for (M3uItem item in m3uList.items) {
        list.add(item);
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  static Future<List<M3uItem>> readRecommandsItems() async {
    String path = 'assets/iptv/recomand/11.m3u';
    List<M3uItem> list = [];
    try {
      final m3uList = await M3uList.loadFromAssets(path);
      for (M3uItem item in m3uList.items) {
        list.add(item);
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  static Future<bool> recover(File file) async {
    return true;
  }
}

class IptvCategory {
  String? id;
  String? name;
  String? path;

  IptvCategory({this.id, this.name, this.path});

  factory IptvCategory.fromJson(Map<String, dynamic> json) {
    return IptvCategory(
      name: json['name'],
      id: json['id'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'path': path,
      };
}

class IptvCategoryItem {
  final String id;
  final String name;
  final String liveUrl;

  IptvCategoryItem(
      {required this.id, required this.name, required this.liveUrl});

  factory IptvCategoryItem.fromJson(Map<String, dynamic> json) {
    return IptvCategoryItem(
      name: json['name'],
      id: json['id'],
      liveUrl: json['liveUrl'],
    );
  }
}