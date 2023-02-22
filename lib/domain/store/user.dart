import 'package:equatable/equatable.dart';

///
/// Created by jozuko on 2023/02/22.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class User extends Equatable {
  final String id;
  final String nickname;

  const User({
    required this.id,
    required this.nickname,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
