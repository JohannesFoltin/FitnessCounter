import 'package:json_annotation/json_annotation.dart';

part 'dateCode.g.dart';

@JsonSerializable()
class dateCode {
  int hours;
  int days;
  int month;
  int year;

  String getDateFormatted(){
    return days.toString()+"."+month.toString()+"."+year.toString();
  }
  dateCode(this.hours, this.days, this.month, this.year);
  factory dateCode.fromJson(Map<String, dynamic> json) => _$dateCodeFromJson(json);

  Map<String, dynamic> toJson() => _$dateCodeToJson(this);
}
