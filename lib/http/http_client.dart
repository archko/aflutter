import 'dart:collection';

import 'package:dio/dio.dart';

import 'interceptor/http_log_interceptor.dart';
import 'http_response.dart';

class HttpClient {
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static HttpClient get instance => _getInstance();
  static HttpClient _instance;
  Dio dio;

  HttpClient._init() {
    if (dio == null) {
      dio = new Dio();
      dio.interceptors.add(HttpLogInterceptor());
    }
  }

  static HttpClient _getInstance() {
    if (_instance == null) {
      _instance = new HttpClient._init();
    }
    return _instance;
  }

  Future get(url, {params, header, option}) async {
    ///Headers
    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    ///Options
    if (null == option) {
      option = new Options();
      option.responseType = ResponseType.plain;
    }
    option.headers = headers;
    option.method = GET;

    //Response response;
    //response = await dio.get("/test", options: option);
    //print(response.data.toString());
    return request(url, options: option);
  }

  Future post(url, {params, header, option}) async {
    ///Headers
    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (null == option) {
      option = new Options();
      option.responseType = ResponseType.plain;
    }
    option.headers = headers;
    option.method = POST;
    return request(url, options: option);
  }

  Future postForm(url, {formData, params, header}) async {
    //FormData formData = new FormData.from({
    //  "name": "wendux",
    //  "age": 25,
    //  //"file1": new UploadFileInfo(new File("./upload.txt"), "upload1.txt")
    //  //"file2": new UploadFileInfo(new File("./upload.txt"), "upload2.txt")
    //});

    return dio.request(url, data: formData);
  }

  Future<HttpResponse> request(url, {options, params}) async {
    Response response;

    ///dio request
    try {
      response = await dio.request(url, data: params, options: options);
    } on DioError catch (e) {
      Response errorResponse = e.response ?? Response();
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = 503;
      }
      return HttpResponse(e.message, false, errorResponse.statusCode);
    }

    ///result
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpResponse(response.data, true, 200);
      }
    } catch (e) {
      print("params:$params, headers:${options.header}");
      print("net error:${e.toString()}");
      return HttpResponse(e.toString(), false, response.statusCode);
    }

    print("some error:");
    return HttpResponse("net work error", false, response.statusCode);
  }
}
