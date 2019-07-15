FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
# Set your workdir
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# copy additional files
#COPY ./appsettings.*.json /app/out/
#COPY ./appsettings.json /app/out/

# build runtime image /aspnet -> ASP.NET /runtime -> .NET Core
FROM mcr.microsoft.com/dotnet/core/runtime:2.2
WORKDIR /app

# Standard ENV or ENV description
ENV SQL_USER="YourUserName" \
SQL_PASSWORD="changeme" \
SQL_SERVER="changeme.database.windows.net" \
SQL_DBNAME="mydrivingDB"

# Copy from build
COPY --from=build-env /app/out .

# Run your app (dll name has to be changed)
ENTRYPOINT ["dotnet", "<myapp>.dll"]

