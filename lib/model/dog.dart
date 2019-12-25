import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minhund/model/address.dart';
import 'package:minhund/presentation/widgets/custom_image.dart';
import 'journal_category_item.dart';

part 'dog.g.dart';

@JsonSerializable(anyMap: true)
class Dog {
  Dog({
    this.name,
    this.weigth,
    this.birthDate,
    this.race,
    this.address,
    this.chipNumber,
    this.id,
    this.imgUrl,
  });
  String id;
  String name;
  String weigth;
  String chipNumber;
  String imgUrl;
  Address address;
  DateTime birthDate;
  String race;
  @JsonKey(ignore: true)
  List<JournalCategoryItem> journalItems;

  @JsonKey(ignore: true)
  DocumentReference docRef;
  @JsonKey(ignore: true)
  File imageFile;

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  Map<String, dynamic> toJson() => _$DogToJson(this);
}
