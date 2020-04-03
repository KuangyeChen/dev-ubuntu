# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git wget curl vim htop zsh tmux \
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid 1000 field \
    && useradd -s /bin/zsh --uid 1000 --gid 1000 -m field \
    # Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo field ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/field \
    && chmod 0440 /etc/sudoers.d/field \
    # Install many things
    && sudo -H -u field sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && sudo -H -u field curl -L https://raw.githubusercontent.com//KuangyeChen/miscellaneous/master/dotfiles/container_zshrc > /home/field/.zshrc \
    && sudo -H -u field git clone https://github.com/zsh-users/zsh-autosuggestions /home/field/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && sudo -H -u field git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/field/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && sudo -H -u field git clone https://github.com/KuangyeChen/zsh-rm2trash /home/field/.oh-my-zsh/custom/plugins/zsh-rm2trash \
    && sudo -H -u field git clone https://github.com/paulirish/git-open.git /home/field/.oh-my-zsh/custom/plugins/git-open \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog