import 'dart:convert';

import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/api/absence_records_service.dart';
import 'package:absence_manager/absence_records/api/member_records_service.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:absence_manager/absence_records/models/absence_records_response_model.dart';
import 'package:absence_manager/absence_records/models/member_records_response_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockDataProvider {
  static const String absenceRecordsResponseString =
      """{"message":"Success","payload":[{"admitterId":null,"admitterNote":"","confirmedAt":"2020-12-12T18:03:55.000+01:00","createdAt":"2020-12-12T14:17:01.000+01:00","crewId":352,"endDate":"2021-01-13","id":2351,"memberNote":"","rejectedAt":null,"startDate":"2021-01-13","type":"sickness","userId":2664},{"admitterId":null,"admitterNote":"Sorry","confirmedAt":null,"createdAt":"2021-01-03T17:36:52.000+01:00","crewId":352,"endDate":"2021-01-05","id":2521,"memberNote":"ganzer tag","rejectedAt":"2021-01-03T17:39:50.000+01:00","startDate":"2021-01-05","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-09T18:43:29.000+01:00","createdAt":"2021-01-09T17:45:47.000+01:00","crewId":352,"endDate":"2021-01-11","id":2634,"memberNote":"Nachmittag 0,5 Tage. Danke.","rejectedAt":null,"startDate":"2021-01-11","type":"vacation","userId":649},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-01-25T10:04:51.000+01:00","crewId":352,"endDate":"2021-02-06","id":2904,"memberNote":"","rejectedAt":"2021-01-25T10:14:44.000+01:00","startDate":"2021-02-02","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:35:03.000+01:00","createdAt":"2021-01-25T11:06:19.000+01:00","crewId":352,"endDate":"2021-03-11","id":2909,"memberNote":"Urlaub","rejectedAt":null,"startDate":"2021-02-23","type":"vacation","userId":5192},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:34:25.000+01:00","createdAt":"2021-01-27T15:52:59.000+01:00","crewId":352,"endDate":"2021-02-03","id":2942,"memberNote":"","rejectedAt":null,"startDate":"2021-02-03","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:34:31.000+01:00","createdAt":"2021-01-27T15:53:23.000+01:00","crewId":352,"endDate":"2021-03-03","id":2943,"memberNote":"","rejectedAt":null,"startDate":"2021-03-03","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-05T09:31:55.000+01:00","createdAt":"2021-01-30T10:24:36.000+01:00","crewId":352,"endDate":"2021-04-07","id":2955,"memberNote":"Uni: Blockpraktikum","rejectedAt":null,"startDate":"2021-03-27","type":"vacation","userId":2735},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-14T12:02:07.000+01:00","createdAt":"2021-02-14T11:32:56.000+01:00","crewId":352,"endDate":"2021-02-16","id":3229,"memberNote":"","rejectedAt":null,"startDate":"2021-02-16","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"Leider sind Wolfram und Phillip schon im Urlaub. Geh lieber mal im März","confirmedAt":null,"createdAt":"2021-02-14T15:41:26.000+01:00","crewId":352,"endDate":"2021-02-25","id":3235,"memberNote":"Skiurlaub","rejectedAt":"2021-02-14T15:43:06.000+01:00","startDate":"2021-02-20","type":"sickness","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-17T13:52:26.000+01:00","createdAt":"2021-02-17T13:19:37.000+01:00","crewId":352,"endDate":"2021-02-27","id":3269,"memberNote":"","rejectedAt":null,"startDate":"2021-02-27","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-24T13:30:38.000+01:00","createdAt":"2021-02-24T13:24:54.000+01:00","crewId":352,"endDate":"2021-02-27","id":3383,"memberNote":"","rejectedAt":null,"startDate":"2021-02-27","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-01T10:26:10.000+01:00","createdAt":"2021-03-01T09:56:26.000+01:00","crewId":352,"endDate":"2021-03-31","id":3452,"memberNote":"Den alten Urlaubsantrag vom 29.03.2017 - 31.03.2017 bitte löschen.Danke :)","rejectedAt":null,"startDate":"2021-03-30","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"Viel Spaß","confirmedAt":"2021-03-09T17:06:46.000+01:00","createdAt":"2021-03-09T15:01:46.000+01:00","crewId":352,"endDate":"2021-03-13","id":3597,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:33:35.000+01:00","createdAt":"2021-03-09T15:33:35.000+01:00","crewId":352,"endDate":"2021-03-10","id":3600,"memberNote":"","rejectedAt":null,"startDate":"2021-03-10","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:33:57.000+01:00","createdAt":"2021-03-09T15:33:57.000+01:00","crewId":352,"endDate":"2021-03-10","id":3601,"memberNote":"","rejectedAt":null,"startDate":"2021-03-10","type":"vacation","userId":644},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-09T15:34:57.000+01:00","createdAt":"2021-03-09T15:34:57.000+01:00","crewId":352,"endDate":"2021-03-13","id":3604,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":644},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-09T15:35:17.000+01:00","createdAt":"2021-03-09T15:35:17.000+01:00","crewId":352,"endDate":"2021-03-15","id":3605,"memberNote":"","rejectedAt":null,"startDate":"2021-03-14","type":"sickness","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:35:58.000+01:00","createdAt":"2021-03-09T15:35:58.000+01:00","crewId":352,"endDate":"2021-03-18","id":3606,"memberNote":"","rejectedAt":null,"startDate":"2021-03-16","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T19:16:51.000+01:00","createdAt":"2021-03-09T19:16:51.000+01:00","crewId":352,"endDate":"2021-03-13","id":3618,"memberNote":"Test","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-14T15:34:59.000+01:00","createdAt":"2021-03-10T09:19:42.000+01:00","crewId":352,"endDate":"2021-06-16","id":3629,"memberNote":"","rejectedAt":null,"startDate":"2021-06-14","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"Works nicely!","confirmedAt":"2021-03-10T19:37:38.000+01:00","createdAt":"2021-03-10T19:37:23.000+01:00","crewId":352,"endDate":"2021-03-11","id":3656,"memberNote":"","rejectedAt":null,"startDate":"2021-03-11","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"Viel Spaß!","confirmedAt":"2021-03-14T17:00:59.000+01:00","createdAt":"2021-03-14T09:32:42.000+01:00","crewId":352,"endDate":"2021-03-13","id":3690,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"sickness","userId":2796},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-21T18:29:49.000+01:00","createdAt":"2021-03-15T14:54:31.000+01:00","crewId":352,"endDate":"2021-04-22","id":3748,"memberNote":"Barcamp Salzburg","rejectedAt":null,"startDate":"2021-04-21","type":"vacation","userId":649},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-15T16:36:34.000+01:00","createdAt":"2021-03-15T16:36:34.000+01:00","crewId":352,"endDate":"2021-01-02","id":3752,"memberNote":"","rejectedAt":null,"startDate":"2020-12-31","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-21T09:20:57.000+01:00","createdAt":"2021-03-20T22:18:53.000+01:00","crewId":352,"endDate":"2021-09-11","id":3884,"memberNote":"Sommerurlaub","rejectedAt":null,"startDate":"2021-08-24","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-03-26T23:52:11.000+02:00","crewId":352,"endDate":"2021-03-27","id":4101,"memberNote":"","rejectedAt":"2021-03-27T08:18:32.000+02:00","startDate":"2021-03-27","type":"vacation","userId":5293},{"admitterId":709,"admitterNote":"1","confirmedAt":"2021-04-08T16:14:23.000+02:00","createdAt":"2021-04-07T16:45:28.000+02:00","crewId":352,"endDate":"2021-04-11","id":4462,"memberNote":"","rejectedAt":null,"startDate":"2021-04-11","type":"sickness","userId":2664},{"admitterId":null,"admitterNote":"1","confirmedAt":"2021-04-08T21:16:26.000+02:00","createdAt":"2021-04-08T20:12:29.000+02:00","crewId":352,"endDate":"2021-04-12","id":4470,"memberNote":"","rejectedAt":null,"startDate":"2021-04-12","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-04-11T08:24:06.000+02:00","createdAt":"2021-04-09T21:17:12.000+02:00","crewId":352,"endDate":"2021-04-26","id":4471,"memberNote":"bitte den urlaub in der vorwoche  17-21 zurückziehen. merci :)","rejectedAt":null,"startDate":"2021-04-24","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-04-19T14:35:11.000+02:00","createdAt":"2021-04-19T11:20:48.000+02:00","crewId":352,"endDate":"2021-07-28","id":4626,"memberNote":"","rejectedAt":null,"startDate":"2021-07-10","type":"vacation","userId":8447},{"admitterId":null,"admitterNote":"Schönes langes WE!","confirmedAt":"2021-04-26T15:12:11.000+02:00","createdAt":"2021-04-26T09:55:40.000+02:00","crewId":352,"endDate":"2021-04-28","id":4753,"memberNote":"","rejectedAt":null,"startDate":"2021-04-28","type":"vacation","userId":649},{"admitterId":709,"admitterNote":"","confirmedAt":null,"createdAt":"2021-05-12T09:27:30.000+02:00","crewId":352,"endDate":"2021-06-26","id":5291,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"sickness","userId":8007},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-12T10:18:50.000+02:00","createdAt":"2021-05-12T09:43:25.000+02:00","crewId":352,"endDate":"2021-06-23","id":5293,"memberNote":"","rejectedAt":null,"startDate":"2021-06-19","type":"vacation","userId":2796},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-05-16T10:50:30.000+02:00","createdAt":"2021-05-16T10:50:30.000+02:00","crewId":352,"endDate":"2021-05-18","id":5409,"memberNote":"","rejectedAt":null,"startDate":"2021-05-18","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-22T08:50:28.000+02:00","createdAt":"2021-05-21T17:24:42.000+02:00","crewId":352,"endDate":"2021-05-24","id":5555,"memberNote":"","rejectedAt":null,"startDate":"2021-05-24","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-26T16:52:41.000+02:00","createdAt":"2021-05-26T16:05:37.000+02:00","crewId":352,"endDate":"2021-05-30","id":5740,"memberNote":"","rejectedAt":null,"startDate":"2021-05-30","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-05-29T08:42:59.000+02:00","crewId":352,"endDate":"2021-06-30","id":5769,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"vacation","userId":2664},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-05-31T08:55:37.000+02:00","createdAt":"2021-05-30T16:33:57.000+02:00","crewId":352,"endDate":"2021-08-20","id":5879,"memberNote":"","rejectedAt":null,"startDate":"2021-08-05","type":"sickness","userId":8007},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-06-13T07:51:28.000+02:00","createdAt":"2021-06-12T15:21:08.000+02:00","crewId":352,"endDate":"2021-06-27","id":6310,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-06-12T15:21:16.000+02:00","crewId":352,"endDate":"2021-06-29","id":6311,"memberNote":"","rejectedAt":null,"startDate":"2021-06-29","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-06-30T02:13:56.000+02:00","crewId":352,"endDate":"2021-08-12","id":6886,"memberNote":"Pfadfindersommerlager","rejectedAt":null,"startDate":"2021-08-05","type":"vacation","userId":2735}]}""";

  static const String absenceRecordsJson =
      """[{"admitterId":null,"admitterNote":"","confirmedAt":"2020-12-12T18:03:55.000+01:00","createdAt":"2020-12-12T14:17:01.000+01:00","crewId":352,"endDate":"2021-01-13","id":2351,"memberNote":"","rejectedAt":null,"startDate":"2021-01-13","type":"sickness","userId":2664},{"admitterId":null,"admitterNote":"Sorry","confirmedAt":null,"createdAt":"2021-01-03T17:36:52.000+01:00","crewId":352,"endDate":"2021-01-05","id":2521,"memberNote":"ganzer tag","rejectedAt":"2021-01-03T17:39:50.000+01:00","startDate":"2021-01-05","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-09T18:43:29.000+01:00","createdAt":"2021-01-09T17:45:47.000+01:00","crewId":352,"endDate":"2021-01-11","id":2634,"memberNote":"Nachmittag 0,5 Tage. Danke.","rejectedAt":null,"startDate":"2021-01-11","type":"vacation","userId":649},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-01-25T10:04:51.000+01:00","crewId":352,"endDate":"2021-02-06","id":2904,"memberNote":"","rejectedAt":"2021-01-25T10:14:44.000+01:00","startDate":"2021-02-02","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:35:03.000+01:00","createdAt":"2021-01-25T11:06:19.000+01:00","crewId":352,"endDate":"2021-03-11","id":2909,"memberNote":"Urlaub","rejectedAt":null,"startDate":"2021-02-23","type":"vacation","userId":5192},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:34:25.000+01:00","createdAt":"2021-01-27T15:52:59.000+01:00","crewId":352,"endDate":"2021-02-03","id":2942,"memberNote":"","rejectedAt":null,"startDate":"2021-02-03","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-01-27T17:34:31.000+01:00","createdAt":"2021-01-27T15:53:23.000+01:00","crewId":352,"endDate":"2021-03-03","id":2943,"memberNote":"","rejectedAt":null,"startDate":"2021-03-03","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-05T09:31:55.000+01:00","createdAt":"2021-01-30T10:24:36.000+01:00","crewId":352,"endDate":"2021-04-07","id":2955,"memberNote":"Uni: Blockpraktikum","rejectedAt":null,"startDate":"2021-03-27","type":"vacation","userId":2735},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-14T12:02:07.000+01:00","createdAt":"2021-02-14T11:32:56.000+01:00","crewId":352,"endDate":"2021-02-16","id":3229,"memberNote":"","rejectedAt":null,"startDate":"2021-02-16","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"Leider sind Wolfram und Phillip schon im Urlaub. Geh lieber mal im März","confirmedAt":null,"createdAt":"2021-02-14T15:41:26.000+01:00","crewId":352,"endDate":"2021-02-25","id":3235,"memberNote":"Skiurlaub","rejectedAt":"2021-02-14T15:43:06.000+01:00","startDate":"2021-02-20","type":"sickness","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-17T13:52:26.000+01:00","createdAt":"2021-02-17T13:19:37.000+01:00","crewId":352,"endDate":"2021-02-27","id":3269,"memberNote":"","rejectedAt":null,"startDate":"2021-02-27","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-02-24T13:30:38.000+01:00","createdAt":"2021-02-24T13:24:54.000+01:00","crewId":352,"endDate":"2021-02-27","id":3383,"memberNote":"","rejectedAt":null,"startDate":"2021-02-27","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-01T10:26:10.000+01:00","createdAt":"2021-03-01T09:56:26.000+01:00","crewId":352,"endDate":"2021-03-31","id":3452,"memberNote":"Den alten Urlaubsantrag vom 29.03.2017 - 31.03.2017 bitte löschen.Danke :)","rejectedAt":null,"startDate":"2021-03-30","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"Viel Spaß","confirmedAt":"2021-03-09T17:06:46.000+01:00","createdAt":"2021-03-09T15:01:46.000+01:00","crewId":352,"endDate":"2021-03-13","id":3597,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:33:35.000+01:00","createdAt":"2021-03-09T15:33:35.000+01:00","crewId":352,"endDate":"2021-03-10","id":3600,"memberNote":"","rejectedAt":null,"startDate":"2021-03-10","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:33:57.000+01:00","createdAt":"2021-03-09T15:33:57.000+01:00","crewId":352,"endDate":"2021-03-10","id":3601,"memberNote":"","rejectedAt":null,"startDate":"2021-03-10","type":"vacation","userId":644},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-09T15:34:57.000+01:00","createdAt":"2021-03-09T15:34:57.000+01:00","crewId":352,"endDate":"2021-03-13","id":3604,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":644},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-09T15:35:17.000+01:00","createdAt":"2021-03-09T15:35:17.000+01:00","crewId":352,"endDate":"2021-03-15","id":3605,"memberNote":"","rejectedAt":null,"startDate":"2021-03-14","type":"sickness","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T15:35:58.000+01:00","createdAt":"2021-03-09T15:35:58.000+01:00","crewId":352,"endDate":"2021-03-18","id":3606,"memberNote":"","rejectedAt":null,"startDate":"2021-03-16","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-09T19:16:51.000+01:00","createdAt":"2021-03-09T19:16:51.000+01:00","crewId":352,"endDate":"2021-03-13","id":3618,"memberNote":"Test","rejectedAt":null,"startDate":"2021-03-13","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-14T15:34:59.000+01:00","createdAt":"2021-03-10T09:19:42.000+01:00","crewId":352,"endDate":"2021-06-16","id":3629,"memberNote":"","rejectedAt":null,"startDate":"2021-06-14","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"Works nicely!","confirmedAt":"2021-03-10T19:37:38.000+01:00","createdAt":"2021-03-10T19:37:23.000+01:00","crewId":352,"endDate":"2021-03-11","id":3656,"memberNote":"","rejectedAt":null,"startDate":"2021-03-11","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"Viel Spaß!","confirmedAt":"2021-03-14T17:00:59.000+01:00","createdAt":"2021-03-14T09:32:42.000+01:00","crewId":352,"endDate":"2021-03-13","id":3690,"memberNote":"","rejectedAt":null,"startDate":"2021-03-13","type":"sickness","userId":2796},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-03-21T18:29:49.000+01:00","createdAt":"2021-03-15T14:54:31.000+01:00","crewId":352,"endDate":"2021-04-22","id":3748,"memberNote":"Barcamp Salzburg","rejectedAt":null,"startDate":"2021-04-21","type":"vacation","userId":649},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-15T16:36:34.000+01:00","createdAt":"2021-03-15T16:36:34.000+01:00","crewId":352,"endDate":"2021-01-02","id":3752,"memberNote":"","rejectedAt":null,"startDate":"2020-12-31","type":"vacation","userId":644},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-03-21T09:20:57.000+01:00","createdAt":"2021-03-20T22:18:53.000+01:00","crewId":352,"endDate":"2021-09-11","id":3884,"memberNote":"Sommerurlaub","rejectedAt":null,"startDate":"2021-08-24","type":"vacation","userId":2664},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-03-26T23:52:11.000+02:00","crewId":352,"endDate":"2021-03-27","id":4101,"memberNote":"","rejectedAt":"2021-03-27T08:18:32.000+02:00","startDate":"2021-03-27","type":"vacation","userId":5293},{"admitterId":709,"admitterNote":"1","confirmedAt":"2021-04-08T16:14:23.000+02:00","createdAt":"2021-04-07T16:45:28.000+02:00","crewId":352,"endDate":"2021-04-11","id":4462,"memberNote":"","rejectedAt":null,"startDate":"2021-04-11","type":"sickness","userId":2664},{"admitterId":null,"admitterNote":"1","confirmedAt":"2021-04-08T21:16:26.000+02:00","createdAt":"2021-04-08T20:12:29.000+02:00","crewId":352,"endDate":"2021-04-12","id":4470,"memberNote":"","rejectedAt":null,"startDate":"2021-04-12","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-04-11T08:24:06.000+02:00","createdAt":"2021-04-09T21:17:12.000+02:00","crewId":352,"endDate":"2021-04-26","id":4471,"memberNote":"bitte den urlaub in der vorwoche  17-21 zurückziehen. merci :)","rejectedAt":null,"startDate":"2021-04-24","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-04-19T14:35:11.000+02:00","createdAt":"2021-04-19T11:20:48.000+02:00","crewId":352,"endDate":"2021-07-28","id":4626,"memberNote":"","rejectedAt":null,"startDate":"2021-07-10","type":"vacation","userId":8447},{"admitterId":null,"admitterNote":"Schönes langes WE!","confirmedAt":"2021-04-26T15:12:11.000+02:00","createdAt":"2021-04-26T09:55:40.000+02:00","crewId":352,"endDate":"2021-04-28","id":4753,"memberNote":"","rejectedAt":null,"startDate":"2021-04-28","type":"vacation","userId":649},{"admitterId":709,"admitterNote":"","confirmedAt":null,"createdAt":"2021-05-12T09:27:30.000+02:00","crewId":352,"endDate":"2021-06-26","id":5291,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"sickness","userId":8007},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-12T10:18:50.000+02:00","createdAt":"2021-05-12T09:43:25.000+02:00","crewId":352,"endDate":"2021-06-23","id":5293,"memberNote":"","rejectedAt":null,"startDate":"2021-06-19","type":"vacation","userId":2796},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-05-16T10:50:30.000+02:00","createdAt":"2021-05-16T10:50:30.000+02:00","crewId":352,"endDate":"2021-05-18","id":5409,"memberNote":"","rejectedAt":null,"startDate":"2021-05-18","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-22T08:50:28.000+02:00","createdAt":"2021-05-21T17:24:42.000+02:00","crewId":352,"endDate":"2021-05-24","id":5555,"memberNote":"","rejectedAt":null,"startDate":"2021-05-24","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-05-26T16:52:41.000+02:00","createdAt":"2021-05-26T16:05:37.000+02:00","crewId":352,"endDate":"2021-05-30","id":5740,"memberNote":"","rejectedAt":null,"startDate":"2021-05-30","type":"vacation","userId":2796},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-05-29T08:42:59.000+02:00","crewId":352,"endDate":"2021-06-30","id":5769,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"vacation","userId":2664},{"admitterId":709,"admitterNote":"","confirmedAt":"2021-05-31T08:55:37.000+02:00","createdAt":"2021-05-30T16:33:57.000+02:00","crewId":352,"endDate":"2021-08-20","id":5879,"memberNote":"","rejectedAt":null,"startDate":"2021-08-05","type":"sickness","userId":8007},{"admitterId":null,"admitterNote":"","confirmedAt":"2021-06-13T07:51:28.000+02:00","createdAt":"2021-06-12T15:21:08.000+02:00","crewId":352,"endDate":"2021-06-27","id":6310,"memberNote":"","rejectedAt":null,"startDate":"2021-06-26","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-06-12T15:21:16.000+02:00","crewId":352,"endDate":"2021-06-29","id":6311,"memberNote":"","rejectedAt":null,"startDate":"2021-06-29","type":"vacation","userId":5293},{"admitterId":null,"admitterNote":"","confirmedAt":null,"createdAt":"2021-06-30T02:13:56.000+02:00","crewId":352,"endDate":"2021-08-12","id":6886,"memberNote":"Pfadfindersommerlager","rejectedAt":null,"startDate":"2021-08-05","type":"vacation","userId":2735}]""";
  static const String singleAbsenceRecordsJson =
      """[{"admitterId":null,"admitterNote":"","confirmedAt":"2020-12-12T18:03:55.000+01:00","createdAt":"2020-12-12T14:17:01.000+01:00","crewId":352,"endDate":"2021-01-13","id":2351,"memberNote":"","rejectedAt":null,"startDate":"2021-01-13","type":"sickness","userId":2664}]""";

  static List<dynamic> absenceRecordsMapList =
      jsonDecode(absenceRecordsJson) as List<dynamic>;
  static List<dynamic> singleAbsenceRecordsMapList =
      jsonDecode(singleAbsenceRecordsJson) as List<dynamic>;

  static const String absenceRecordJson =
      """{"admitterId":null,"admitterNote":"","confirmedAt":"2020-12-12T18:03:55.000+01:00","createdAt":"2020-12-12T14:17:01.000+01:00","crewId":352,"endDate":"2021-01-13","id":2351,"memberNote":"","rejectedAt":null,"startDate":"2021-01-13","type":"sickness","userId":2664}""";
  static Map<String, dynamic> absenceRecordMap =
      jsonDecode(absenceRecordJson) as Map<String, dynamic>;

  static const String membersJsonResponseString =
      """{"message":"Success","payload":[{"crewId":352,"id":709,"image":"https://loremflickr.com/300/400","name":"Max","userId":644},{"crewId":352,"id":713,"image":"https://loremflickr.com/300/400","name":"Ines","userId":649},{"crewId":352,"id":2245,"image":"https://loremflickr.com/300/400","name":"Monika","userId":2290},{"crewId":352,"id":2650,"image":"https://loremflickr.com/300/400","name":"Mike","userId":2664},{"crewId":352,"id":2778,"image":"https://loremflickr.com/300/400","name":"Bernhard","userId":2796},{"crewId":352,"id":2950,"image":"https://loremflickr.com/300/400","name":"Manuel","userId":2735},{"crewId":352,"id":5876,"image":"https://loremflickr.com/300/400","name":"Daniel","userId":5293},{"crewId":352,"id":7111,"image":"https://loremflickr.com/300/400","name":"Sandra","userId":5192},{"crewId":352,"id":8442,"image":"https://loremflickr.com/300/400","name":"Linda","userId":8007},{"crewId":352,"id":9364,"image":"https://loremflickr.com/300/400","name":"Marlene","userId":8447}]}""";

  static const String membersJson =
      """[{"crewId":352,"id":709,"image":"https://loremflickr.com/300/400","name":"Max","userId":644},{"crewId":352,"id":713,"image":"https://loremflickr.com/300/400","name":"Ines","userId":649},{"crewId":352,"id":2245,"image":"https://loremflickr.com/300/400","name":"Monika","userId":2290},{"crewId":352,"id":2650,"image":"https://loremflickr.com/300/400","name":"Mike","userId":2664},{"crewId":352,"id":2778,"image":"https://loremflickr.com/300/400","name":"Bernhard","userId":2796},{"crewId":352,"id":2950,"image":"https://loremflickr.com/300/400","name":"Manuel","userId":2735},{"crewId":352,"id":5876,"image":"https://loremflickr.com/300/400","name":"Daniel","userId":5293},{"crewId":352,"id":7111,"image":"https://loremflickr.com/300/400","name":"Sandra","userId":5192},{"crewId":352,"id":8442,"image":"https://loremflickr.com/300/400","name":"Linda","userId":8007},{"crewId":352,"id":9364,"image":"https://loremflickr.com/300/400","name":"Marlene","userId":8447}]""";
  static const String singleMembersJson =
      """[{"crewId":352,"id":709,"image":"https://loremflickr.com/300/400","name":"Max","userId":2664}]""";

  static List<dynamic> membersMapList =
      jsonDecode(membersJson) as List<dynamic>;
  static List<dynamic> singleMembersMapList =
      jsonDecode(singleMembersJson) as List<dynamic>;

  static const String memberJson =
      """{"crewId":352,"id":2245,"image":"https://loremflickr.com/300/400","name":"Monika","userId":2290}""";
  static Map<String, dynamic> memberMap =
      jsonDecode(memberJson) as Map<String, dynamic>;

  static var sicknessConfirmedRecord = AbsenceState(
      name: "Adam Milne",
      type: AbsenceRequestType.sickness,
      startDate: DateTime(2021, 01, 13),
      endDate: DateTime(2021, 01, 13),
      status: AbsenceStatusType.confirmed,
      admitterNote: "Admitter Note",
      memberNote: "Member Note");

  static var vacationRejectedRecord = AbsenceState(
      name: "David Miller",
      type: AbsenceRequestType.vacation,
      startDate: DateTime(2021, 01, 13),
      endDate: DateTime(2021, 01, 13),
      status: AbsenceStatusType.rejected,
      admitterNote: "Admitter Note",
      memberNote: "Member Note");

  static var vacationRequestedRecord = AbsenceState(
      name: "David Willy",
      type: AbsenceRequestType.vacation,
      startDate: DateTime(2021, 01, 13),
      endDate: DateTime(2021, 01, 13),
      status: AbsenceStatusType.requested,
      admitterNote: "Admitter Note",
      memberNote: "Member Note");

  static var vacationConfirmedRecord = AbsenceState(
      name: "David Willy",
      type: AbsenceRequestType.vacation,
      startDate: DateTime(2021, 01, 13),
      endDate: DateTime(2021, 01, 15),
      status: AbsenceStatusType.confirmed,
      admitterNote: "Admitter Note",
      memberNote: "Member Note");

  static var absenceRecords = AbsenceRecordsState(
      currentAbsenceRecordsCount: 3,
      totalAbsenceRecordsCount: 3,
      dateFilter: DateTime(2021, 01, 13),
      requestTypeFilter: AbsenceRequestType.vacation,
      records: [
        vacationRejectedRecord,
        vacationRequestedRecord,
        vacationConfirmedRecord
      ]);
}

class MockHttpClient extends Mock implements http.Client {
  MockHttpClient();
  factory MockHttpClient.withSuccess({String? response}) {
    final client = MockHttpClient();
    when(() => client.get(any())).thenAnswer((_) {
      return Future.value(http.Response(response ?? "", 200));
    });
    return client;
  }

  factory MockHttpClient.withFailure() {
    final client = MockHttpClient();
    when(() => client.get(any()))
        .thenAnswer((_) => Future.value(http.Response("", 500)));
    return client;
  }
}

class MockAbsenceRecordsService extends Mock implements AbsenceRecordsService {
  MockAbsenceRecordsService();
  factory MockAbsenceRecordsService.withSuccess() {
    final service = MockAbsenceRecordsService();
    when(() => service.executeService()).thenAnswer((_) {
      return Future.value(AbsenceRecordsResponseModel.fromJson(
          MockDataProvider.absenceRecordsMapList));
    });
    return service;
  }

  factory MockAbsenceRecordsService.withSingleRecord() {
    final service = MockAbsenceRecordsService();
    when(() => service.executeService()).thenAnswer((_) {
      return Future.value(AbsenceRecordsResponseModel.fromJson(
          MockDataProvider.singleAbsenceRecordsMapList));
    });
    return service;
  }

  factory MockAbsenceRecordsService.withFailure() {
    final service = MockAbsenceRecordsService();
    when(() => service.executeService())
        .thenAnswer((_) => Future.value(AbsenceRecordsErrorResponseModel()));
    return service;
  }
}

class MockMemberRecordsService extends Mock implements MemberRecordsService {
  MockMemberRecordsService();
  factory MockMemberRecordsService.withSuccess() {
    final service = MockMemberRecordsService();
    when(() => service.executeService()).thenAnswer((_) {
      return Future.value(
          MemberRecordsResponseModel.fromJson(MockDataProvider.membersMapList));
    });
    return service;
  }

  factory MockMemberRecordsService.withSingleRecord() {
    final service = MockMemberRecordsService();
    when(() => service.executeService()).thenAnswer((_) {
      return Future.value(MemberRecordsResponseModel.fromJson(
          MockDataProvider.singleMembersMapList));
    });
    return service;
  }

  factory MockMemberRecordsService.withFailure() {
    final service = MockMemberRecordsService();
    when(() => service.executeService())
        .thenAnswer((_) => Future.value(MemberRecordsErrorResponseModel()));
    return service;
  }
}

class MockAbsenceRecordsBloc
    extends MockBloc<AbsenceRecordsEvent, AbsenceRecordsState>
    implements AbsenceRecordsBloc {
  MockAbsenceRecordsBloc();
  factory MockAbsenceRecordsBloc.forFilter() {
    final bloc = MockAbsenceRecordsBloc();
    when(() => bloc.state).thenReturn(AbsenceRecordsState());
    return bloc;
  }

  factory MockAbsenceRecordsBloc.withRecords() {
    final bloc = MockAbsenceRecordsBloc();
    when(() => bloc.state).thenReturn(MockDataProvider.absenceRecords);
    return bloc;
  }

  factory MockAbsenceRecordsBloc.withNoRecords() {
    final bloc = MockAbsenceRecordsBloc();
    when(() => bloc.state).thenReturn(AbsenceRecordsState());
    return bloc;
  }

  factory MockAbsenceRecordsBloc.withError() {
    final bloc = MockAbsenceRecordsBloc();
    when(() => bloc.state).thenReturn(AbsenceRecordsErrorState());
    return bloc;
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}
