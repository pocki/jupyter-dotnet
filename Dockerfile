#build with: docker build --build-arg base_image=jupyter/minimal-notebook -t pocki/minimal-dotnet:latest -t pocki/minimal-dotnet:20210523 .
#build with: docker build --build-arg base_image=jupyter/scipy-notebook -t pocki/scipy-dotnet:latest -t pocki/scipy-dotnet:20210523 .
#build with: docker build --build-arg base_image=jupyter/r-notebook -t pocki/r-dotnet:latest -t pocki/r-dotnet:20210523 .

ARG base_image=jupyter/minimal-notebook
FROM ${base_image} as base

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}

USER root
RUN apt-get update
RUN apt-get install -y curl

ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Opt out of telemetry until after we install jupyter when building the image, this prevents caching of machine id
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

# Install .NET CLI dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu70 \
        libssl3 \
        libstdc++6 \
        zlib1g \
        libgdiplus \
    && rm -rf /var/lib/apt/lists/*

ENV DOTNET_SDK_VERSION 7.0.402
# Install .NET Core SDK
RUN dotnet_sdk_version=7.0.402 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='0c4d654bc7d440f49d14e6e3ea71e636bb37c92c1e835ec87879350f5b00d68465a05c3a2dc078252329c3953a131bc4c2bca6b1d2303ca5af14d3d88a192245' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Copy notebooks
COPY ./samples/notebooks/ ${HOME}/Notebooks/

# Copy package sources
COPY ./NuGet.config ${HOME}/nuget.config

RUN chown -R ${NB_UID} ${HOME}
USER ${USER}

#Install nteract 
RUN pip install nteract_on_jupyter

# Install lastest build from main branch of Microsoft.DotNet.Interactive
RUN dotnet tool install -g Microsoft.dotnet-interactive 

ENV PATH="${PATH}:${HOME}/.dotnet/tools"
#RUN echo "$PATH"

#RUN dotnet --list-sdks

# Install kernel specs
RUN dotnet interactive jupyter install


#RUN dotnet tool install -g Microsoft.Quantum.IQSharp
#RUN dotnet iqsharp install

# Enable telemetry once we install jupyter for the image
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=false

# Set root to Notebooks
WORKDIR ${HOME}/Notebooks/
