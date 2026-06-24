class Doctor {
  int? id;
  String name;
  String specialization;
  String experience;
  String phone;

  Doctor({
    this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'phone': phone,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      specialization: map['specialization'],
      experience: map['experience'],
      phone: map['phone'],
    );
  }
}