# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# # Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY assets/ assets/
COPY --from=build /app/bin/server /app/bin/

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]


# gcloud run deploy --image gcr.io/$PROJECT_ID/hospitals_dart_grpc --platform managed
# gcloud builds submit --tag gcr.io/$PROJECT_ID/hospitals_dart_grpc --project $PROJECT_ID