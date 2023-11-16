FROM docker.io/kasmweb/ubuntu-jammy-desktop:%VER%-rolling

USER root
RUN apt update && apt install -y sudo curl jq wget build-essential python3 python3-pip wireguard openresolv
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.0.18144.tar.gz
RUN sudo tar -xzf jetbrains-toolbox-2.1.0.18144.tar.gz -C /opt
RUN chmod +x /opt/jetbrains-toolbox && RUN /opt/jetbrains-toolbox

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

USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s /bin/zsh kasm-user
