import 'package:flutter/material.dart';

import 'patient.dart';
import 'doctor.dart';
import 'appointment.dart';
import 'database_helper.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() =>
      _AddAppointmentScreenState();
}

class _AddAppointmentScreenState
    extends State<AddAppointmentScreen> {
  String? selectedPatient;
  String? selectedDoctor;

  List<Patient> patients = [];
  List<Doctor> doctors = [];

  final TextEditingController dateController =
      TextEditingController();

  final TextEditingController timeController =
      TextEditingController();

  final TextEditingController reasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final patientData =
        await DatabaseHelper.instance.getPatients();

    final doctorData =
        await DatabaseHelper.instance.getDoctors();

    setState(() {
      patients = patientData;
      doctors = doctorData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedPatient,
                decoration: const InputDecoration(
                  labelText: "Select Patient",
                  border: OutlineInputBorder(),
                ),
                items: patients.map((patient) {
                  return DropdownMenuItem(
                    value: patient.name,
                    child: Text(patient.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPatient = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedDoctor,
                decoration: const InputDecoration(
                  labelText: "Select Doctor",
                  border: OutlineInputBorder(),
                ),
                items: doctors.map((doctor) {
                  return DropdownMenuItem(
                    value: doctor.name,
                    child: Text(doctor.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Appointment Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate =
                      await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Appointment Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime =
                      await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    timeController.text =
                        pickedTime.format(context);
                  }
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason for Visit",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (selectedPatient == null ||
                      selectedDoctor == null ||
                      dateController.text.isEmpty ||
                      timeController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all fields",
                        ),
                      ),
                    );
                    return;
                  }

                  await DatabaseHelper.instance
                      .insertAppointment(
                    Appointment(
                      patientName:
                          selectedPatient!,
                      doctorName:
                          selectedDoctor!,
                      date: dateController.text,
                      time: timeController.text,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Appointment Booked Successfully",
                      ),
                    ),
                  );

                  setState(() {
                    selectedPatient = null;
                    selectedDoctor = null;
                  });

                  dateController.clear();
                  timeController.clear();
                  reasonController.clear();
                },
                child: const Text(
                  "Book Appointment",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}