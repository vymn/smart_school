import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final String name;
  final String id;
  const Grade({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];
}
