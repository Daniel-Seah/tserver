FROM alpine:3.15.0 AS base

# Download terraria and tmodloader
ARG SERVER_VERSION=1432
ARG SERVER_LINK=https://terraria.org/api/download/pc-dedicated-server/terraria-server-$SERVER_VERSION.zip
ARG TMOD_LINK=https://github.com/tModLoader/tModLoader/releases/download/v0.11.8.5/tModLoader.Linux.v0.11.8.5.tar.gz
WORKDIR /download
RUN wget $SERVER_LINK -O terraria-server.zip && \
  unzip terraria-server.zip && \
  wget $TMOD_LINK -O tmodloader.tgz && \
  tar -zxvf tmodloader.tgz -C $SERVER_VERSION/Linux

# Download mods
ARG MODS=""
WORKDIR /mods
COPY install_mods.sh .
RUN apk add --no-cache bash && \
  ./install_mods.sh $MODS && \
  rm install_mods.sh

FROM mono:6.12.0.122-slim

# Install
ARG SERVER_VERSION=1432
COPY --from=base /mods/ /mods/
WORKDIR /bin
COPY --from=base /download/$SERVER_VERSION/Linux/* ./

EXPOSE 7777
CMD ["/bin/tModLoaderServer", "-modpath /mods"]
