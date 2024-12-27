#build with: docker build --build-arg base_image=quay.io/jupyter/minimal-notebook -t pocki/minimal-dotnet8:latest -t pocki/minimal-dotnet8:20210523 .
#build with: docker build --build-arg base_image=quay.io/jupyter/scipy-notebook -t pocki/scipy-dotnet8:latest -t pocki/scipy-dotnet8:20210523 .
#build with: docker build --build-arg base_image=quay.io/jupyter/r-notebook -t pocki/r-dotnet8:latest -t pocki/r-dotnet8:20210523 .

ARG base_image=quay.io/jupyter/minimal-notebook
FROM ${base_image} as base

ARG TARGETPLATFORM
ENV ARCHITECTURE=$ARCHITECTURE
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER}
ENV NB_UID=${NB_UID}
ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}

USER root
ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Opt out of telemetry until after we install jupyter when building the image, this prevents caching of machine id
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

# Install .NET CLI dependencies for Ubuntu 24.04
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        libc6 \
        libgcc-s1 \
        libgssapi-krb5-2 \
        libicu74 \
        liblttng-ust1 \
        libssl3 \
        libstdc++6 \
        libunwind8 \
        zlib1g \
        libgdiplus \
    && rm -rf /var/lib/apt/lists/*

ENV DOTNET_SDK_VERSION=8.0.404
ENV DOTNET_SDK_CHECKSUM=''
# Install .NET Core SDK
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        ARCHITECTURE=x64; \
        DOTNET_SDK_CHECKSUM='2f166f7f3bd508154d72d1783ffac6e0e3c92023ccc2c6de49d22b411fc8b9e6dd03e7576acc1bb5870a6951181129ba77f3bf94bb45fe9c70105b1b896b9bb9'; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then  \ 
        ARCHITECTURE=arm64; \
        DOTNET_SDK_CHECKSUM='d147ca2e6aad8bc751b522ae91399e0e3867c42d17f892e23c8dd086ab6ccb0c13319d9b89c024b5a61ffb298e95bcfc82d9256074ddace882145c9d5a4be071'; \
    fi \
    && dotnet_sdk_version=${DOTNET_SDK_VERSION} \
    && wget -nv -O dotnet.tar.gz https://builds.dotnet.microsoft.com/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-${ARCHITECTURE}.tar.gz \
    && dotnet_sha512=${DOTNET_SDK_CHECKSUM} \
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
RUN pip install nteract_on_jupyter --no-cache-dir

# Install lastest build from main branch of Microsoft.DotNet.Interactive
RUN dotnet tool install -g Microsoft.dotnet-interactive --no-cache

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
