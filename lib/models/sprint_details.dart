import 'package:scrumflow/models/feature_details.dart';
import 'package:scrumflow/utils/utils.dart';

class SprintDetails {
  final int? id;
  final String? name;
  final String? description;
  final List<FeatureDetails>? features;

  const SprintDetails({
    this.id,
    this.name,
    this.description,
    this.features,
  });

  factory SprintDetails.fromJson(Map<String, dynamic> json) => SprintDetails(
        id: Helper.keyExists(json, 'id'),
        name: Helper.keyExists(json, 'name'),
        description: Helper.keyExists(json, 'description'),
        features: Helper.keyExists(json, 'features')?.map<FeatureDetails>((map) => FeatureDetails.fromJson(map)).toList() ?? [],
      );
}
