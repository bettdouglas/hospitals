# gRPC in Dart & Flutter

The purpose of this repo is to hold the code of the medium article [Building an end-to-end system in dart using grpc* & flutter](https://bettdougie.medium.com/building-an-end-to-end-system-using-grpc-flutter-part-1-d23b2356ed28).


Please read the guide to see how to create a simple gRPC server using dartlang only. 

1. [First Part](https://bettdougie.medium.com/building-an-end-to-end-system-using-grpc-flutter-part-1-d23b2356ed28)
The first part focused on creating the backend in dart & an intro to gRPC in general. 
2. [Second Part](https://bettdougie.medium.com/building-an-end-to-end-system-in-dart-using-grpc-flutter-part-2-with-riverpod-d08be216ebf5)   
The second part focused on creating the Flutter Client with state management using riverpod. 

    - The [app](app/) [README](app/README.md) of the app in the second part focuses on how to use Client Interceptors in gRPC.
    - The [server](server/) [README](server/README.md) focuses on implementing Server Side gRPC interceptors which get called whenever any request is made to the server. That enables things like authentication, logging etc.
  
