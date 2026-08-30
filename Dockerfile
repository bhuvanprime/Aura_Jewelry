# ==========================================
# Stage 1: Build Flutter Web Application
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy dependency definitions first for Docker layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy full application code and build optimized release web bundle
COPY . .
RUN flutter build web --release --base-href="/"

# ==========================================
# Stage 2: Serve with Nginx Alpine
# ==========================================
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled Flutter web assets to Nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
