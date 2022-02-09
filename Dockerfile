FROM ubuntu:18.04
ARG bedrock_version

ENV VERSION=$bedrock_version
ENV LD_LIBRARY_PATH=.

# Install dependencies
RUN apt-get update && \
    apt-get install -y unzip curl libcurl4 libssl1.0.0 && \
    rm -rf /var/lib/apt/lists/*

# Download and extract the bedrock server
RUN curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip --output bedrock-server.zip && \
    unzip -q bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip

# Create a separate folder for configurations move the original files there and create links for the files
RUN mkdir /bedrock-server/docker && \
    mv /bedrock-server/server.properties /bedrock-server/docker && \
    mv /bedrock-server/permissions.json /bedrock-server/docker && \
    ln -s /bedrock-server/docker/worlds /bedrock-server/worlds && \
    ln -s /bedrock-server/docker/server.properties /bedrock-server/server.properties && \
    ln -s /bedrock-server/docker/permissions.json /bedrock-server/permissions.json && \

WORKDIR /bedrock-server
CMD ./bedrock_server
