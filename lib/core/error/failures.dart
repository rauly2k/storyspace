import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for error handling using freezed
@freezed
abstract class Failure with _$Failure {
  const Failure._();

  /// Network-related failure (no internet, timeout, etc.)
  const factory Failure.network({
    @Default('Network error. Please check your connection.') String message,
  }) = NetworkFailure;

  /// Server-related failure (500, 503, etc.)
  const factory Failure.server({
    @Default('Server error. Please try again later.') String message,
  }) = ServerFailure;

  /// Cache/local storage failure
  const factory Failure.cache({
    @Default('Local storage error.') String message,
  }) = CacheFailure;

  /// Authentication failure (login, signup, etc.)
  const factory Failure.auth({
    @Default('Authentication failed.') String message,
  }) = AuthFailure;

  /// Firebase Firestore failure
  const factory Failure.firestore({
    @Default('Database error occurred.') String message,
  }) = FirestoreFailure;

  /// Firebase Storage failure
  const factory Failure.storage({
    @Default('File storage error occurred.') String message,
  }) = StorageFailure;

  /// Gemini AI API failure
  const factory Failure.gemini({
    @Default('AI generation failed. Please try again.') String message,
  }) = GeminiFailure;

  /// Validation failure (form validation, input errors)
  const factory Failure.validation({
    @Default('Invalid input.') String message,
  }) = ValidationFailure;

  /// Permission denied failure
  const factory Failure.permission({
    @Default('Permission denied.') String message,
  }) = PermissionFailure;

  /// Not found failure (404)
  const factory Failure.notFound({
    @Default('Resource not found.') String message,
  }) = NotFoundFailure;

  /// Subscription/payment failure
  const factory Failure.subscription({
    @Default('Subscription error occurred.') String message,
  }) = SubscriptionFailure;

  /// Content safety failure (inappropriate content blocked)
  const factory Failure.contentSafety({
    @Default('Content blocked for safety reasons.') String message,
  }) = ContentSafetyFailure;

  /// Quota exceeded failure (rate limiting, usage limits)
  const factory Failure.quotaExceeded({
    @Default('Usage limit exceeded.') String message,
  }) = QuotaExceededFailure;

  /// Unknown/unexpected failure
  const factory Failure.unknown({
    @Default('An unexpected error occurred.') String message,
  }) = UnknownFailure;

  /// Database failure (generic local database error)
  const factory Failure.database({
    @Default('Database error occurred.') String message,
  }) = DatabaseFailure;

  /// API failure (external API error)
  const factory Failure.api({
    @Default('API error occurred.') String message,
  }) = ApiFailure;

  /// Configuration failure (app configuration error)
  const factory Failure.configuration({
    @Default('Configuration error occurred.') String message,
  }) = ConfigurationFailure;

  /// Get user-friendly error message
  String get errorMessage => when(
        network: (msg) => msg,
        server: (msg) => msg,
        cache: (msg) => msg,
        auth: (msg) => msg,
        firestore: (msg) => msg,
        storage: (msg) => msg,
        gemini: (msg) => msg,
        validation: (msg) => msg,
        permission: (msg) => msg,
        notFound: (msg) => msg,
        subscription: (msg) => msg,
        contentSafety: (msg) => msg,
        quotaExceeded: (msg) => msg,
        unknown: (msg) => msg,
        database: (msg) => msg,
        api: (msg) => msg,
        configuration: (msg) => msg,
      );
}
