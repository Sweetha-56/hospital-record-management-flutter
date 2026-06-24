class Bill {
  int? id;
  String patientName;
  String doctorName;
  String consultationFee;
  String medicineFee;
  String totalAmount;

  Bill({
    this.id,
    required this.patientName,
    required this.doctorName,
    required this.consultationFee,
    required this.medicineFee,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'doctorName': doctorName,
      'consultationFee': consultationFee,
      'medicineFee': medicineFee,
      'totalAmount': totalAmount,
    };
  }

  factory Bill.fromMap(
    Map<String, dynamic> map,
  ) {
    return Bill(
      id: map['id'],
      patientName: map['patientName'],
      doctorName: map['doctorName'],
      consultationFee: map['consultationFee'],
      medicineFee: map['medicineFee'],
      totalAmount: map['totalAmount'],
    );
  }
}