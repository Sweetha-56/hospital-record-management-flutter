import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'patient.dart';
import 'database_helper.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Patient"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter patient name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter age";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
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
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }

                  if (value.length != 10) {
                    return "Phone number must be 10 digits";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  print("Save button clicked");
                  if (_formKey.currentState!.validate()) {
                    await DatabaseHelper.instance.insertPatient(
                      Patient(
                        name: nameController.text,
                        age: ageController.text,
                        gender: selectedGender,
                        phone: phoneController.text,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Patient Saved Successfully",
                        ),
                      ),
                    );

                    nameController.clear();
                    ageController.clear();
                    phoneController.clear();

                    setState(() {
                      selectedGender = "Male";
                    });
                  }
                },
                child: const Text("Save Patient"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}