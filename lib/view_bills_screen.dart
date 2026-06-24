import 'package:flutter/material.dart';

import 'bill.dart';
import 'database_helper.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ViewBillsScreen extends StatefulWidget {
  const ViewBillsScreen({super.key});

  @override
  State<ViewBillsScreen> createState() =>
      _ViewBillsScreenState();
}

class _ViewBillsScreenState
    extends State<ViewBillsScreen> {
  List<Bill> bills = [];
  List<Bill> filteredBills = [];

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  Future<void> loadBills() async {
    final data =
        await DatabaseHelper.instance.getBills();

    setState(() {
      bills = data;
      filteredBills = data;
    });
  }

  void searchBills(String query) {
    setState(() {
      filteredBills = bills.where((bill) {
        return bill.patientName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            bill.doctorName
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteBill(int id) async {
    await DatabaseHelper.instance.deleteBill(id);

    await loadBills();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Bill Deleted Successfully",
        ),
      ),
    );
  }

  void showDeleteDialog(Bill bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Bill"),
          content: Text(
            "Delete bill for ${bill.patientName}?",
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

                await deleteBill(
                  bill.id!,
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  Future<void> generatePdf(Bill bill) async {
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
                "CITY CARE HOSPITAL",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            ),

            pw.Center(
              child: pw.Text(
                "123 Anna Salai, Chennai - 600001",
              ),
            ),

            pw.Center(
              child: pw.Text(
                "Phone: +91 9876543210",
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Divider(),

            pw.Text("Bill No: BILL${bill.id}"),
            pw.Text(
              "Date: ${now.day}-${now.month}-${now.year}",
            ),
            pw.Text(
              "Time: ${now.hour}:${now.minute}",
            ),

            pw.Divider(),

            pw.Text(
              "Patient Name: ${bill.patientName}",
            ),
            pw.Text(
              "Doctor Name: ${bill.doctorName}",
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              decoration:
                  pw.BoxDecoration(
                border:
                    pw.Border.all(),
              ),
              child: pw.Column(
                children: [
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.all(
                            8),
                    child: pw.Row(
                      mainAxisAlignment:
                          pw.MainAxisAlignment
                              .spaceBetween,
                      children: [
                        pw.Text(
                          "Consultation Fee",
                        ),
                        pw.Text(
                          "Rs.${bill.consultationFee}",
                        ),
                      ],
                    ),
                  ),

                  pw.Divider(),

                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.all(
                            8),
                    child: pw.Row(
                      mainAxisAlignment:
                          pw.MainAxisAlignment
                              .spaceBetween,
                      children: [
                        pw.Text(
                          "Medicine Fee",
                        ),
                        pw.Text(
                          "Rs.${bill.medicineFee}",
                        ),
                      ],
                    ),
                  ),

                  pw.Divider(),

                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.all(
                            8),
                    child: pw.Row(
                      mainAxisAlignment:
                          pw.MainAxisAlignment
                              .spaceBetween,
                      children: [
                        pw.Text(
                          "TOTAL AMOUNT",
                          style: pw.TextStyle(
                            fontWeight:
                                pw.FontWeight
                                    .bold,
                          ),
                        ),
                        pw.Text(
                          "Rs.${bill.totalAmount}",
                          style: pw.TextStyle(
                            fontWeight:
                                pw.FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 40),

            pw.Align(
              alignment:
                  pw.Alignment.centerRight,
              child: pw.Column(
                children: [
                  pw.Text(
                    "Authorized Signature",
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    "_______________",
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            pw.Center(
              child: pw.Text(
                "Thank You For Visiting",
                style: pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            ),

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
        title: const Text("Bills"),
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
              onChanged: searchBills,
              decoration: InputDecoration(
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
            child: filteredBills.isEmpty
                ? const Center(
                    child: Text(
                      "No Bills Found",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        filteredBills.length,
                    itemBuilder:
                        (context, index) {
                      final bill =
                          filteredBills[index];

                      return Card(
                        margin:
                            const EdgeInsets.all(
                          10,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.receipt,
                            color:
                                Colors.green,
                          ),
                          title: Text(
                            bill.patientName,
                          ),
                          subtitle: Text(
                            "Doctor: ${bill.doctorName}\n"
                            "Consultation Fee: ₹${bill.consultationFee}\n"
                            "Medicine Fee: ₹${bill.medicineFee}\n"
                            "Total Amount: ₹${bill.totalAmount}",
                          ),
                          trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
      ),
      onPressed: () {
        generatePdf(bill);
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () {
        showDeleteDialog(
          bill,
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