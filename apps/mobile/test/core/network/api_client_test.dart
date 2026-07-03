import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinkz/core/network/api_client.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockResponse<T> extends Mock implements Response<T> {}

class MockRequestOptions extends Mock implements RequestOptions {}

class MockDioException extends Mock implements DioException {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

void main() {
  late MockDio mockDio;
  late MockSecureStorage mockSecureStorage;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    mockSecureStorage = MockSecureStorage();
    apiClient = ApiClient(secureStorage: mockSecureStorage, dio: mockDio);
  });

  group('ApiClient', () {
    test('should expose dio instance', () {
      expect(apiClient.dio, equals(mockDio));
    });

    group('GET', () {
      test('should call dio.get with correct path', () async {
        when(() => mockDio.get(
              '/test',
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.get('/test');
        verify(() => mockDio.get('/test')).called(1);
      });
    });

    group('POST', () {
      test('should call dio.post with correct path and data', () async {
        when(() => mockDio.post(
              '/test',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.post('/test', data: {'key': 'value'});
        verify(() => mockDio.post('/test', data: {'key': 'value'})).called(1);
      });
    });

    group('PUT', () {
      test('should call dio.put with correct path', () async {
        when(() => mockDio.put(
              '/test',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.put('/test');
        verify(() => mockDio.put('/test')).called(1);
      });
    });

    group('PATCH', () {
      test('should call dio.patch with correct path', () async {
        when(() => mockDio.patch(
              '/test',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.patch('/test');
        verify(() => mockDio.patch('/test')).called(1);
      });
    });

    group('DELETE', () {
      test('should call dio.delete with correct path', () async {
        when(() => mockDio.delete(
              '/test',
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.delete('/test');
        verify(() => mockDio.delete('/test')).called(1);
      });
    });

    group('UPLOAD', () {
      test('should upload FormData with multipart content type', () async {
        final formData = FormData.fromMap({'file': 'test'});
        when(() => mockDio.post(
              '/upload',
              data: any(named: 'data'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              onSendProgress: any(named: 'onSendProgress'),
            )).thenAnswer((_) async => MockResponse<dynamic>());

        await apiClient.upload('/upload', data: formData);
        verify(() => mockDio.post('/upload', data: formData)).called(1);
      });
    });
  });
}
