FROM jenkinsci/jnlp-slave:latest

USER root

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# install cypress dependencies
RUN apt-get update && \
  apt-get install -y \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    xvfb

# install chrome
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google.list && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update && \
    apt-get install -y dbus-x11 --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Add zip utility - it comes in very handy
RUN apt-get update && apt-get install -y zip

# install firefox-esr
RUN apt-get install -y --no-install-recommends firefox-esr

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# environment variables for convenience
ENV TERM xterm
ENV npm_config_loglevel warn

# tool version
RUN node -v
RUN npm -v
RUN google-chrome --version
RUN zip --version
RUN git --version

USER jenkins
