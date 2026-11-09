class Faculty {
  final String id;
  final String name;
  final String designation;
  final String department;
  final String qualification;
  final String experience;
  final String specialization;
  final String officeLocation;
  final String officeHours;
  final String email;
  final String phone;
  final String about;
  final List<String> areasOfExpertise;
  final List<String> workingDays;
  final String openingTime;
  final String closingTime;
  final int slotDurationMinutes;
  final List<String> availableSlots;
  final List<DateTime> unavailableDates;
  final List<String> holidays;
  final String avatarUrl;
  final bool isAvailableNow;
  final double rating;
  final int totalReviews;

  const Faculty({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.qualification,
    required this.experience,
    required this.specialization,
    required this.officeLocation,
    required this.officeHours,
    required this.email,
    required this.phone,
    required this.about,
    required this.areasOfExpertise,
    required this.workingDays,
    required this.openingTime,
    required this.closingTime,
    required this.slotDurationMinutes,
    required this.availableSlots,
    required this.unavailableDates,
    required this.holidays,
    required this.avatarUrl,
    this.isAvailableNow = true,
    this.rating = 4.8,
    this.totalReviews = 42,
  });

  Faculty copyWith({
    String? id,
    String? name,
    String? designation,
    String? department,
    String? qualification,
    String? experience,
    String? specialization,
    String? officeLocation,
    String? officeHours,
    String? email,
    String? phone,
    String? about,
    List<String>? areasOfExpertise,
    List<String>? workingDays,
    String? openingTime,
    String? closingTime,
    int? slotDurationMinutes,
    List<String>? availableSlots,
    List<DateTime>? unavailableDates,
    List<String>? holidays,
    String? avatarUrl,
    bool? isAvailableNow,
    double? rating,
    int? totalReviews,
  }) {
    return Faculty(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      department: department ?? this.department,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      officeLocation: officeLocation ?? this.officeLocation,
      officeHours: officeHours ?? this.officeHours,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      areasOfExpertise: areasOfExpertise ?? this.areasOfExpertise,
      workingDays: workingDays ?? this.workingDays,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      availableSlots: availableSlots ?? this.availableSlots,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      holidays: holidays ?? this.holidays,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAvailableNow: isAvailableNow ?? this.isAvailableNow,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}
