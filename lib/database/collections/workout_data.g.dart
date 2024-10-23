// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutDataCollection on Isar {
  IsarCollection<WorkoutData> get workoutDatas => this.collection();
}

const WorkoutDataSchema = CollectionSchema(
  name: r'WorkoutData',
  id: 8266263936000631167,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'exercise': PropertySchema(
      id: 1,
      name: r'exercise',
      type: IsarType.string,
    ),
    r'kg': PropertySchema(
      id: 2,
      name: r'kg',
      type: IsarType.double,
    ),
    r'rep': PropertySchema(
      id: 3,
      name: r'rep',
      type: IsarType.long,
    ),
    r'set': PropertySchema(
      id: 4,
      name: r'set',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 5,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _workoutDataEstimateSize,
  serialize: _workoutDataSerialize,
  deserialize: _workoutDataDeserialize,
  deserializeProp: _workoutDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _workoutDataGetId,
  getLinks: _workoutDataGetLinks,
  attach: _workoutDataAttach,
  version: '3.1.0+1',
);

int _workoutDataEstimateSize(
  WorkoutData object,
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
  {
    final value = object.exercise;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _workoutDataSerialize(
  WorkoutData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeString(offsets[1], object.exercise);
  writer.writeDouble(offsets[2], object.kg);
  writer.writeLong(offsets[3], object.rep);
  writer.writeLong(offsets[4], object.set);
  writer.writeLong(offsets[5], object.userId);
}

WorkoutData _workoutDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutData(
    date: reader.readStringOrNull(offsets[0]),
    exercise: reader.readStringOrNull(offsets[1]),
    kg: reader.readDoubleOrNull(offsets[2]),
    rep: reader.readLongOrNull(offsets[3]),
    set: reader.readLongOrNull(offsets[4]),
    userId: reader.readLongOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _workoutDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workoutDataGetId(WorkoutData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workoutDataGetLinks(WorkoutData object) {
  return [];
}

void _workoutDataAttach(
    IsarCollection<dynamic> col, Id id, WorkoutData object) {
  object.id = id;
}

extension WorkoutDataQueryWhereSort
    on QueryBuilder<WorkoutData, WorkoutData, QWhere> {
  QueryBuilder<WorkoutData, WorkoutData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkoutDataQueryWhere
    on QueryBuilder<WorkoutData, WorkoutData, QWhereClause> {
  QueryBuilder<WorkoutData, WorkoutData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterWhereClause> idBetween(
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

extension WorkoutDataQueryFilter
    on QueryBuilder<WorkoutData, WorkoutData, QFilterCondition> {
  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateEqualTo(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateStartsWith(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateEndsWith(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateContains(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateMatches(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exercise',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exercise',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> exerciseEqualTo(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> exerciseBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseStartsWith(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseEndsWith(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exercise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> exerciseMatches(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exercise',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      exerciseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exercise',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kg',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgEqualTo(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> kgBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rep',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rep',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> repBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'set',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'set',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setGreaterThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> setBetween(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> userIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition>
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<WorkoutData, WorkoutData, QAfterFilterCondition> userIdBetween(
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

extension WorkoutDataQueryObject
    on QueryBuilder<WorkoutData, WorkoutData, QFilterCondition> {}

extension WorkoutDataQueryLinks
    on QueryBuilder<WorkoutData, WorkoutData, QFilterCondition> {}

extension WorkoutDataQuerySortBy
    on QueryBuilder<WorkoutData, WorkoutData, QSortBy> {
  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension WorkoutDataQuerySortThenBy
    on QueryBuilder<WorkoutData, WorkoutData, QSortThenBy> {
  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exercise', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kg', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByRepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rep', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenBySetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'set', Sort.desc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension WorkoutDataQueryWhereDistinct
    on QueryBuilder<WorkoutData, WorkoutData, QDistinct> {
  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctByExercise(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exercise', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctByKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kg');
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctByRep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rep');
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctBySet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'set');
    });
  }

  QueryBuilder<WorkoutData, WorkoutData, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension WorkoutDataQueryProperty
    on QueryBuilder<WorkoutData, WorkoutData, QQueryProperty> {
  QueryBuilder<WorkoutData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkoutData, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<WorkoutData, String?, QQueryOperations> exerciseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercise');
    });
  }

  QueryBuilder<WorkoutData, double?, QQueryOperations> kgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kg');
    });
  }

  QueryBuilder<WorkoutData, int?, QQueryOperations> repProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rep');
    });
  }

  QueryBuilder<WorkoutData, int?, QQueryOperations> setProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'set');
    });
  }

  QueryBuilder<WorkoutData, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
