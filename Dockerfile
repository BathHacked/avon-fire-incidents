# bathhacked/avon-fire-incidents Docker Image
#
# DOCKER-VERSION: 0.7.0
#
# Version: 1.0

FROM ubuntu:trusty
MAINTAINER Toby Jackson, toby@warmfusion.co.uk

# Make sure package repo is up-to-date and install some dependencies
#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y


RUN apt-get install  libproj-dev libgeo-proj4-perl make -y
RUN apt-get install ruby ruby-dev -y
RUN apt-get install gcc g++  -y
RUN gem install bundle


# Lets do some avon specific stuff now...
ADD . /avon-fire-incidents
WORKDIR /avon-fire-incidents
RUN bundle install 

