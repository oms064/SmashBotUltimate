FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS builder
WORKDIR /app

# Copy csproj and NuGet.config then run dotnet restore as distinct layers
COPY nuget.config *.csproj ./
RUN dotnet restore 

#Run database creation
#RUN dotnet ef migrations add BASE
#RUN dotnet ef database update 

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app

# Build environment (Replace your token here if you need it hardcoded everytime!)
#ARG token=lol_no_token_here_skid_git_gud_lmao
#ENV DISCORD_TOKEN=$token

# Install packages
RUN apt-get update -y 

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80

COPY --from=builder /app/out .
ENTRYPOINT ["dotnet", "SmashBotUltimate.dll"]
