# I am just most used to it :)
FROM ubuntu

# Install curl & wget
RUN apt update
RUN apt install \
    curl \
    wget \
    python3 \
    git \
    build-essential \
    -y

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN helm version

# Configure helm with dapr repo
RUN helm repo add dapr https://daprio.azurecr.io/helm/v1/repo
RUN helm repo update

# Install dapr
RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
RUN dapr --version

# Install az
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az version

# Install go
RUN wget -q https://golang.org/dl/go1.14.7.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.14.7.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$PATH
ENV GOPATH=/workspaces/go
ENV PATH=$GOPATH/bin:$PATH

# Install go lint
# binary will be $(go env GOPATH)/bin/golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.30.0

# Install delve
RUN git clone https://github.com/go-delve/delve.git $GOPATH/src/github.com/go-delve/delve

RUN cd $GOPATH/src/github.com/go-delve/delve && make install

# Install Node.js (needed for vscode extensions)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs

# Install docker
RUN wget -q https://download.docker.com/linux/static/stable/x86_64/docker-19.03.12.tgz
RUN tar xzvf docker-19.03.12.tgz
RUN cp docker/* /usr/bin/

# Run in shell
CMD /bin/bash