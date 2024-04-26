import 'package:assignment_one/database/model.dart';
import 'package:equatable/equatable.dart';

class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingLoadedState extends MeetingState {
  final List<User> meetings;

  const MeetingLoadedState(this.meetings);

  @override
  List<Object?> get props => [meetings];
}
