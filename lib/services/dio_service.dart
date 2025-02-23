// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane_startup/services/shared_preference_service.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:retry/retry.dart';


class DioConfig {
  // Static Dio created to directly access Dio client
  static var dio = Dio();
  static Dio getDio({
    dynamic data,
    bool hasAuth = true,
    bool hasBody = true,
  }) {
    Map<String, String> requestHeaders;

    // Passing Headers
    requestHeaders = {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json;charset=UTF-8',
      if (hasAuth) 'Authorization': 'Bearer ${Const.appBearerToken}',
      // 'User-Agent': Platform.isAndroid ? 'Android' : 'iOS',
    };

    BaseOptions options;
    // Adding Additional Options
    options = BaseOptions(
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
      headers: requestHeaders,
    );

    dio.options = options;
    dio.interceptors.add(
      // InterceptorsWrapper(onRequest:
      //     (RequestOptions options, RequestInterceptorHandler handler) async {
      //   if (hasBody) options.data = data;
      //   return handler.next(options);
      // }),
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        if (hasBody) options.data = data;
        return handler.next(options);
      },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          await SharedPrefrenceServices.sharedPreferences!.clear();
          Const.appBearerToken = '';
          Const.isLoggedIn = false;
          Navigator.push(Const.globalKey.currentContext!,
              MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()));
        }
        // Retrieve the error response data
        var errorResponse = error.response?.data;
        
        // Create a new DioError instance with the error response data
        DioException newError = DioException(
          response: error.response,
          requestOptions: error.requestOptions,
          error: errorResponse,
        );

        // Return the new DioError instance
        handler.reject(newError);
        },
      )
      // DioFirebasePerformanceInterceptor(),
    );

    return dio;
  }

  Future<Response> dioServe({
    dynamic data,
    bool hasAuth = true,
    bool hasBody = true,
    required String url,
    HttpMethod httpMethod = HttpMethod.get,
  }) async {
    Response response;
    const timeoutDuration = Duration(seconds: 200);
    final dio = getDio(
      data: data,
      hasAuth: hasAuth,
      hasBody: hasBody,
    );
    try {
      response = await retry(
        () async {
          Response inResponse;
          switch (httpMethod) {
            case HttpMethod.get:
              inResponse = await dio.get(url).timeout(timeoutDuration);
              break;
            case HttpMethod.post:
              inResponse = await dio.post(url).timeout(timeoutDuration);
              break;
            case HttpMethod.put:
              inResponse = await dio.put(url).timeout(timeoutDuration);
              break;
            case HttpMethod.delete:
              inResponse = await dio.delete(url).timeout(timeoutDuration);
              break;
            case HttpMethod.patch:
              inResponse = await dio.patch(url).timeout(timeoutDuration);
              break;
            default:
              inResponse = await dio.get(url).timeout(timeoutDuration);
              break;
          }

          return inResponse;
        },
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      return response;
    } finally {
      // dio.close();
    }
  }
}
