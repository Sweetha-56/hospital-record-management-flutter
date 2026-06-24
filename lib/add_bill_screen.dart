import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'bill.dart';
import 'database_helper.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() =>
      _AddBillScreenState();
}

class _AddBillScreenState
    extends State<AddBillScreen> {
  final consultationController =
      TextEditingController();

  final medicineController =
      TextEditingController();

  List<String> patients = [];
  List<String> doctors = [];

  String? selectedPatient;
  String? selectedDoctor;

  int totalAmount = 0;

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
      patients =
          patientData.map((e) => e.name).toList();

      doctors =
          doctorData.map((e) => e.name).toList();
    });
  }

  void calculateTotal() {
    int consultation =
        int.tryParse(
              consultationController.text,
            ) ??
            0;

    int medicine =
        int.tryParse(
              medicineController.text,
            ) ??
            0;

    setState(() {
      totalAmount =
          consultation + medicine;
    });
  }

  Future<void> saveBill() async {
    if (selectedPatient == null ||
        selectedDoctor == null ||
        consultationController.text.isEmpty ||
        medicineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );
      return;
    }

    Bill bill = Bill(
      patientName: selectedPatient!,
      doctorName: selectedDoctor!,
      consultationFee:
          consultationController.text,
      medicineFee:
          medicineController.text,
      totalAmount:
          totalAmount.toString(),
    );

    await DatabaseHelper.instance
        .insertBill(bill);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Bill Saved Successfully",
        ),
      ),
    );

    setState(() {
      selectedPatient = null;
      selectedDoctor = null;
      totalAmount = 0;
    });

    consultationController.clear();
    medicineController.clear();
  }

  Future<void> generatePdf() async {
  if (selectedPatient == null ||
      selectedDoctor == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Select patient and doctor first",
        ),
      ),
    );
    return;
  }

  final now = DateTime.now();

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment:
              pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "HOSPITAL RECORD MANAGEMENT SYSTEM",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Date: ${now.day}-${now.month}-${now.year}",
            ),

            pw.Text(
              "Time: ${now.hour}:${now.minute}",
            ),

            pw.Text(
              "Bill No: BILL${now.millisecondsSinceEpoch}",
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Patient Name: $selectedPatient",
              style: pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.Text(
              "Doctor Name: $selectedDoctor",
              style: pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Divider(),

            pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment
                      .spaceBetween,
              children: [
                pw.Text(
                  "Consultation Fee",
                ),
                pw.Text(
                  "Rs.${consultationController.text}",
                ),
              ],
            ),

            pw.SizedBox(height: 8),

            pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment
                      .spaceBetween,
              children: [
                pw.Text(
                  "Medicine Fee",
                ),
                pw.Text(
                  "Rs.${medicineController.text}",
                ),
              ],
            ),

            pw.Divider(),

            pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment
                      .spaceBetween,
              children: [
                pw.Text(
                  "TOTAL AMOUNT",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Rs.$totalAmount",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 40),

            pw.Center(
              child: pw.Text(
                "Thank You For Visiting",
                style: pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text(
                "Get Well Soon!",
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async =>
        pdf.save(),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Generate Bill",
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Autocomplete<String>(
                optionsBuilder:
                    (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return patients;
                  }

                  return patients.where(
                    (patient) => patient
                        .toLowerCase()
                        .contains(
                          value.text
                              .toLowerCase(),
                        ),
                  );
                },
                onSelected: (selection) {
                  selectedPatient =
                      selection;
                },
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Search Patient",
                      border:
                          OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.search),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              Autocomplete<String>(
                optionsBuilder:
                    (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return doctors;
                  }

                  return doctors.where(
                    (doctor) => doctor
                        .toLowerCase()
                        .contains(
                          value.text
                              .toLowerCase(),
                        ),
                  );
                },
                onSelected: (selection) {
                  selectedDoctor =
                      selection;
                },
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Search Doctor",
                      border:
                          OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.search),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller:
                    consultationController,
                keyboardType:
                    TextInputType.number,
                onChanged: (value) {
                  calculateTotal();
                },
                decoration:
                    const InputDecoration(
                  labelText:
                      "Consultation Fee",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller:
                    medicineController,
                keyboardType:
                    TextInputType.number,
                onChanged: (value) {
                  calculateTotal();
                },
                decoration:
                    const InputDecoration(
                  labelText:
                      "Medicine Fee",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹$totalAmount",
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: saveBill,
                child: const Text(
                  "Generate Bill",
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: generatePdf,
                icon: const Icon(
                  Icons.picture_as_pdf,
                ),
                label: const Text(
                  "Generate PDF",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}