FROM microsoft/dotnet:2.2-sdk-alpine AS build

ARG http_proxy=
ARG https_proxy=
ARG no_proxy=

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/dotnet:2.2-runtime-alpine AS runtime
ARG GIT_COMMIT=unknown
ARG BUILD_DATE=unknown
ARG BUILD_VERSION=unknown

# TODO: deprecated, for legay ui frontend
LABEL author="Awesome Incremented <marcel.koertgen@gmail.com>"

# cf.: http://label-schema.org/rc1/
LABEL org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="hello.redis.dotnet" \
      org.label-schema.description="...TODO..." \
      org.label-schema.usage="https://github.com/mkoertgen/hello.redis/blob/master/README.md" \
      org.label-schema.url="https://github.com/mkoertgen/hello.redis" \
      org.label-schema.vcs-url="https://github.com/mkoertgen/hello.redis" \
      org.label-schema.vcs-ref="${GIT_COMMIT}" \
      org.label-schema.vendor="Awesome Incremented" \
      org.label-schema.version="${BUILD_VERSION}" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d hello.redis.dotnet"
# TODO: even more labels...

WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "hello.redis.dotnet.dll"]