FROM keybaseio/client:latest AS keybase
FROM mcr.microsoft.com/dotnet/core/runtime:3.1 AS runtime

ARG KEYS_PATH=keys/

RUN apt-get update \
    && apt-get install -y gnupg2 procps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
COPY ${KEYS_PATH}tini_key.asc /tini_key.asc
RUN gpg --import /tini_key.asc \
    && rm /tini_key.asc \
    && gpg --batch --verify /tini.asc /tini \
    && chmod +x /tini

ENV GOSU_VERSION 1.11
ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 /usr/local/bin/gosu
ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc /usr/local/bin/gosu.asc
COPY ${KEYS_PATH}gosu_key.asc /gosu_key.asc
RUN gpg --import /gosu_key.asc \
    && rm /gosu_key.asc \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu

RUN useradd --create-home --shell /bin/bash keybase \
    && mkdir -p /var/log/keybase \
    && chown keybase:keybase /var/log/keybase
VOLUME [ "/home/keybase/.config/keybase", "/home/keybase/.local/share/keybase" ]

COPY --from=keybase /usr/bin/keybase /usr/bin/keybase
COPY --from=keybase /usr/bin/keybase.sig /usr/bin/keybase.sig
COPY --from=keybase /usr/bin/kbfsfuse /usr/bin/kbfsfuse
COPY --from=keybase /usr/bin/kbfsfuse.sig /usr/bin/kbfsfuse.sig
COPY --from=keybase /usr/bin/git-remote-keybase /usr/bin/git-remote-keybase
COPY --from=keybase /usr/bin/git-remote-keybase.sig /usr/bin/git-remote-keybase.sig
COPY --from=keybase /usr/bin/entrypoint.sh /usr/bin/keybase-entrypoint.sh
RUN chmod +x /usr/bin/keybase-entrypoint.sh

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENV KEYBASE_SERVICE 1
ENV KEYBASE_USERNAME (please specify)
ENV KEYBASE_PAPERKEY (please specify)
ENV ENTRYPOINT program.dll
VOLUME ["/var/keybase.net"]

ENTRYPOINT ["/tini", "--", "keybase-entrypoint.sh"]
CMD ["entrypoint.sh"]
