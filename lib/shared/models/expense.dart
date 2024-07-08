import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.name,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
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
      'id': id,
      'name': name,
      'amount': amount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
