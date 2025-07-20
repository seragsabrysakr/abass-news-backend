class RoleUtils {
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  static bool isAdmin(String role) {
    return role.toLowerCase() == adminRole;
  }

  static bool isUser(String role) {
    return role.toLowerCase() == userRole;
  }

  static bool canCreateArticles(String role) {
    return isAdmin(role);
  }

  static bool canUpdateArticles(String role) {
    return isAdmin(role);
  }

  static bool canDeleteArticles(String role) {
    return isAdmin(role);
  }

  static bool canViewAllIssues(String role) {
    return isAdmin(role);
  }

  static bool canUpdateIssueStatus(String role) {
    return isAdmin(role);
  }

  static bool canCreateIssues(String role) {
    return true; // Both admin and user can create issues
  }

  static bool canViewUserIssues(String role) {
    return true; // Both admin and user can view their own issues
  }
}
