enum UserRole { therapist, patient }

extension UserRoleX on UserRole {
  String get label => this == UserRole.therapist ? "Therapist" : "Patient";

}
