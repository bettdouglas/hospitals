# hospitals_riverpod

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## This example displays how to create a gRPC Flutter Client connecting to a gRPC dart client. 

It's been refactored to use Firebase Authentication. 

To be able to run this example, please use the https://firebase.flutter.dev/docs/cli/ for ease of installation. 

It automates the configuration of Flutter Projects which depend on Firebase. This gives us easier configuration options.

After finishing the firebase configuration, you can start the dart server contained in the parent folder called server/
Once you start the server, you should be able to experiment with this project freely. 

### ClientSide gRPC Interceptors

An interceptor is called before the corresponding `ServiceMethod` invocation. If the interceptor returns a `GrpcError`, the error will be returned as a response and `ServiceMethod` wouldn't be called. If the interceptor throws `Exception`, `GrpcError.internal` with `exception.toString()` will be returned. If the interceptor returns null, the corresponding `ServiceMethod` of `Service` will be called.

`ClientInterceptors` intercepts client calls before they are executed.


This means every time a request is made to the server, the logic embedded in the client side interceptor is run. Most of the time interceptors are for
    - Modify request metadata  e.g add Authentication Tokens, add request counts, etc
    - Log Requests.
    - Count the number of requests made.

When gRPC generates the ClientStub, it enables us to pass a list of interceptors which extend `ClientInterceptor` class. 

Let's create a LoggingInterceptor. For this, we want to print all method calls going to the server. We first have to extend the ClientInterceptor class so that we can add our own logic into the interceptor

```dart
class LoggingInterceptor implements ClientInterceptor {
  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    // TODO: implement interceptStreaming
    throw UnimplementedError();
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // TODO: implement interceptUnary
    throw UnimplementedError();
  }
}
```

To know the method call, the `ClientMethod` class contains a parameter called path which represents the name of the method to be invoked on the server. We'll just print the method name here and call the method to proceed with its functionality.

```dart
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    logger.info(method.path);
    logger.info(options.metadata);
    return super.interceptUnary(method, request, options, invoker);
  }
```

All method calls after this will print the name and request metadata contained in the request call. 

### Adding the interceptor to the client stub
Once we have defined an interceptor, we pass it into the ClientStub constructor.

```dart
final clientStub = HospitalServerClient(
  ClientChannel(
    '0.0.0.0', // connect to localhost. Where it's served.
    port: 3001,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(), // transmit unencrypted data.,
    ), // pass the channelOptions above.
  ),
  interceptors: [
    // this logs the requests
    RequestLoggingInterceptor(),
    // this injects the firebase token into the request call
    AuthMetadataInterceptor(firebaseAuth: FirebaseAuth.instance),
  ],
);
```

## Metadata Modifying Interceptor
Let's say you use Firebase Authentication and you want to send the firebase idToken to the backend server since the backend can validate Firebase Claims and know who's the user sending this request. 
We can either have all calls to gRPC call the getIDToken method and manually inject the idToken into the call options then make the call. Or we can create a single interceptor that does that on all calls either Streaming/Unary calls. 

We'll first extend the ClientInterceptor class as in the logging example. We'll also need the FirebaseAuth instance in order to get the current user.
```dart

import 'package:firebase_auth/firebase_auth.dart'; // firebase
import 'package:grpc/grpc.dart';

class AuthInterceptor implements ClientInterceptor {
  final FirebaseAuth firebaseAuth;
  AuthInterceptor({
    required this.firebaseAuth,
  });

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    // TODO: implement interceptStreaming
    throw UnimplementedError();
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // TODO: implement interceptUnary
    throw UnimplementedError();
  }
}

```
The challenge with implementing this is that gRPC interceptors cannot be asynchronous. Luckily for us, the gRPC CallOptions exposes a parameter called providers, which are asynchronous metadata modifying functions. It syntax goes like
```dart
  Future<void> _injectToken(Map<String, String> metadata, String uri) async {
    metadata['token'] = 'user token';
    metadata['request_time'] = DateTime.now().toIso8601String();
  }
```
In our case, we'll inject the token as below
```dart
  Future<void> _injectToken(Map<String, String> metadata, String uri) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      metadata['token'] = token;
    }
  }
```

Once we've defined the metadata modifying function, we create a copy of the outgoing call options and call the super method we're intercepting.

```dart
  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final modifiedOptions = options.mergedWith(
      CallOptions(
        providers: [
          _injectToken, // method signatures match, so we should be ok
        ],
      ),
    );
    return super.interceptStreaming(method, requests, modifiedOptions, invoker);
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final modifiedOptions = options.mergedWith(
      CallOptions(
        providers: [
          (Map<String, String> metadata, String uri) {
            return _injectToken(metadata, uri);
          },
        ],
      ),
    );
    return super.interceptUnary(method, request, modifiedOptions, invoker);
  }
```
I hope that makes us understand how to handle inject metadata that come from asynchronous source.

To look into the server-side interceptors, the guide will be in the README contained in the `server/` folder