import 'package:dio/dio.dart' as dioclient;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_http_client/loading_screen.dart';

class HttpClientFunction {
  String connectTimeout = 'Check your connection';
  String receiveTimeout = 'Unable to connect to the server';
  String otherErrorDio = 'Oops, Something went wrong';
  String cancelErrorDio = 'Request to API server was cancelled';
  String sendTimeout = 'Send timeout in connection with API server';
  String socketException = 'Unexpected error occurred';

  Future<dynamic> post(url, params, header) async {
    try {
      dioclient.Dio dio = dioclient.Dio();
      dioclient.Response response;
      dioclient.FormData formdata = dioclient.FormData.fromMap(params);

      response = await dio.post(url,
          data: formdata,
          options: dioclient.Options(
            headers: header,
          ));
      final json = response;
      return json;
    } on dioclient.DioError catch (e) {
      errorMsg(e);
      return e.message.toString();
    }
  }

  //DIO
  Future<dynamic> postWithoutParam(url, header) async {
    try {
      dioclient.Dio dio = dioclient.Dio();
      dioclient.Response response;

      response = await dio.post(url,
          // data: formdata,
          options: dioclient.Options(
            headers: header,
          ));
      final json = response;
      return json;
    } on dioclient.DioError catch (e) {
      errorMsg(e);

      return e.message.toString();
    }
  }

  Future<dynamic> get(url, header) async {
    // baseController.isSuccess.value = false;
    try {
      dioclient.Dio dio = dioclient.Dio();
      dioclient.Response response;

      response = await dio.get(url,
          options: dioclient.Options(
            headers: header,
          ));
      // print('json get dio ' + response.data.toString());
      // BaseController().onComplete();
      final json = response;
      return json;
    } on dioclient.DioError catch (e) {
      errorMsg(e);
      return e.message.toString();
    }
  }

  void onComplete() {
    LoadingScreen().hide();
  }

  errorMsg(e) async {
    String msg = e.message.toString();
    if (e.type == dioclient.DioErrorType.cancel) {
      msg = cancelErrorDio;
    } else if (e.type == dioclient.DioErrorType.connectionTimeout) {
      msg = connectTimeout;
    } else if (e.type == dioclient.DioErrorType.receiveTimeout) {
      msg = receiveTimeout;
    } else if (e.type == dioclient.DioErrorType.sendTimeout) {
      msg = sendTimeout;
    } else {
      msg = "Something Went Wrong";
    }

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#e74c3c",
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
    );

    // BaseController().onError(msg);
  }

  handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['error'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }
}
