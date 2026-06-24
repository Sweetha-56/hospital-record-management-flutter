import 'package:flutter/material.dart';

import 'login_screen.dart';

import 'database_helper.dart';

import 'add_patient_screen.dart';
import 'view_patients_screen.dart';

import 'add_doctor_screen.dart';
import 'view_doctors_screen.dart';

import 'add_appointment_screen.dart';
import 'view_appointments_screen.dart';

import 'add_bill_screen.dart';
import 'view_bills_screen.dart';

void main() {
  runApp(const HospitalApp());
}

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Record Management',
      home: const LoginScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  int patientCount = 0;
  int doctorCount = 0;
  int appointmentCount = 0;
  int billCount = 0;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    patientCount =
        await DatabaseHelper.instance.getPatientCount();

    doctorCount =
        await DatabaseHelper.instance.getDoctorCount();

    appointmentCount =
        await DatabaseHelper.instance
            .getAppointmentCount();

    billCount =
        await DatabaseHelper.instance.getBillCount();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hospital Record Management',
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildStatCard(
                        "Patients",
                        patientCount,
                        Colors.blue.shade100,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildStatCard(
                        "Doctors",
                        doctorCount,
                        Colors.green.shade100,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: buildStatCard(
                        "Appointments",
                        appointmentCount,
                        Colors.orange.shade100,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildStatCard(
                        "Bills",
                        billCount,
                        Colors.purple.shade100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddPatientScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.person_add,
                      "Add Patient",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewPatientsScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.people,
                      "View Patients",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddDoctorScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.medical_services,
                      "Add Doctor",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewDoctorsScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.local_hospital,
                      "View Doctors",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddAppointmentScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.calendar_month,
                      "Add Appointment",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewAppointmentsScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.list_alt,
                      "View Appointments",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddBillScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.receipt_long,
                      "Add Bill",
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewBillsScreen(),
                        ),
                      ).then((_) => loadCounts());
                    },
                    child: buildCard(
                      Icons.receipt,
                      "View Bills",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCard(
  IconData icon,
  String title,
) {
  return Card(
    elevation: 5,
    child: Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 50,
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget buildStatCard(
  String title,
  int count,
  Color color,
) {
  return Card(
    color: color,
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$count",
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    ),
  );
}



