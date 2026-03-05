import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get appTitle;

  /// Title shown on the login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// Label for the sign-in button
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// Title shown on the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpTitle;

  /// Label for the sign-up button
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButton;

  /// Label for the email text field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Label for the password text field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Label for the username text field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// Label for the confirm-password field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// Prompt shown below the login form
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// Tappable link that goes to the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// Prompt shown below the sign-up form
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccountPrompt;

  /// Tappable link that goes back to login
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// AppBar title of the profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Option tile label for editing profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Option tile label for saved places
  ///
  /// In en, this message translates to:
  /// **'My saved places'**
  String get savedPlacesOption;

  /// Option tile label for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsOption;

  /// Label for the sign-out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButton;

  /// Fallback text when the user has no username set
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// Label for the save/bookmark button (not yet saved)
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Label for the save/bookmark button (already saved)
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedButton;

  /// Tooltip when bookmark is active
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get removeSavedTooltip;

  /// Tooltip when bookmark is inactive
  ///
  /// In en, this message translates to:
  /// **'Save place'**
  String get addSavedTooltip;

  /// Label for the navigate/directions button
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get navigateButton;

  /// Tooltip for the navigate button
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigateTooltip;

  /// Hint text inside the comment text field
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get commentHint;

  /// SnackBar message after a comment is successfully submitted
  ///
  /// In en, this message translates to:
  /// **'Comment added'**
  String get commentAdded;

  /// SnackBar message when adding a comment fails
  ///
  /// In en, this message translates to:
  /// **'Error adding comment'**
  String get commentError;

  /// Label for the retry button on error screens
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Title of the map picker bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Open with'**
  String get openWith;

  /// SnackBar shown when no map app is found
  ///
  /// In en, this message translates to:
  /// **'No map applications installed.'**
  String get noMapsInstalled;

  /// Empty state message in the saved places sheet
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any places yet.'**
  String get noSavedPlaces;

  /// SnackBar shown when an unauthenticated user tries a protected action
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to perform this action.'**
  String get signInRequired;

  /// SnackBar shown when an unauthenticated user tries to bookmark
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to save places.'**
  String get signInToSave;

  /// SnackBar shown when toggling a bookmark fails
  ///
  /// In en, this message translates to:
  /// **'Could not update saved list.'**
  String get saveFailed;

  /// Error message shown when place data cannot be fetched
  ///
  /// In en, this message translates to:
  /// **'Error loading place'**
  String get loadPlaceError;

  /// Auth error for wrong-password login attempt
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorWrongCredentials;

  /// Auth error when email is already taken on sign-up
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authErrorEmailInUse;

  /// Validation message for weak passwords
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// Validation message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authErrorPasswordMismatch;

  /// Validation message when username is blank
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty.'**
  String get authErrorEmptyUsername;

  /// Validation message for malformed email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// AppBar title on the add-place screen
  ///
  /// In en, this message translates to:
  /// **'New place'**
  String get addPlaceTitle;

  /// Label for the place name text field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get placeNameLabel;

  /// Hint for the place name text field
  ///
  /// In en, this message translates to:
  /// **'Enter place name'**
  String get placeNameHint;

  /// Label for the place description text field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get placeDescriptionLabel;

  /// Hint for the place description text field
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get placeDescriptionHint;

  /// Section title above the category selector
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// Title of the category picker bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategoryTitle;

  /// Label on the save FAB when idle
  ///
  /// In en, this message translates to:
  /// **'Save Place'**
  String get savePlaceButton;

  /// Label on the save FAB while uploading
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLabel;

  /// SnackBar shown after a place is saved
  ///
  /// In en, this message translates to:
  /// **'Place saved successfully.'**
  String get placeSavedSuccess;

  /// Generic fallback error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// Hint text for the email field
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// Hint text for password fields
  ///
  /// In en, this message translates to:
  /// **'Min. 6 characters'**
  String get passwordHint;

  /// Hint text for the username field
  ///
  /// In en, this message translates to:
  /// **'Pulse user'**
  String get usernameHint;

  /// Tappable text below the login form
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordButton;

  /// Auth error when user account is disabled
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authErrorUserDisabled;

  /// Auth error for rate-limited requests
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get authErrorTooManyRequests;

  /// Auth error when the device is offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get authErrorNetworkFailed;

  /// Generic fallback for unhandled Firebase Auth errors
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please try again.'**
  String get authErrorGeneric;

  /// Tooltip for the my-location FAB on the map
  ///
  /// In en, this message translates to:
  /// **'Center on my location'**
  String get myLocationTooltip;

  /// Tooltip for the profile icon on the map
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTooltip;

  /// Error shown when the map fails to load
  ///
  /// In en, this message translates to:
  /// **'Could not load the map: {error}'**
  String mapLoadError(String error);

  /// SnackBar shown when the user refuses GPS permission
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Enable it in Settings.'**
  String get locationPermissionDenied;

  /// Action button label on the location-permission SnackBar
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// intl DateFormat pattern for comment timestamps in English
  ///
  /// In en, this message translates to:
  /// **'MMM dd, yyyy · HH:mm'**
  String get commentDateFormat;

  /// Title of the image source picker bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get changeProfilePicture;

  /// Option to pick image from camera
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get cameraOption;

  /// Option to pick image from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get galleryOption;

  /// Plural-aware saved places count shown in the sheet header
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No saved places} =1{1 saved place} other{{count} saved places}}'**
  String savedPlacesCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
