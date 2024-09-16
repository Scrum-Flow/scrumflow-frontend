import 'dart:async';
import 'dart:convert';

import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/utils/dio_helper.dart';

class FeatureService {
  static FutureOr<Feature> newFeature(Feature feature) async {
    var dio = await DioHelper.defaultDio();

    var response =
        await dio.post('/feature', data: json.encode(feature.toJson()));

    return Feature.fromJsonObject(response.data);
  }

  static FutureOr<List<Feature>> getAllFeature() async {
    var dio = await DioHelper.defaultDio();

    var response = await dio.get('/feature');

    return Feature.fromJson(response.data);
  }

  static FutureOr<Feature> getFeatureById(int id) async {
    var dio = await DioHelper.defaultDio();

    var response = await dio.get('/feature/$id');

    return Feature.fromJsonObject(response.data);
  }

  static FutureOr<void> updateFeatureById(int id) async {
    var dio = await DioHelper.defaultDio();

    var response = await dio.put('/feature/$id');

    ///TODO Ajustar isso. :> Não sei o que retorna
  }

  static FutureOr<void> deleteFeatureById(int id) async {
    var dio = await DioHelper.defaultDio();

    var response = await dio.delete('/feature/$id');

    ///TODO Ajustar isso. :> Não sei o que retorna
  }
}
