import 'package:equatable/equatable.dart';

class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeetingsEvent extends MeetingEvent {
  @override
  List<Object?> get props => [];
}

class CreateNewMeetingEvent extends MeetingEvent {
  final String meetingTitle;
final String subtitle;
final DateTime time;
  const CreateNewMeetingEvent({required this.meetingTitle, required this.subtitle, required this.time});

  @override
  List<Object?> get props => [meetingTitle];
}

class DeleteMeetingEvent extends MeetingEvent {
  final String meetingId;

  const DeleteMeetingEvent({required this.meetingId});

  @override
  List<Object?> get props => [meetingId];
}

class CompleteMeetingEvent extends MeetingEvent {
  final String meetingId;

  const CompleteMeetingEvent({required this.meetingId});

  @override
  List<Object?> get props => [meetingId];
}
