FROM archlinux:latest

# Landlock sandboxing is unavailable in some container runtimes.
RUN sed -i 's/^#DisableSandbox/DisableSandbox/' /etc/pacman.conf && \
    pacman -Syu --noconfirm --needed \
      archlinux-keyring \
      base-devel \
      git \
      curl \
      sudo \
      chezmoi \
      lua \
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

RUN mkdir -p /home/tester/.local/share/chezmoi
COPY --chown=tester:tester . /home/tester/.local/share/chezmoi

RUN chmod +x /home/tester/.local/share/chezmoi/tests/entrypoint.sh
ENTRYPOINT ["/home/tester/.local/share/chezmoi/tests/entrypoint.sh"]
CMD ["/bin/zsh"]
