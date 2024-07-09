import 'package:equatable/equatable.dart';

final class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.name,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json[r'$id'] as String,
      name: json['name'] as String?,
      amount: json['amount'] as num,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  final String id;
  final String? name;
  final num amount;
  final String createdAt;
  final String updatedAt;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      amount,
      createdAt,
      updatedAt,
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      r'$id': id,
      'name': name,
      'amount': amount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Expense copyWith({
    String? id,
    String? name,
    num? amount,
    String? createdAt,
    String? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
