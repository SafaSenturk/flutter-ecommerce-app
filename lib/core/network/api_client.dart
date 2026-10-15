import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppErrorType { network, timeout, server, unknown }

/// A single error type the UI understands, whatever went wrong underneath.
class AppException implements Exception {
  const AppException(this.type, [this.message]);

  final AppErrorType type;
  final String? message;

  factory AppException.from(Object error) {
    if (error is AppException) return error;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const AppException(AppErrorType.timeout);
        case DioExceptionType.connectionError:
          return const AppException(AppErrorType.network);
        case DioExceptionType.badResponse:
          return AppException(AppErrorType.server, 'HTTP ${error.response?.statusCode}');
        default:
          return AppException(AppErrorType.unknown, error.message);
      }
    }
    return AppException(AppErrorType.unknown, error.toString());
  }

  @override
  String toString() => 'AppException($type, $message)';
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
