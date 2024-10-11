// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrainingDataCollection on Isar {
  IsarCollection<TrainingData> get trainingDatas => this.collection();
}

const TrainingDataSchema = CollectionSchema(
  name: r'TrainingData',
  id: 8690265157145620633,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'kg': PropertySchema(
      id: 1,
      name: r'kg',
      type: IsarType.double,
    ),
    r'rep': PropertySchema(
      id: 2,
      name: r'rep',
      type: IsarType.long,
    ),
    r'set': PropertySchema(
      id: 3,
      name: r'set',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 4,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _trainingDataEstimateSize,
  serialize: _trainingDataSerialize,
  deserialize: _trainingDataDeserialize,
  deserializeProp: _trainingDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _trainingDataGetId,
  getLinks: _trainingDataGetLinks,
  attach: _trainingDataAttach,
  version: '3.1.0+1',
);

int _trainingDataEstimateSize(
  TrainingData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trainingDataSerialize(
  TrainingData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeDouble(offsets[1], object.kg);
  writer.writeLong(offsets[2], object.rep);
  writer.writeLong(offsets[3], object.set);
  writer.writeLong(offsets[4], object.userId);
}

TrainingData _trainingDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrainingData();
  object.date = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.kg = reader.readDoubleOrNull(offsets[1]);
  object.rep = reader.readLongOrNull(offsets[2]);
  object.set = reader.readLongOrNull(offsets[3]);
  object.userId = reader.readLongOrNull(offsets[4]);
  return object;
}

P _trainingDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trainingDataGetId(TrainingData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trainingDataGetLinks(TrainingData object) {
  return [];
}

void _trainingDataAttach(
    IsarCollection<dynamic> col, Id id, TrainingData object) {
  object.id = id;
}

extension TrainingDataQueryWhereSort
    on QueryBuilder<TrainingData, TrainingData, QWhere> {
  QueryBuilder<TrainingData, TrainingData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrainingDataQueryWhere
    on QueryBuilder<TrainingData, TrainingData, QWhereClause> {
  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idBetween(
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

extension TrainingDataQueryFilter
    on QueryBuilder<TrainingData, TrainingData, QFilterCondition> {
  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> kgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      kgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> kgEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> kgGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> kgLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> kgBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> repIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      repIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> repEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rep',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      repGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rep',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> repLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rep',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> repBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> setIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      setIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> setEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'set',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      setGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'set',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> setLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'set',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> setBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'set',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> userIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      userIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      userIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> userIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TrainingDataQueryObject
    on QueryBuilder<TrainingData, TrainingData, QFilterCondition> {}

extension TrainingDataQueryLinks
    on QueryBuilder<TrainingData, TrainingData, QFilterCondition> {}

extension TrainingDataQuerySortBy
    on QueryBuilder<TrainingData, TrainingData, QSortBy> {
  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TrainingDataQuerySortThenBy
    on QueryBuilder<TrainingData, TrainingData, QSortThenBy> {
  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TrainingDataQueryWhereDistinct
    on QueryBuilder<TrainingData, TrainingData, QDistinct> {
  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kg');
    });
  }

  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rep');
    });
  }

  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'set');
    });
  }

  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension TrainingDataQueryProperty
    on QueryBuilder<TrainingData, TrainingData, QQueryProperty> {
  QueryBuilder<TrainingData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrainingData, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TrainingData, double?, QQueryOperations> kgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kg');
    });
  }

  QueryBuilder<TrainingData, int?, QQueryOperations> repProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rep');
    });
  }

  QueryBuilder<TrainingData, int?, QQueryOperations> setProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'set');
    });
  }

  QueryBuilder<TrainingData, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
