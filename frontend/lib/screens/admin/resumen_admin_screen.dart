import 'package:cached_network_image/cached_network_image.dart';
import 'package:checkapp/services/attendance_service.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResumenAdminScreen extends StatelessWidget {
  const ResumenAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attendace = Provider.of<AttendanceService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de registros',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimColor),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Revisa las entradas y salida de tus trabajadores',
              style: TextStyle(fontSize: 16, color: AppTheme.checkAppBlue),
            ),
            const SizedBox(
              height: 30,
            ),
            SearchField(),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: _workersGrid(attendace),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<dynamic>> _workersGrid(AttendanceService attendace) {
    return FutureBuilder<List<dynamic>>(
        future: attendace.getCompanyWorkers(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.55),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(0, 1))
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                      width: 60,
                                      height: 60,
                                      imageUrl:
                                          "${snapshot.data?[index]['picture']}"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${snapshot.data?[index]['user_name']}",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: AppTheme.textPending,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: -5,
                              right: -20,
                              child: MaterialButton(
                                height: 25,
                                color: AppTheme.checkAppOrange,
                                elevation: 0,
                                shape: const CircleBorder(),
                                onPressed: () => null,
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                    ));
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        });
  }

  TextField SearchField() {
    return TextField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: AppTheme.checkApptextLight),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: AppTheme.checkApptextLight),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
          filled: true,
          fillColor: Colors.white,
          labelText: 'Busca un trabajador',
          labelStyle: const TextStyle(color: AppTheme.checkApptextLight),
          border: InputBorder.none),
    );
  }
}
