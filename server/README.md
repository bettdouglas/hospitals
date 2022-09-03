A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

# Creating gRPC servers in Dart
To see how to create a simple hospitals server in dart, kindly follow this article
[Building an end-to-end system in dart using grpc* & flutter](https://bettdougie.medium.com/building-an-end-to-end-system-using-grpc-flutter-part-1-d23b2356ed28)

It's a simple guide. This section adds more info on the article.

## Implementing ServerSide Interceptors

gRPC contains interceptors which are executed before or after a request.

According to the docs, an interceptor is typically a function/logic called before the corresponding `ServiceMethod` invocation. If the interceptor returns a `GrpcError`, the error will be returned as a response and `ServiceMethod` wouldn't be called. If the interceptor throws `Exception`, `GrpcError.internal` with `exception.toString()` will be returned. If the interceptor returns null, the corresponding `ServiceMethod` of `Service` will be called.

### Interceptor Example UseCases
1. Handling Authentication
2. Handling Authorization
3. Modifying metadata/Adding custom claims, etc
4. Logging Requests

In our case, since we added Firebase Authentication to the client, we'll be adding authentication to ensure the validity of the jwt token sent by the client. This is to ensure that all requests are from Authenticated Firebase Clients. We'll also create a Logging Interceptor to log our requests. 

## Interceptor Syntax
```dart
typedef Interceptor = FutureOr<GrpcError?> Function(ServiceCall call, ServiceMethod method);
```

Simply explained, we can create an interceptor by creating a function that either returns a GrpcError or null. If the interceptor returns a `GrpcError`, the method will fail. 

This is what we'll use to ensure all our requests are authenticated. 

Before that, let's start with a simple interceptor to log all incoming requests. It's syntax is fairly simple. Here we'll be extracting a couple of information from the clientMetadata. 
The client metadata gives us info like the ip address of the request, the method call, the path, and all other metadata transmitted by the client. 
In the metadata is where things like tokens & other info are stored as a key-value dictionary. 

```dart
Future<GrpcError?> loggingInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final dateTime = DateTime.now();
  final clientMetadata = call.clientMetadata ?? {};
  final authority = clientMetadata[':authority'];
  final methodName = clientMetadata[':path'];
  final method = clientMetadata[':method'];
  final userAgent = clientMetadata['user-agent'];

  logger.info('$authority - - [$dateTime] $method $methodName $userAgent');
  return null;
}
```

When starting the server, we then include the `loggingInterceptor` in the list of interceptors. 
```dart
  final hospitalsData = await Utils.readHospitalsFromCSV();

  final interceptors = [
    loggingInterceptor,
  ];

  final server = Server(
    [HospitalServer(hospitalData: hospitalsData)],
    interceptors,
  );

  final ip = InternetAddress.anyIPv4;

  await server.serve(port: intPort, address: ip);
  ```

When a request arrives, we'll get a log printed by the loggingInterceptor

`0.0.0.0:3001 - - [2022-09-03 10:34:56.962237] POST /HospitalServer/SearchHospitals dart-grpc/2.0.0`

## Auth Interceptor Example
Let's say we have a function that just verifies the token. 

```dart
Future<Either<String, Map<String, dynamic>>> verifyToken(
  String idToken,
) async {
  // ...
  //  returns claims if token
  return FirebaseTokenVerifier().verifyToken(idToken);
}
```

We can create an authentication that takes the response from verify token and return either `GrpcError.unauthenticated` or null;

```dart
Future<GrpcError?> authInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final metadata = call.clientMetadata ?? {};
  final idToken = metadata['token'];
  if (idToken == null) {
    return GrpcError.unauthenticated('Missing Auth Token');
  }
  final response = await verifyToken(idToken);
  return response.fold(
    (l) => GrpcError.unauthenticated(l),
    (claims) {
      metadata['user_id'] = claims['user_id'];
      return;
    },
  );
}
```
If we add it to the server, all requests with invalid tokens will be stopped and the response will be `unauthenticated`. 
If the token is validated however, the user_id will be added to the `clientMetadata`, so successive interceptors can access this value in the metadata. 

```dart
  final hospitalsData = await Utils.readHospitalsFromCSV();

  final interceptors = [
    loggingInterceptor,
    authInterceptor,
  ];

  final server = Server(
    [HospitalServer(hospitalData: hospitalsData)],
    interceptors,
  );

  final ip = InternetAddress.anyIPv4;

  await server.serve(port: intPort, address: ip);
  ```

  This is how we can use interceptors for authentication. 