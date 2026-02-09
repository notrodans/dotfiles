FROM lopsided/archlinux:latest

ARG TARGETPLATFORM

# Disable pacman sandboxing (Landlock) and refresh mirrors for better reliability
RUN sed -i 's/^#DisableSandbox/DisableSandbox/' /etc/pacman.conf && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        curl -s "https://archlinux.org/mirrorlist/?country=all&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' | head -n 20 > /etc/pacman.d/mirrorlist; \
    fi && \
    pacman-key --init && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        pacman-key --populate archlinux; \
    else \
        pacman-key --populate archlinuxarm; \
    fi && \
    (pacman -Sy --noconfirm archlinux-keyring || true)

# Pre-install rust and core tools to satisfy paru's build requirements and SDKMAN
RUN pacman -Syu --noconfirm --needed \
    base-devel \
    pciutils \
    git \
    curl \
    sudo \
    chezmoi \
    zsh \
    rust \
    zip \
    unzip

RUN useradd -m -G wheel tester && \
    echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER tester
WORKDIR /home/tester

RUN git clone https://aur.archlinux.org/paru.git /tmp/paru && \
    cd /tmp/paru && \
    makepkg -si --noconfirm && \
    rm -rf /tmp/paru

# Set up chezmoi source directory
RUN mkdir -p /home/tester/.local/share/chezmoi

# Copy dotfiles
COPY --chown=tester:tester . /home/tester/.local/share/chezmoi

# Setup entrypoint
RUN chmod +x /home/tester/.local/share/chezmoi/tests/entrypoint.sh
ENTRYPOINT ["/home/tester/.local/share/chezmoi/tests/entrypoint.sh"]

# Default to interactive shell
CMD ["/bin/zsh"]
