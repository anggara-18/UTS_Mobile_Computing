// lib/models/student.dart

class Student {
  final String name;
  final String avatar;
  final String domisili;
  final String phone;

  Student({
    required this.name,
    required this.avatar,
    required this.domisili,
    required this.phone,
  });

  // Factory constructor untuk membuat Student dari Map (initialStudentsData)
  factory Student.fromMap(Map<String, String> map) {
    return Student(
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      domisili: map['domisili'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
