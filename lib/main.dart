import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
        home: BlocProvider(
          create: (_) => AbsenceRecordsBloc()..add(FetchAllRecordsEvent()),
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.primary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SafeArea(child:
            BlocBuilder<AbsenceRecordsBloc, AbsenceRecordsState>(
                builder: (context, state) {
          if (state is AbsenceRecordsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AbsenceRecordsErrorState) {
            return Center(
                child: Text(
                    "Sorry something went wrong. Please try again later."));
          } else {
            return Row(children: [
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if (scrollNotification.metrics.maxScrollExtent ==
                        scrollNotification.metrics.pixels) {
                      if (state.currentAbsenceRecordsCount <
                          state.totalAbsenceRecordsCount) {
                        context
                            .read<AbsenceRecordsBloc>()
                            .add(FetchPaginatedRecordsEvent());
                      }
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (_, index) {
                      final record = state.records[index];
                      return Row(
                        children: [
                          Expanded(
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(record.name),
                            )),
                          ),
                        ],
                      );
                    }),
              ))
            ]);
          }
        })));
  }
}
