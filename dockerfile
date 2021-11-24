FROM mcr.microsoft.com/dotnet/sdk:6.0 AS sources

ARG PROJECT=API
ARG CONFIGURATION=Release
ARG GRPC_TOOLS_VERSION=2.42.0

WORKDIR /sources

COPY ./${PROJECT} ./src/${PROJECT}

RUN dotnet new sln \
    && dotnet sln add src/*/*.csproj \
    && dotnet restore \
    && dotnet publish -c ${CONFIGURATION} --output /app

# RUN apk update \
#     && apk --no-cache add libc6-compat protobuf \
#     && apk --no-cache add protobuf \
#     && ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 \
#     && cd /root/.nuget/packages/grpc.tools/${GRPC_TOOLS_VERSION}/tools/linux_x64 \
#     && rm protoc \
#     && ln -s /usr/bin/protoc protoc \
#     && chmod +x grpc_csharp_plugin

# RUN dotnet publish -c ${CONFIGURATION} --output /app

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