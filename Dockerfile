FROM python:2.7-slim
MAINTAINER Erico Andrei <ericof@plone.org>

RUN mkdir -p /plone/{logs,.cache} /data
ENV PWD=/plone
ENV XDG_CACHE_HOME=/plone/.cache

WORKDIR /plone

RUN pip install -U setuptools pip virtualenv && virtualenv . 

COPY requirements/ /plone/requirements
COPY admin.* /plone/
COPY etc /plone/etc

ENV buildDeps="python-dev build-essential libssl-dev libbz2-dev"
ENV runDeps="libmagic-dev"
RUN  apt-get update && apt-get install -y --no-install-recommends $buildDeps && \
     apt-get install -y --no-install-recommends $runDeps && \
     ./bin/pip install -r /plone/requirements/base_requirements.txt && \
     SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove $buildDeps  && \
     rm -rf /var/lib/apt/lists/* 

RUN useradd --system -U -u 500 plone && chmod +x admin.sh && \
    chown -R plone:plone /plone/* /plone/.cache /data

USER plone
EXPOSE 8080

CMD "/plone/admin.sh"
