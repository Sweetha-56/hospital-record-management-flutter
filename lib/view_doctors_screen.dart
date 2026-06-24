import 'package:flutter/material.dart';

import 'doctor.dart';
import 'database_helper.dart';

class ViewDoctorsScreen extends StatefulWidget {
  const ViewDoctorsScreen({super.key});

  @override
  State<ViewDoctorsScreen> createState() =>
      _ViewDoctorsScreenState();
}

class _ViewDoctorsScreenState
    extends State<ViewDoctorsScreen> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    final data =
        await DatabaseHelper.instance.getDoctors();

    setState(() {
      doctors = data;
      filteredDoctors = data;
    });
  }

  void searchDoctors(String query) {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor.name
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            doctor.specialization
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteDoctor(int id) async {
    await DatabaseHelper.instance.deleteDoctor(id);

    await loadDoctors();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Doctor Deleted Successfully"),
      ),
    );
  }

  Future<void> updateDoctor(Doctor doctor) async {
    await DatabaseHelper.instance.updateDoctor(
      doctor,
    );

    await loadDoctors();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Doctor Updated Successfully"),
      ),
    );
  }

  void showDeleteDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Doctor"),
          content: Text(
            "Are you sure you want to delete ${doctor.name}?",
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
                await deleteDoctor(doctor.id!);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Doctor doctor) {
    TextEditingController nameController =
        TextEditingController(text: doctor.name);

    TextEditingController specializationController =
        TextEditingController(
      text: doctor.specialization,
    );

    TextEditingController experienceController =
        TextEditingController(
      text: doctor.experience,
    );

    TextEditingController phoneController =
        TextEditingController(text: doctor.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Doctor"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Doctor Name",
                  ),
                ),
                TextField(
                  controller:
                      specializationController,
                  decoration: const InputDecoration(
                    labelText: "Specialization",
                  ),
                ),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(
                    labelText: "Experience",
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Doctor updatedDoctor = Doctor(
                  id: doctor.id,
                  name: nameController.text,
                  specialization:
                      specializationController.text,
                  experience:
                      experienceController.text,
                  phone: phoneController.text,
                );

                Navigator.pop(context);

                await updateDoctor(
                  updatedDoctor,
                );
              },
              child: const Text("Save"),
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
        title: const Text("Doctors"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: searchDoctors,
              decoration: InputDecoration(
                hintText:
                    "Search Doctor or Specialization",
                prefixIcon:
                    const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredDoctors.isEmpty
                ? const Center(
                    child: Text(
                      "No Doctors Found",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filteredDoctors.length,
                    itemBuilder:
                        (context, index) {
                      final doctor =
                          filteredDoctors[index];

                      return Card(
                        margin:
                            const EdgeInsets.all(
                          10,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.medical_services,
                          ),
                          title: Text(
                            doctor.name,
                          ),
                          subtitle: Text(
                            "Specialization: ${doctor.specialization}\n"
                            "Experience: ${doctor.experience} Years\n"
                            "Phone: ${doctor.phone}",
                          ),
                          trailing: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color:
                                      Colors.blue,
                                ),
                                onPressed: () {
                                  showEditDialog(
                                    doctor,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.red,
                                ),
                                onPressed: () {
                                  showDeleteDialog(
                                    doctor,
                                  );
                                },
                              ),
                            ],
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