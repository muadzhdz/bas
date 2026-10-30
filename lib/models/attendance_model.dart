class AttendanceModel {
  final String code;
  final String status;
  final String? studentNpm;
  final String? studentName;
  final DateTime timestamp;

  AttendanceModel({
    required this.code,
    required this.status,
    this.studentNpm,
    this.studentName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
