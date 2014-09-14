FROM debian:wheezy

# tag rds13/debian-rbenv
MAINTAINER rds13 "https://github.com/rds13"

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build

# Emplacement for building ruby versions
ENV RBENV_ROOT /root/.rbenv
# Configure environment for bash -l commands
RUN echo 'PATH=/root/.rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
ADD ./versions.txt /root/versions.txt
RUN bash -l -c 'xargs -L 1 rbenv install < /root/versions.txt'

# Generic locale setup
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y --force-yes locales
RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=\"fr_FR.UTF-8\"" >> /etc/environment
RUN dpkg-reconfigure locales
ENV LC_ALL   fr_FR.UTF-8
ENV LANG     fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

# Configure timezone
RUN echo "Europe/Paris" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /root/versions.txt); do rbenv global $v; rbenv rehash; gem install bundler; done'
