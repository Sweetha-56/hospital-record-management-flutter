import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'patient.dart';
import 'doctor.dart';
import 'appointment.dart';
import 'bill.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('hospital.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    // Patients Table
    await db.execute('''
      CREATE TABLE patients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age TEXT,
        gender TEXT,
        phone TEXT
      )
    ''');

    // Doctors Table
    await db.execute('''
      CREATE TABLE doctors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        specialization TEXT,
        experience TEXT,
        phone TEXT
      )
    ''');

    // Appointments Table
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patientName TEXT,
        doctorName TEXT,
        date TEXT,
        time TEXT
      )
    ''');

    await db.execute('''
  CREATE TABLE bills(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    patientName TEXT,
    doctorName TEXT,
    consultationFee TEXT,
    medicineFee TEXT,
    totalAmount TEXT
  )
''');
  }

  // ==========================
  // PATIENT CRUD
  // ==========================

  Future<int> insertPatient(
    Patient patient,
  ) async {
    final db = await database;

    return await db.insert(
      'patients',
      patient.toMap(),
    );
  }

  Future<List<Patient>> getPatients() async {
    final db = await database;

    final result = await db.query('patients');

    return result
        .map((e) => Patient.fromMap(e))
        .toList();
  }

  Future<int> updatePatient(
    Patient patient,
  ) async {
    final db = await database;

    return await db.update(
      'patients',
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> deletePatient(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // DOCTOR CRUD
  // ==========================

  Future<int> insertDoctor(
    Doctor doctor,
  ) async {
    final db = await database;

    return await db.insert(
      'doctors',
      doctor.toMap(),
    );
  }

  Future<List<Doctor>> getDoctors() async {
    final db = await database;

    final result = await db.query('doctors');

    return result
        .map((e) => Doctor.fromMap(e))
        .toList();
  }

  Future<int> updateDoctor(
    Doctor doctor,
  ) async {
    final db = await database;

    return await db.update(
      'doctors',
      doctor.toMap(),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  Future<int> deleteDoctor(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // APPOINTMENT CRUD
  // ==========================

  Future<int> insertAppointment(
    Appointment appointment,
  ) async {
    final db = await database;

    return await db.insert(
      'appointments',
      appointment.toMap(),
    );
  }

  Future<List<Appointment>>
      getAppointments() async {
    final db = await database;

    final result =
        await db.query('appointments');

    return result
        .map((e) => Appointment.fromMap(e))
        .toList();
  }

  Future<int> deleteAppointment(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// ==========================
// BILL CRUD
// ==========================

Future<int> insertBill(
  Bill bill,
) async {
  final db = await database;

  return await db.insert(
    'bills',
    bill.toMap(),
  );
}

Future<List<Bill>> getBills() async {
  final db = await database;

  final result = await db.query(
    'bills',
  );

  return result
      .map((e) => Bill.fromMap(e))
      .toList();
}

Future<int> deleteBill(
  int id,
) async {
  final db = await database;

  return await db.delete(
    'bills',
    where: 'id = ?',
    whereArgs: [id],
  );
}
  // ==========================
  // DASHBOARD COUNTS
  // ==========================

  Future<int> getPatientCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM patients',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getDoctorCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM doctors',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getAppointmentCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM appointments',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

Future<int> getBillCount() async {
  final db = await database;

  final result = await db.rawQuery(
    'SELECT COUNT(*) FROM bills',
  );

  return Sqflite.firstIntValue(result) ?? 0;
}
}