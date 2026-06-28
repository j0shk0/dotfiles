# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # First things first...
  programs.nano.enable = false;
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nixpkgs.config.allowUnfree = true;

  # Enable usage of flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Audio: PipeWire + WirePlumber
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # start ssh-agent
  programs.ssh.startAgent = true;

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Lightdm
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
      cursorTheme = {
        name = "Adwaita";
        size = 32;
      };
    };
  };

  # system wide packages.
  environment.systemPackages = with pkgs; [ 
      vim-full
      zip
      unzip
      git 
      rsync
      wget
      imagemagick
      wl-clipboard
      libnotify
      dunst
      fuzzel
      fastfetch
      swayimg
      slurp
      texliveFull
      perf
      valgrind
      exfatprogs
      i3status
      swaybg
      python3
      direnv
      nix-direnv
      brave
      # librewolf        # currently marked as insecure.
      obsidian
      signal-desktop
      discord
      spotify
      wireshark
      keepassxc
      cryptomator
      mullvad-vpn
      mullvad-browser
      tor-browser
      anki
      thunderbird
      filezilla
      solaar
      foot
      ranger
      pavucontrol
      veracrypt
      tipp10
      iamb
      jetbrains.clion
      jetbrains.idea
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.pycharm
      btop
    ];

  # TODO After startup:
  #   - Binaries for Factorio, TWS and Gateway.

  # Enable direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  # Udev rules for YubiKey (and other FIDO/U2F devices)
  hardware.gpgSmartcards.enable = true;  # optional, for GPG/PIV use
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Or, for a broader set of FIDO2/U2F tokens:
  services.pcscd.enable = true;

  # Mullvad
  services.mullvad-vpn.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swap
  swapDevices = [ { device = "/.swapfile"; } ];

  # Hostname
  networking.hostName = "sleipnir";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console.useXkbConfig = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export XKB_DEFAULT_LAYOUT=de
    '';
  };

  # Enable foot (foo terminal)
  programs.foot.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # enable Docker
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.j0shk0= {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # Of course:
  programs.firefox.enable = true;

  # protonmail-bridge
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  services.protonmail-bridge = { 
    enable = true;
    logLevel = "info";
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "32";
  };

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.j0shk0 = { config, pkgs, lib, ... }:

    let
      dots = ./dotfiles;
    in {

    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };

    programs.bash = {
      enable = true;
      initExtra = builtins.readFile "${dots}/.bashrc";
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };

    home.packages = [ pkgs.tmux ];

    home.stateVersion = "25.11";
    
    home.file = {
      ".gitconfig".source = "${dots}/.gitconfig";
      ".vimrc".source = "${dots}/.vimrc";
    };

    xdg.configFile = {
      "tmux/tmux.conf".source = "${dots}/.tmux.conf";
      "sway/config".source = "${dots}/config";
      "dunst/dunstrc".source = "${dots}/dunstrc";
      "foot/foot.ini".source = "${dots}/foot.ini";
      "i3status/config".source = "${dots}/i3status.conf";
      "starship.toml".source = "${dots}/starship.toml";
    };

  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

