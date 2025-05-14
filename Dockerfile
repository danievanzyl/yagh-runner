FROM ubuntu:latest

ARG RUNNER_VERSION="2.323.0"
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt update -y \
  && apt upgrade -y \
  && useradd -m docker \
  && apt install -y --no-install-recommends \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    docker-buildx \
    docker-compose \
    jq \
    sudo

# Set up the actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
  && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && chown -R docker /home/docker && /home/docker/actions-runner/bin/installdependencies.sh

# Copy the start script and make it executable
COPY scripts/entrypoint.sh /entrypoint.sh

# Switch to docker user
USER docker

# Define the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
