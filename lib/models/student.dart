class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String department;
  final String year;
  final String email;
  final String phone;
  final String avatarUrl;

  const Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.year,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });

  Student copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? department,
    String? year,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      department: department ?? this.department,
      year: year ?? this.year,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
