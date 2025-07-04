FROM docker.io/kasmweb/ubuntu-noble-desktop:%VER%-rolling-weekly
ARG TARGETARCH

USER root

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt update && apt install ca-certificates curl gnupg -y
RUN curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg && echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list
RUN apt update && apt install -y sudo dbus dbus-broker dnsutils iputils-ping jq wget build-essential python3 python3-pip jq wireguard wireguard-tools resolvconf jq libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin netbird
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


WORKDIR /tmp
# https://hub.docker.com/r/rustlang/rust/dockerfile
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    USER=root \
    PATH=/usr/local/cargo/bin:$PATH

# install rust
RUN set -eux; \
    \
    url="https://sh.rustup.rs"; \
    wget "$url" -O rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# install 1password
RUN if [ "$TARGETARCH" = "amd64" ]; then \ 
    wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb && sudo apt install ./1password-latest.deb -y; \
    fi

RUN sed -i '/cmd sysctl -q/d' $(which wg-quick)
USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s /bin/zsh kasm-user
WORKDIR /home/kasm-user
