# Stage 1: Giai đoạn biên dịch (Builder stage)
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Sao chép toàn bộ mã nguồn vào container (kết hợp .dockerignore để loại bỏ thư mục build/ và .gradle/ local)
COPY . .

# Cấp quyền thực thi và tiến hành biên dịch JAR (sử dụng --no-daemon để tránh treo máy trong container)
RUN chmod +x ./gradlew && ./gradlew bootJar --no-daemon

# Stage 2: Giai đoạn chạy ứng dụng (Runtime stage)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Sao chép file JAR đã biên dịch từ Stage 1 (builder) sang Stage 2
COPY --from=builder /app/build/libs/*.jar app.jar

# Khai báo cổng mạng ứng dụng và lệnh khởi chạy
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]