import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

class AuthMetadataInterceptor extends ClientInterceptor {
  final FirebaseAuth firebaseAuth;

  late Logger logger;

  AuthMetadataInterceptor({
    required this.firebaseAuth,
  }) {
    logger = Logger('AuthMetadataInterceptor');
  }

  Future<void> _injectToken(Map<String, String> metadata, String uri) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        metadata['token'] = token;
        print('token');
      } catch (e) {
        print(e);
      }
    } else {
      // this cancels the call internally without going to gRPC
      // throw GrpcError.internal("You shouldn't see this");
    }
  }

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
          _injectToken,
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
          _injectToken,
        ],
      ),
    );
    return super.interceptUnary(method, request, modifiedOptions, invoker);
  }
}
