# ---------- Estágio 1: build (Maven + JDK 17) ----------
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -B dependency:go-offline
COPY src ./src
RUN mvn -q -B clean package -DskipTests

# ---------- Estágio 2: runtime (apenas JRE 17) ----------
FROM eclipse-temurin:17-jre
LABEL org.opencontainers.image.title="CURIE API" \
      org.opencontainers.image.description="API RESTful do Projeto CURIE - Challenge FIAP 2026 / CTMSP" \
      org.opencontainers.image.authors="Grupo CURIE 2TDSPB"
WORKDIR /app
RUN useradd --system --uid 1001 curie
COPY --from=build /app/target/curie-api-1.0.0.jar app.jar
USER curie
EXPOSE 8080
# Credenciais e perfil chegam por variáveis de ambiente (nunca no Dockerfile):
#   -e ORACLE_USER=... -e ORACLE_PASSWORD=...        -> Oracle FIAP
#   -e SPRING_PROFILES_ACTIVE=demo                   -> H2 em memória (demonstração)
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]
