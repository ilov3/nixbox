# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_2;
  nix.settings.experimental-features = [ "nix-command" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.loader.systemd-boot.configurationLimit = 5;
#  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilov3 = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
     openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDU2fBq4fY54yvRRLBpEECfhKQ/sc9Pv0V6T01xGxVrq3NCDwoOyE2bNAKCMgVKoLfNICuOEUEENFpAFVacdI6hZlkqYBVsQ0OziIhxJb1vWoovjczcAXQjWgftYfTfKdTtIz9KpCFCa5FRjvuy0uAGSM79BcAMk2BeX9GnULavI/2b4n6sIB5lFzSEr/rOnbawpEKYKEzTeZvGdeKmQ96j8aum8FJeObOOp040Ux8G+uXi5x4tHYvDbTprodZcJmBTS1d29ZskBGkL3/k64EfjcQuTU5zBP6ebK+6oM/l77ZuqmwUJr7VE8L/Nq8OEzjGdF78fmlajtbkjW1fKODNnT2xR8WJN1rlGx/DN2khg695R9yqh0sbZ/waS89CQ8xFpI33eMjqInqNJkNlS85/XFcxcKKA4umOynt/j+AIEnGEfpoo+9BB166MCyhKyDxtjGOJLPRZnkOCI9QcbobJdVh0EVOO9xyhDsThNRuxFvHkSyQxURST3BXvTkMxqqdAyDEsnp1PzPmuCauxnbr6kuZKSa7yIaI7EUJ3VEWGh+CHiJf7b/Z8f2bh2MscGP05Z3SdU6pcY7BDsboFer+8aJUS0VF6DgcZlApYTEJwzydL1ECpnWZPFD+eVmqrOav4Cm0tDtdPBFlIGUlpgqkMhZFsRnAsd9nxg0h/Pg6Tu8w== ilov3@linuxbro"];
     shell = pkgs.zsh;
     packages = with pkgs; [
       wget
       bat
       git
       fzf
       neofetch
       htop
       minikube
       kubectl
       kubernetes-helm
       k9s
       tmux
       zsh
       python37Full
       python310Full
       python38Full
       pipenv
       direnv
       awscli2
       python310Packages.python-dotenv
       docker
       cloud-utils
       gh
       nixos-generators
       nix-index

       gcc
       cmake
       binutils
       ncurses
       xorg.libX11
       xorg.libXext
       xorg.libXrender
       xorg.libICE
       xorg.libSM
       glib
     ];
   };
  security.sudo.wheelNeedsPassword = false;
  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch";
    reboot = "sudo reboot";
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
'';
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  system.stateVersion = "22.11"; # Did you read the comment?
  virtualisation.docker.enable = true;
}

