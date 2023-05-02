{ config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> {};
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_2;
  nix.settings.experimental-features = [ "nix-command" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.configurationLimit = 5;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Istanbul";

  users.users.ilov3 = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
     openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDU2fBq4fY54yvRRLBpEECfhKQ/sc9Pv0V6T01xGxVrq3NCDwoOyE2bNAKCMgVKoLfNICuOEUEENFpAFVacdI6hZlkqYBVsQ0OziIhxJb1vWoovjczcAXQjWgftYfTfKdTtIz9KpCFCa5FRjvuy0uAGSM79BcAMk2BeX9GnULavI/2b4n6sIB5lFzSEr/rOnbawpEKYKEzTeZvGdeKmQ96j8aum8FJeObOOp040Ux8G+uXi5x4tHYvDbTprodZcJmBTS1d29ZskBGkL3/k64EfjcQuTU5zBP6ebK+6oM/l77ZuqmwUJr7VE8L/Nq8OEzjGdF78fmlajtbkjW1fKODNnT2xR8WJN1rlGx/DN2khg695R9yqh0sbZ/waS89CQ8xFpI33eMjqInqNJkNlS85/XFcxcKKA4umOynt/j+AIEnGEfpoo+9BB166MCyhKyDxtjGOJLPRZnkOCI9QcbobJdVh0EVOO9xyhDsThNRuxFvHkSyQxURST3BXvTkMxqqdAyDEsnp1PzPmuCauxnbr6kuZKSa7yIaI7EUJ3VEWGh+CHiJf7b/Z8f2bh2MscGP05Z3SdU6pcY7BDsboFer+8aJUS0VF6DgcZlApYTEJwzydL1ECpnWZPFD+eVmqrOav4Cm0tDtdPBFlIGUlpgqkMhZFsRnAsd9nxg0h/Pg6Tu8w== ilov3@linuxbro"];
     shell = pkgs.zsh;
     packages = [
       pkgs.duf
       pkgs.wget
       pkgs.bat
       pkgs.git
       pkgs.fzf
       pkgs.neofetch
       pkgs.htop
       unstable.minikube
       pkgs.kubectl
       pkgs.kubernetes-helm
       unstable.k9s
       unstable.tmux
       unstable.zsh
       pkgs.python37Full
       pkgs.python310Full
       pkgs.python38Full
       unstable.pipenv
       pkgs.direnv
       pkgs.awscli2
       pkgs.python310Packages.python-dotenv
       unstable.docker
       unstable.dive
       pkgs.cloud-utils
       pkgs.gh
       pkgs.nixos-generators
       pkgs.nix-index
       pkgs.glances
       pkgs.ncdu

       pkgs.gcc
       pkgs.cmake
       pkgs.binutils
       pkgs.ncurses
       pkgs.xorg.libX11
       pkgs.xorg.libXext
       pkgs.xorg.libXrender
       pkgs.xorg.libICE
       pkgs.xorg.libSM
       pkgs.glib
     ];
   };
  security.sudo.wheelNeedsPassword = false;
  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch";
    reboot = "sudo reboot";
    po = "sudo poweroff";
    mks = "minikube start --driver=docker --memory 6g --cpus 4 --disable-metrics --mount --mount-string=/home/ilov3:/home/ilov3";
    mindocker = "eval $(minikube -p minikube docker-env)";
    resenvdocker = "eval $(minikube -p minikube docker-env -u)";
    saddresources = "pipenv run pep_data server add-default-resources";
    sstart = "pipenv run pep_data server start";
    sstop = "pipenv run pep_data server stop";
  };

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableGlobalCompInit = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.plugins = [ "git" "aws" "direnv" "fzf" ];
  programs.zsh.ohMyZsh.theme = "afowler";

  programs.command-not-found.enable = false;
   programs.zsh.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
   '';
  
  programs.tmux.enable = true;
  programs.tmux.baseIndex = 1;
  programs.tmux.clock24 = true;
  programs.tmux.plugins = [
    pkgs.tmuxPlugins.resurrect
    pkgs.tmuxPlugins.continuum
    pkgs.tmuxPlugins.sensible
    pkgs.tmuxPlugins.dracula
  ];
  programs.tmux.extraConfig = ''
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
set-option -g history-limit 3000

bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

bind r source-file ~/.tmux.conf

bind -n M-j select-pane -L
bind -n M-k select-pane -R
bind -n M-h select-pane -U
bind -n M-l select-pane -D

bind -n M-0 select-window -t 0
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5
bind -n M-6 select-window -t 6
bind -n M-7 select-window -t 7
bind -n M-8 select-window -t 8
bind -n M-9 select-window -t 9

set -g mouse on
set -g default-terminal "screen-256color"

set -g @dracula-plugins "cpu-usage ram-usage"
set -g @dracula-cpu-display-load true
set -g @dracula-show-flags true
set -g @dracula-refresh-rate 2

run-shell ${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/dracula/dracula.tmux
'';
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  services.qemuGuest.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
  virtualisation.docker.enable = true;
  networking.firewall.enable = false;
}

