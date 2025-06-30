class AppUser {
  final String id;
  final String fullName;
  final String profilePhoto;
  final bool isVerified;
  final String phoneNumber;
  final int userType;

  AppUser({
    required this.id,
    required this.fullName,
    required this.profilePhoto,
    required this.isVerified,
    required this.phoneNumber,
    required this.userType,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      isVerified: json['isVerified'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      userType: json['userType'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'profilePhoto': profilePhoto,
        'isVerified': isVerified,
        'phoneNumber': phoneNumber,
        'userType': userType,
      };
}

class AppUserManager {
  static AppUser? currentUser;
}
