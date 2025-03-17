import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/ui/absence_records_widget.dart';
import 'package:absence_manager/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const AbsenceManagerApp());
}

class AbsenceManagerApp extends StatelessWidget {
  const AbsenceManagerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Absence Manager',
        theme: ThemeData(colorScheme: MaterialTheme.lightScheme()),
        home: BlocProvider(
            create: (_) => AbsenceRecordsBloc()..add(FetchAllRecordsEvent()),
            child: Navigator(onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                  builder: (context) => const AbsenceRecordsWidget(),
                  maintainState: false);
            })));
  }
}
