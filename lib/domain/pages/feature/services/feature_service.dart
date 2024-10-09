import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class FeatureService {
  static String get path => "/feature";

  static FutureOr<Feature> fetchFeature(int? featureId) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path/$featureId');

    return Feature.fromJson(response.data);
  }

  static FutureOr<List<Feature>> fetchFeatures(int projectId) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path?projectId=$projectId');

    return response.data.map<Feature>((map) => Feature.fromJson(map)).toList();
  }

  static FutureOr<void> updateFeature(Feature feature) async {
    var dio = await Connection.defaultDio();

    await dio.put('$path/${feature.id}', data: json.encode(feature.toJson()));
  }

  static FutureOr<Feature> newFeature(Feature feature) async {
    var dio = await Connection.defaultDio();

    var response = await dio.post(path, data: json.encode(feature.toJson()));

    return Feature.fromJson(response.data);
  }

  static FutureOr<void> deleteFeature(int? featureId) async {
    Dio dio = await Connection.defaultDio();

    await dio.delete('$path/$featureId');
  }
}
