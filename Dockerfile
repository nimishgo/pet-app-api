FROM python:3.9-alpine3.13
LABEL maintainer="neoncoder.com"

ENV PYTHONBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt 
COPY ./app /app 
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
WORKDIR /app
EXPOSE 8000
# upgrade pip
# install requirements
# remove /tmp to remove extra dependencies

ARG DEV=false
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = true ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
# no need of home dir
# disabel pass word for security

# for any python command set the env variable to use it directly 
ENV PATH="/py/bin:$PATH"
USER django-user 