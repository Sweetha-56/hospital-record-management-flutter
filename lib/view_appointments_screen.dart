import 'package:flutter/material.dart';

import 'appointment.dart';
import 'database_helper.dart';

class ViewAppointmentsScreen extends StatefulWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  State<ViewAppointmentsScreen> createState() =>
      _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState
    extends State<ViewAppointmentsScreen> {
  List<Appointment> appointments = [];
  List<Appointment> filteredAppointments = [];

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final data =
        await DatabaseHelper.instance.getAppointments();

    setState(() {
      appointments = data;
      filteredAppointments = data;
    });
  }

  void searchAppointments(String query) {
    setState(() {
      filteredAppointments =
          appointments.where((appointment) {
        return appointment.patientName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            appointment.doctorName
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteAppointment(int id) async {
    await DatabaseHelper.instance.deleteAppointment(id);

    await loadAppointments();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Appointment Deleted Successfully",
        ),
      ),
    );
  }

  void showDeleteDialog(
      Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Appointment",
          ),
          content: Text(
            "Delete appointment for ${appointment.patientName}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                Navigator.pop(context);

                await deleteAppointment(
                  appointment.id!,
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(10),
            child: TextField(
              controller:
                  searchController,
              onChanged:
                  searchAppointments,
              decoration:
                  InputDecoration(
                hintText:
                    "Search Patient or Doctor",
                prefixIcon:
                    const Icon(Icons.search),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredAppointments.isEmpty
                    ? const Center(
                        child: Text(
                          "No Appointments Found",
                          style:
                              TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredAppointments
                                .length,
                        itemBuilder:
                            (context,
                                index) {
                          final appointment =
                              filteredAppointments[
                                  index];

                          return Card(
                            margin:
                                const EdgeInsets
                                    .all(
                              10,
                            ),
                            child:
                                ListTile(
                              leading:
                                  const Icon(
                                Icons
                                    .calendar_month,
                              ),
                              title: Text(
                                appointment
                                    .patientName,
                              ),
                              subtitle:
                                  Text(
                                "Doctor: ${appointment.doctorName}\n"
                                "Date: ${appointment.date}\n"
                                "Time: ${appointment.time}",
                              ),
                              trailing:
                                  IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .delete,
                                  color:
                                      Colors.red,
                                ),
                                onPressed:
                                    () {
                                  showDeleteDialog(
                                    appointment,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}