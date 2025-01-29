FROM alpine:latest

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}


RUN apk add --no-cache \
    openssh-client \
    curl \
    unzip \
    bash \
    python3 \
    py3-pip \
    jq \
    aws-cli  # Instalando AWS CLI corretamente via APK

ENV TERRAFORM_VERSION=1.6.0
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

WORKDIR /app

COPY . /app

SHELL ["/bin/bash", "-c"]

CMD ["sh"]
