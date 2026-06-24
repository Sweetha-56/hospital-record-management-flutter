class Appointment {
  int? id;
  String patientName;
  String doctorName;
  String date;
  String time;

  Appointment({
    this.id,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'doctorName': doctorName,
      'date': date,
      'time': time,
    };
  }

  factory Appointment.fromMap(
    Map<String, dynamic> map,
  ) {
    return Appointment(
      id: map['id'],
      patientName: map['patientName'],
      doctorName: map['doctorName'],
      date: map['date'],
      time: map['time'],
    );
  }
}