import 'package:equatable/equatable.dart';

class DetailPageArgument extends Equatable {
  final String id;

  const DetailPageArgument({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}