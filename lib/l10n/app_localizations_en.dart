// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appLogo => 'My Tasks';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordMinLength(Object min) {
    return 'Password must be $min characters or more';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get submit => 'Submit';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get useDemoCredentials => 'Use demo credentials';

  @override
  String get authInvalidCredentials => 'Invalid email or password.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authGenericFailure =>
      'Authentication failed. Please check your credentials.';

  @override
  String get registerEmailInUse =>
      'This email is already in use. Try signing in or use a different email.';

  @override
  String get registerInvalidEmail => 'Enter a valid email address.';

  @override
  String get registerWeakPassword =>
      'Password is too weak. Use a stronger password (6+ chars).';

  @override
  String get registerOperationNotAllowed =>
      'Email/password sign-in is not enabled.';

  @override
  String get registerGenericFailure => 'Registration failed. Please try again.';

  @override
  String get unexpectedError => 'Something went wrong. Please try again.';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get deleteTaskTitle => 'Delete task';

  @override
  String get deleteTaskContent => 'Are you sure you want to delete this task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get createTasksHint => 'Create tasks to see them here.';

  @override
  String get addTask => 'Add task';

  @override
  String get refreshMessage => 'Refreshed';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskTitleRequired => 'Title is required';

  @override
  String get taskDescriptionLabel => 'Description';

  @override
  String get taskStatusLabel => 'Status';

  @override
  String get taskStatusPending => 'Pending';

  @override
  String get taskStatusInProgress => 'In Progress';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get save => 'Save';

  @override
  String get editTaskLabel => 'Edit Task';

  @override
  String get loadingTaskMessage =>
      'Loading task… If this keeps happening the task may not exist.';
}
