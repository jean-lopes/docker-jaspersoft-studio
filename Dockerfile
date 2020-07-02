FROM debian:buster-slim
MAINTAINER marcus.rickert@accso.de
RUN adduser --disabled-login --uid 1000 jaspersoft
RUN chown jaspersoft.jaspersoft /home/jaspersoft
ARG VERSION=6.13.0
ENV FILENAME=TIB_js-studiocomm_${VERSION}_linux_amd64.deb

RUN mkdir -p /opt

COPY ./assets/${FILENAME} /opt

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
	   curl \
	   libgtk-3-0 \
	   libxtst6 \
    && dpkg -i /opt/${FILENAME} \
    && apt-get install -f \
    && rm /opt/${FILENAME}

COPY assets/docker-entrypoint.sh /docker-entrypoint.sh
ENV DOCKER_USER=jaspersoft
RUN mkdir -p /home/${DOCKER_USER}/home_on_host
RUN mkdir -p /home/${DOCKER_USER}/.subversion
RUN mkdir -p /home/root/.subversion
RUN echo "[auth]\npassword-store = \n" > /home/${DOCKER_USER}/.subversion/config
RUN mkdir -p /home/root/.subversion
RUN echo "[auth]\npassword-store = \n" > /home/root/.subversion/config
ENTRYPOINT [ "/docker-entrypoint.sh" ]
