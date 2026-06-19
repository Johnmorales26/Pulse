// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginButton => 'Sign in';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get signUpButton => 'Sign up';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get usernameLabel => 'Username';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get hasAccountPrompt => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get savedPlacesOption => 'My saved places';

  @override
  String get settingsOption => 'Settings';

  @override
  String get signOutButton => 'Sign Out';

  @override
  String get noName => 'No name';

  @override
  String get saveButton => 'Save';

  @override
  String get savedButton => 'Saved';

  @override
  String get removeSavedTooltip => 'Remove from saved';

  @override
  String get addSavedTooltip => 'Save place';

  @override
  String get navigateButton => 'Go';

  @override
  String get navigateTooltip => 'Navigate';

  @override
  String get commentHint => 'Write a comment...';

  @override
  String get commentAdded => 'Comment added';

  @override
  String get commentError => 'Error adding comment';

  @override
  String get retryButton => 'Retry';

  @override
  String get openWith => 'Open with';

  @override
  String get noMapsInstalled => 'No map applications installed.';

  @override
  String get noSavedPlaces => 'You haven\'t saved any places yet.';

  @override
  String get signInRequired => 'You must be signed in to perform this action.';

  @override
  String get signInToSave => 'You must be signed in to save places.';

  @override
  String get saveFailed => 'Could not update saved list.';

  @override
  String get loadPlaceError => 'Error loading place';

  @override
  String get authErrorWrongCredentials => 'Incorrect email or password.';

  @override
  String get authErrorEmailInUse => 'This email is already registered.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorPasswordMismatch => 'Passwords do not match.';

  @override
  String get authErrorEmptyUsername => 'Username cannot be empty.';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get addPlaceTitle => 'New place';

  @override
  String get placeNameLabel => 'Name';

  @override
  String get placeNameHint => 'Enter place name';

  @override
  String get placeDescriptionLabel => 'Description';

  @override
  String get placeDescriptionHint => 'Enter description';

  @override
  String get categoryLabel => 'Category';

  @override
  String get selectCategoryTitle => 'Select Category';

  @override
  String get savePlaceButton => 'Save Place';

  @override
  String get savingLabel => 'Saving...';

  @override
  String get placeSavedSuccess => 'Place saved successfully.';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordHint => 'Min. 6 characters';

  @override
  String get usernameHint => 'Pulse user';

  @override
  String get forgotPasswordButton => 'Forgot your password?';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please wait a moment.';

  @override
  String get authErrorNetworkFailed => 'No internet connection.';

  @override
  String get authErrorGeneric => 'Authentication error. Please try again.';

  @override
  String get myLocationTooltip => 'Center on my location';

  @override
  String get profileTooltip => 'Profile';

  @override
  String mapLoadError(String error) {
    return 'Could not load the map: $error';
  }

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Enable it in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get commentDateFormat => 'MMM dd, yyyy · HH:mm';

  @override
  String get changeProfilePicture => 'Change profile picture';

  @override
  String get cameraOption => 'Take a photo';

  @override
  String get galleryOption => 'Choose from gallery';

  @override
  String savedPlacesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved places',
      one: '1 saved place',
      zero: 'No saved places',
    );
    return '$_temp0';
  }

  @override
  String get filterLabel => 'Filter';

  @override
  String get loadingMap => 'Setting Up Map';

  @override
  String get unknownCategory => 'Unknown';

  @override
  String get searchHint => 'Search places...';

  @override
  String get searchLabel => 'Search';

  @override
  String get noResults => 'No places match your search';

  @override
  String distanceFormat(String distance) {
    return '$distance';
  }
}
