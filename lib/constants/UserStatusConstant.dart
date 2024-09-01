enum UserStatus { Pending, Approved, Blocked }

class UserStatusUtil {
  static UserStatus getStatusTypeFromInt(int value) {
    return switch (value) {
      0 => UserStatus.Pending,
      1 => UserStatus.Approved,
      2 => UserStatus.Blocked,
      _ => UserStatus.Pending,
    };
  }

  static int getIntFromStatus(UserStatus value) {
    return switch (value) {
      UserStatus.Pending => 0,
      UserStatus.Approved => 1,
      UserStatus.Blocked => 2,
    };
  }
}
