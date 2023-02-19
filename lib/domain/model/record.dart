import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vault_pass/domain/microtypes/microtypes.dart';

part 'record.freezed.dart';

@freezed
abstract class Record implements _$Record {
  const Record._();

  const factory Record({
    required UniqueId id,

    required Name recordName,
    required RecordType type,
    required Name loginRecord,
    required Password passwordRecord,
    required String logo,
    required Description description,
    required Url url,

    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _Record;

  factory Record.empty() => Record(
      id: UniqueId(),
      recordName: Name(""),
      type: RecordType.account,
      loginRecord: Name(""),
      passwordRecord: Password(""),
      logo: "",
      description: Description(""),
      url: Url(""),
      createdDate: DateTime.now(),
      updatedDate: DateTime.now());

  factory Record.random(
          {required String recordName,
          required RecordType recordType,
          required String logo,
          required String description,
          required String url}) =>
      Record(
          id: UniqueId(),
          recordName: Name(recordName),
          type: recordType,
          loginRecord: Name(""),
          passwordRecord: Password(""),
          logo: logo,
          description: Description(description),
          url: Url(url),
          createdDate: DateTime.now(),
          updatedDate: DateTime.now());
}

enum RecordType {
  account("Account"),
  address("Address"),
  business("Business account");

  final String value;

  const RecordType(this.value);

  static RecordType valueOf(String value) {
    return RecordType.values.firstWhere((val) => val.value == value);
  }
}
