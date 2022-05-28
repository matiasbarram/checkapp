import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';

import '../../helpers/date_time_helper.dart';

class EmployeeInfoScreen extends StatelessWidget {
  const EmployeeInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeInfo = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final List<dynamic> attendances = employeeInfo['attendances'];
    final String pictureUrl = employeeInfo['picture'];
    print(attendances);

    return Scaffold(
        body: NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text('Información de ${employeeInfo["user_name"]}'),
            pinned: false,
            expandedHeight: 100.0,
          ),
        ];
      },
      body: _ListViewCards(attendances: attendances),
    ));
  }
}

class _ListViewCards extends StatelessWidget {
  const _ListViewCards({
    Key? key,
    required this.attendances,
  }) : super(key: key);

  final List attendances;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: attendances.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> attendance = attendances[index];
          final String attendanceType = attendance['event_type'];
          final String attendaceEvent =
              formatDateTimetoTime(attendance['event_time']);
          final String attendanceComment = attendance['comments'];

          return _AttendanceCard(
              attendanceType: attendanceType,
              attendanceComment: attendanceComment,
              attendaceEvent: attendaceEvent);
        });
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({
    Key? key,
    required this.attendanceType,
    required this.attendanceComment,
    required this.attendaceEvent,
  }) : super(key: key);

  final String attendanceType;
  final String attendanceComment;
  final String attendaceEvent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(children: [
            Text(attendanceType),
            Text(attendanceComment),
          ]),
          Column(children: [
            Text(attendaceEvent),
          ]),
          const Icon(
            Icons.check,
            color: Colors.green,
          )
        ]),
      ),
    );
  }
}
