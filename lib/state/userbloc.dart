import 'package:assignment_one/database/model.dart';
import 'package:assignment_one/state/events.dart';
import 'package:assignment_one/state/state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/localStorage.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState>{
  final DatabaseServices _databaseServices;

  MeetingBloc(this._databaseServices) : super(MeetingInitial()) {
    on<LoadMeetingsEvent>((event, emit) async {
      final users = _databaseServices.loadAllMeetings();
      List<User> meetingList = await users;
      emit(MeetingLoadedState(meetingList));
      });
  
    on<CreateNewMeetingEvent>((event, emit) async {
      await _databaseServices.createNewMeeting(title: event.meetingTitle, subtitile: event.subtitle, time: event.time);
      add(LoadMeetingsEvent());
    });

    on<DeleteMeetingEvent>((event, emit) async {
      await _databaseServices.deleteMeeting(todoId: event.meetingId);
      add(LoadMeetingsEvent());
    });

    // on<CompleteTodoEvent>((event, emit) async {
    //   await _databaseServices.completeTodo(todoId: event.todoId);
    //   add(LoadTodosEvent());
    // });
  }
}