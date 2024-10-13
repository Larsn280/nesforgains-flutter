// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStageCollection on Isar {
  IsarCollection<Stage> get stages => this.collection();
}

const StageSchema = CollectionSchema(
  name: r'Stage',
  id: -7840862827543848208,
  properties: {
    r'duration': PropertySchema(
      id: 0,
      name: r'duration',
      type: IsarType.long,
    ),
    r'instruction': PropertySchema(
      id: 1,
      name: r'instruction',
      type: IsarType.string,
    ),
    r'stageNumber': PropertySchema(
      id: 2,
      name: r'stageNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _stageEstimateSize,
  serialize: _stageSerialize,
  deserialize: _stageDeserialize,
  deserializeProp: _stageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _stageGetId,
  getLinks: _stageGetLinks,
  attach: _stageAttach,
  version: '3.1.0+1',
);

int _stageEstimateSize(
  Stage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.instruction.length * 3;
  return bytesCount;
}

void _stageSerialize(
  Stage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.duration);
  writer.writeString(offsets[1], object.instruction);
  writer.writeLong(offsets[2], object.stageNumber);
}

Stage _stageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Stage();
  object.duration = reader.readLongOrNull(offsets[0]);
  object.id = id;
  object.instruction = reader.readString(offsets[1]);
  object.stageNumber = reader.readLong(offsets[2]);
  return object;
}

P _stageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stageGetId(Stage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stageGetLinks(Stage object) {
  return [];
}

void _stageAttach(IsarCollection<dynamic> col, Id id, Stage object) {
  object.id = id;
}

extension StageQueryWhereSort on QueryBuilder<Stage, Stage, QWhere> {
  QueryBuilder<Stage, Stage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StageQueryWhere on QueryBuilder<Stage, Stage, QWhereClause> {
  QueryBuilder<Stage, Stage, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Stage, Stage, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Stage, Stage, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Stage, Stage, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StageQueryFilter on QueryBuilder<Stage, Stage, QFilterCondition> {
  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> durationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'instruction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'instruction',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instruction',
        value: '',
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> instructionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'instruction',
        value: '',
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> stageNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> stageNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> stageNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Stage, Stage, QAfterFilterCondition> stageNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stageNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StageQueryObject on QueryBuilder<Stage, Stage, QFilterCondition> {}

extension StageQueryLinks on QueryBuilder<Stage, Stage, QFilterCondition> {}

extension StageQuerySortBy on QueryBuilder<Stage, Stage, QSortBy> {
  QueryBuilder<Stage, Stage, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> sortByInstruction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> sortByInstructionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.desc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> sortByStageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageNumber', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> sortByStageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageNumber', Sort.desc);
    });
  }
}

extension StageQuerySortThenBy on QueryBuilder<Stage, Stage, QSortThenBy> {
  QueryBuilder<Stage, Stage, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByInstruction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByInstructionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.desc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByStageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageNumber', Sort.asc);
    });
  }

  QueryBuilder<Stage, Stage, QAfterSortBy> thenByStageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageNumber', Sort.desc);
    });
  }
}

extension StageQueryWhereDistinct on QueryBuilder<Stage, Stage, QDistinct> {
  QueryBuilder<Stage, Stage, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<Stage, Stage, QDistinct> distinctByInstruction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'instruction', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Stage, Stage, QDistinct> distinctByStageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageNumber');
    });
  }
}

extension StageQueryProperty on QueryBuilder<Stage, Stage, QQueryProperty> {
  QueryBuilder<Stage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Stage, int?, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<Stage, String, QQueryOperations> instructionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instruction');
    });
  }

  QueryBuilder<Stage, int, QQueryOperations> stageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageNumber');
    });
  }
}
