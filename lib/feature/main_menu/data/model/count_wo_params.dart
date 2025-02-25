import 'dart:convert';

ParamsCountWo paramsCountWoFromJson(String str) =>
    ParamsCountWo.fromJson(json.decode(str));

String paramsCountWoToJson(ParamsCountWo data) => json.encode(data.toJson());

class ParamsCountWo {
  ParamsCountWo({
    required this.token,
    required this.detailInputs,
  });

  final String token;
  final List<DetailInput> detailInputs;

  factory ParamsCountWo.fromJson(Map<String, dynamic> json) => ParamsCountWo(
        token: json["token"],
        detailInputs: (json["detailInputs"] as List)
            .map((x) => DetailInput.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "detailInputs": detailInputs.map((x) => x.toJson()).toList(),
      };
}

class DetailInput {
  DetailInput({
    required this.name,
    required this.repeatingInputs,
  });

  final String name;
  final List<RepeatingInput> repeatingInputs;

  factory DetailInput.fromJson(Map<String, dynamic> json) => DetailInput(
        name: json["name"],
        repeatingInputs: (json["repeatingInputs"] as List)
            .map((x) => RepeatingInput.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "repeatingInputs": repeatingInputs.map((x) => x.toJson()).toList(),
      };
}

class RepeatingInput {
  RepeatingInput({
    required this.inputs,
  });

  final List<InputCountWO> inputs;

  factory RepeatingInput.fromJson(Map<String, dynamic> json) => RepeatingInput(
        inputs: (json["inputs"] as List)
            .map((x) => InputCountWO.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "inputs": inputs.map((x) => x.toJson()).toList(),
      };
}

class InputCountWO {
  InputCountWO({
    required this.name,
    required this.value,
  });

  final Name name;
  final String value;

  factory InputCountWO.fromJson(Map<String, dynamic> json) => InputCountWO(
        name: nameValues.map[json["name"]] ??
            Name.CUSTOMER_NUMBER, // Default jika tidak ditemukan
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "value": value,
      };
}

enum Name { CUSTOMER_NUMBER, WO_TYPE }

final nameValues = EnumValues({
  "Customer Number": Name.CUSTOMER_NUMBER,
  "WO Type": Name.WO_TYPE,
});

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map) {
    reverseMap = map.map((k, v) => MapEntry(v, k));
  }

  Map<T, String> get reverse => reverseMap;
}
