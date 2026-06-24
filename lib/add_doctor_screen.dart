import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'doctor.dart';
import 'database_helper.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() =>
      _AddDoctorScreenState();
}

class _AddDoctorScreenState
    extends State<AddDoctorScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController
      specializationController =
      TextEditingController();

  final TextEditingController
      experienceController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Doctor"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Doctor Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller:
                    specializationController,
                decoration: const InputDecoration(
                  labelText: "Specialization",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: experienceController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Experience (Years)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType:
                    TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                  LengthLimitingTextInputFormatter(
                    10,
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  try {
                    if (nameController
                            .text.isEmpty ||
                        specializationController
                            .text.isEmpty ||
                        experienceController
                            .text.isEmpty ||
                        phoneController
                            .text.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please fill all fields",
                          ),
                        ),
                      );
                      return;
                    }

                    print(
                      "Saving Doctor...",
                    );

                    await DatabaseHelper
                        .instance
                        .insertDoctor(
                      Doctor(
                        name:
                            nameController.text,
                        specialization:
                            specializationController
                                .text,
                        experience:
                            experienceController
                                .text,
                        phone:
                            phoneController.text,
                      ),
                    );

                    print(
                      "Doctor Saved Successfully",
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Doctor Saved Successfully",
                        ),
                      ),
                    );

                    nameController.clear();
                    specializationController
                        .clear();
                    experienceController
                        .clear();
                    phoneController.clear();
                  } catch (e) {
                    print("ERROR: $e");

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Error: $e",
                        ),
                      ),
                    );
                  }
                },
                child:
                    const Text("Save Doctor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}