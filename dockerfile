FROM mcr.microsoft.com/dotnet/sdk:6.0 AS sources

ARG PROJECT=API
ARG CONFIGURATION=Release

WORKDIR /sources

COPY ./${PROJECT} ./src/${PROJECT}

RUN dotnet new sln \
    && dotnet sln add src/*/*.csproj \
    && dotnet restore \
    && dotnet publish -c ${CONFIGURATION} --output /app

RUN rm -rf /sources

FROM mcr.microsoft.com/dotnet/aspnet:6.0

ARG OPTIONAL_PKG
ARG ENVIRONMENT=Production

ENV ASPNETCORE_ENVIRONMENT=Production

RUN [ -z "${OPTIONAL_PKG}" ] && echo "No Optional Package" || apt-get update && apt-get install -y ${OPTIONAL_PKG}

WORKDIR /app

RUN mkdir -p ./file ./logs && chmod 777 -R ./file ./logs

VOLUME [ "/app/file", "/app/logs" ]

COPY --from=sources /app ./
# COPY ./*.${ENVIRONMENT}.IT.json .

EXPOSE 80 443 5001

ENTRYPOINT export APP=$(basename *.runtimeconfig.json .runtimeconfig.json) && dotnet $APP.dll