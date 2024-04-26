import 'package:assignment_one/database/localStorage.dart';
import 'package:assignment_one/database/model.dart';
import 'package:assignment_one/state/events.dart';
import 'package:assignment_one/state/state.dart';
import 'package:assignment_one/state/userbloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseServices services = DatabaseServices();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MeetingBloc>(
            create: (context) =>
                MeetingBloc(services)..add(LoadMeetingsEvent())),
      ],
      child: MaterialApp(
        title: 'Meetings',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Meeting Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController title = TextEditingController();
  TextEditingController subtile = TextEditingController();
  TextEditingController datetime = TextEditingController();
  final form = GlobalKey<FormState>();
  // DateTime? _selectedDate;
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        final formdate = DateFormat.yMMMEd().format(pickedDate);
        datetime.text = formdate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<MeetingBloc, MeetingState>(
        builder: (context, state) {
          if (state is MeetingLoadedState) {
            return ListView.builder(
                itemCount: state.meetings.length,
                itemBuilder: (context, i) {
                  final User meeting = state.meetings[i];
                  final String dateformat =
                      DateFormat.yMMMEd().format(state.meetings[i].datetime!);
                  final DateTime now = DateTime.now();
                  Color? cardColor;
                  if (meeting.datetime != null) {
                    print('Meeting datetime: ${meeting.datetime}');
                    print('Current time: $now');
                    if (meeting.datetime!.day < now.day) {
                      // Past meeting
                      cardColor = Colors.red; // Example color for past meetings
                    }
                    if (meeting.datetime!.day == now.day) {
                      // Today's meeting
                      cardColor =
                          Colors.green; // Example color for today's meetings
                    }
                    if (meeting.datetime!.day > now.day) {
                      // Upcoming meeting
                      cardColor =
                          Colors.yellow; // Example color for upcoming meetings
                    }
                  } else {
                    // Handle case where datetime is null
                    cardColor = Colors
                        .grey; // Example color for meetings with missing datetime
                  }
                  // final bool isPastMeeting = meeting.dateTime.isBefore(now);
                  return Card(
                    color: cardColor,
                    child: ListTile(
                        title: Text(
                          meeting.title!,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 25),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meeting.subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 20),
                            ),
                            Text(
                              dateformat,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 18),
                            )
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              BlocProvider.of<MeetingBloc>(context).add(
                                  DeleteMeetingEvent(
                                      meetingId: meeting.userId));
                            },
                            icon: const Icon(Icons.delete))),
                  );
                });
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('No meeting'), CircularProgressIndicator()],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Form(
                  key: form,
                  child: SizedBox(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: TextFormField(
                              controller: title,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.grey,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 20),
                                  hintText: 'title',
                                  contentPadding: const EdgeInsets.all(15)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your title';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: TextFormField(
                              controller: subtile,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.grey,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 20),
                                  hintText: 'subtitle',
                                  contentPadding: const EdgeInsets.all(15)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your subtile';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: TextFormField(
                              readOnly: true,
                              controller: datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.grey,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 20),
                                  hintText: '03/12/2024',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _pickDate();
                                    },
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                  contentPadding: const EdgeInsets.all(15)),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 400,
                            child: ElevatedButton(
                              onPressed: () {
                                try {
                                  DateFormat format = DateFormat.yMMMEd();
                                  final time = format.parse(datetime.text);
                                  if (form.currentState!.validate()) {
                                    BlocProvider.of<MeetingBloc>(context).add(
                                      CreateNewMeetingEvent(
                                        meetingTitle: title.text,
                                        subtitle: subtile.text,
                                        time: time,
                                      ),
                                    );
                                    title.clear();
                                    subtile.clear();
                                    datetime.clear();
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                              child: Text(
                                'Save',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 25),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
