import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';

class AuthMetadataInterceptor extends ClientInterceptor {
  final FirebaseAuth firebaseAuth;
  AuthMetadataInterceptor({
    required this.firebaseAuth,
  });

  var count = 0;

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return super.interceptStreaming(
      method,
      requests,
      options,
      invoker,
    );
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    count++;
    return super.interceptUnary(
      method,
      request,
      options.mergedWith(
        CallOptions(
          metadata: {'value': 'test'},
          providers: [
            /// insert headers here
            (metadata, uri) async {
              final user = firebaseAuth.currentUser;
              if (user != null) {
                final idToken = await user.getIdToken();
                metadata['token'] = idToken;
                metadata['count'] = count.toString();
              } else {
                // throw 'User not logged in';
              }
            },
          ],
        ),
      ),
      invoker,
    );
  }
}
