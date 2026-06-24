import 'package:flutter/material.dart';
import 'patient.dart';
import 'database_helper.dart';

class ViewPatientsScreen extends StatefulWidget {
  const ViewPatientsScreen({super.key});

  @override
  State<ViewPatientsScreen> createState() =>
      _ViewPatientsScreenState();
}

class _ViewPatientsScreenState
    extends State<ViewPatientsScreen> {
  List<Patient> patients = [];
  List<Patient> filteredPatients = [];

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    final data =
        await DatabaseHelper.instance.getPatients();

    setState(() {
      patients = data;
      filteredPatients = data;
    });
  }

  void searchPatients(String query) {
    setState(() {
      filteredPatients = patients
          .where(
            (patient) => patient.name
                .toLowerCase()
                .contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  Future<void> deletePatient(int id) async {
    await DatabaseHelper.instance.deletePatient(id);

    await loadPatients();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Patient Deleted Successfully",
        ),
      ),
    );
  }

  Future<void> updatePatient(
    Patient patient,
  ) async {
    await DatabaseHelper.instance.updatePatient(
      patient,
    );

    await loadPatients();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Patient Updated Successfully",
        ),
      ),
    );
  }

  void showDeleteDialog(Patient patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Patient"),
          content: Text(
            "Are you sure you want to delete ${patient.name}?",
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

                await deletePatient(
                  patient.id!,
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Patient patient) {
    TextEditingController nameController =
        TextEditingController(
      text: patient.name,
    );

    TextEditingController ageController =
        TextEditingController(
      text: patient.age,
    );

    TextEditingController phoneController =
        TextEditingController(
      text: patient.phone,
    );

    String gender = patient.gender;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Patient"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(
                    labelText: "Patient Name",
                  ),
                ),

                TextField(
                  controller: ageController,
                  decoration:
                      const InputDecoration(
                    labelText: "Age",
                  ),
                ),

                DropdownButtonFormField<String>(
                  value: gender,
                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text("Other"),
                    ),
                  ],
                  onChanged: (value) {
                    gender = value!;
                  },
                ),

                TextField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Phone Number",
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
                Patient updatedPatient =
                    Patient(
                  id: patient.id,
                  name:
                      nameController.text,
                  age:
                      ageController.text,
                  gender: gender,
                  phone:
                      phoneController.text,
                );

                Navigator.pop(context);

                await updatePatient(
                  updatedPatient,
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
        title: const Text("Patients"),
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
                  searchPatients,
              decoration:
                  InputDecoration(
                hintText:
                    "Search Patient",
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
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
                filteredPatients.isEmpty
                    ? const Center(
                        child: Text(
                          "No Patients Found",
                          style:
                              TextStyle(
                            fontSize:
                                20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredPatients
                                .length,
                        itemBuilder:
                            (context,
                                index) {
                          final patient =
                              filteredPatients[
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
                                Icons.person,
                              ),
                              title: Text(
                                patient.name,
                              ),
                              subtitle:
                                  Text(
                                "Age: ${patient.age}\n"
                                "Gender: ${patient.gender}\n"
                                "Phone: ${patient.phone}",
                              ),
                              trailing:
                                  Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(
                                      Icons
                                          .edit,
                                      color:
                                          Colors.blue,
                                    ),
                                    onPressed:
                                        () {
                                      showEditDialog(
                                        patient,
                                      );
                                    },
                                  ),
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
                                        patient,
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