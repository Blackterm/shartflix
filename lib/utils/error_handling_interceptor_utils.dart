import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app_utils.dart';
import 'snackbar_status_enum.dart';

class ErrorHandingInterceptor extends Interceptor {
  final BuildContext context;

  ErrorHandingInterceptor(this.context);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppUtils.showSnackBar(
      context,
      err.message ?? 'An error occurred',
      status: MessageStatus.error,
    );
    super.onError(err, handler);
  }
}
