// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseCollection on Isar {
  IsarCollection<Exercise> get exercises => this.collection();
}

const ExerciseSchema = CollectionSchema(
  name: r'Exercise',
  id: 2972066467915231902,
  properties: {
    r'exercise': PropertySchema(
      id: 0,
      name: r'exercise',
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
    )
  },
  estimateSize: _exerciseEstimateSize,
  serialize: _exerciseSerialize,
  deserialize: _exerciseDeserialize,
  deserializeProp: _exerciseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _exerciseGetId,
  getLinks: _exerciseGetLinks,
  attach: _exerciseAttach,
  version: '3.1.0+1',
);

int _exerciseEstimateSize(
  Exercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.exercise;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseSerialize(
  Exercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.exercise);
  writer.writeDouble(offsets[1], object.kg);
  writer.writeLong(offsets[2], object.rep);
  writer.writeLong(offsets[3], object.set);
}

Exercise _exerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Exercise(
    exercise: reader.readStringOrNull(offsets[0]),
    kg: reader.readDoubleOrNull(offsets[1]),
    rep: reader.readLongOrNull(offsets[2]),
    set: reader.readLongOrNull(offsets[3]),
  );
  object.id = id;
  return object;
}

P _exerciseDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _exerciseGetId(Exercise object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseGetLinks(Exercise object) {
  return [];
}

void _exerciseAttach(IsarCollection<dynamic> col, Id id, Exercise object) {
  object.id = id;
}

extension ExerciseQueryWhereSort on QueryBuilder<Exercise, Exercise, QWhere> {
  QueryBuilder<Exercise, Exercise, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExerciseQueryWhere on QueryBuilder<Exercise, Exercise, QWhereClause> {
  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idBetween(
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

extension ExerciseQueryFilter
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {
  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exercise',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exercise',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exercise',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exercise',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercise',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> exerciseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exercise',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgEqualTo(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> kgBetween(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rep',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> repBetween(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'set',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> setBetween(
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
}

extension ExerciseQueryObject
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQueryLinks
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQuerySortBy on QueryBuilder<Exercise, Exercise, QSortBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }
}

extension ExerciseQuerySortThenBy
    on QueryBuilder<Exercise, Exercise, QSortThenBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }
}

extension ExerciseQueryWhereDistinct
    on QueryBuilder<Exercise, Exercise, QDistinct> {
  QueryBuilder<Exercise, Exercise, QDistinct> distinctByExercise(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exercise', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kg');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rep');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'set');
    });
  }
}

extension ExerciseQueryProperty
    on QueryBuilder<Exercise, Exercise, QQueryProperty> {
  QueryBuilder<Exercise, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Exercise, String?, QQueryOperations> exerciseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercise');
    });
  }

  QueryBuilder<Exercise, double?, QQueryOperations> kgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kg');
    });
  }

  QueryBuilder<Exercise, int?, QQueryOperations> repProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rep');
    });
  }

  QueryBuilder<Exercise, int?, QQueryOperations> setProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'set');
    });
  }
}
