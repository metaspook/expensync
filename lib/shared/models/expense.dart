import 'package:equatable/equatable.dart';
import 'package:expensync/shared/services/database.dart';

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
      amount: json['amount'] as double,
      createdAt: json['createdAt'] as DateTime,
      updatedAt: json['updatedAt'] as DateTime,
    );
  }

  factory Expense.fromData(ExpenseData data) {
    return Expense(
      id: data.id,
      name: data.name,
      amount: data.amount,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  final String id;
  final String? name;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
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
