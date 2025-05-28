{ lib, config, pkgs, ... }:

let
  nvimExists = builtins.pathExists "${config.xdg.configHome}/nvim";
  mozcExists = builtins.pathExists "${config.xdg.configHome}/mozc";
  xfce4Exists = builtins.pathExists "${config.xdg.configHome}/xfce4";
  copyqExists = builtins.pathExists "${config.xdg.configHome}/copyq";
  fishExists = builtins.pathExists "${config.xdg.configHome}/fish";
in
{
  # xdg.configFile.nvim = {
  #   source = ./nvim;
  #   target = "nvim";
  #   recursive = true;
  #   enable = true;
  # };
  # home.activation.xfce4 = lib.mkAfter ''
  #   rm -rf $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
  #   ln -sfT $HOME/nixos-config/desktop/home/xfce-perchannel-xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
  # '';

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "asdf";
  home.homeDirectory = "/home/asdf";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/asdf/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.

  programs = {
    home-manager.enable = true;
  };

  services.copyq.enable = true;


  xdg.configFile = {
    nvim = lib.mkIf (!nvimExists) {
      source = ./dots/nvim;
      target = "nvim";
      recursive = true;
      enable = true;
      force = true;
    };
    mozc = lib.mkIf (!mozcExists) {
      source = ./dots/mozc;
      target = "mozc";
      recursive = true;
      enable = true;
      force = true;
    };
    xfce4 = lib.mkIf (!xfce4Exists) {
      source = ./dots/xfce4;
      target = "xfce4";
      recursive = true;
      enable = true;
      force = true;
    };
    copyq = lib.mkIf (!copyqExists) {
      source = ./dots/copyq;
      target = "copyq";
      recursive = true;
      enable = true;
      force = true;
    };
    fish = lib.mkIf (!fishExists) {
      source = ./dots/fish;
      target = "fish";
      recursive = true;
      enable = true;
      force = true;
    };
  };

  xfconf.settings = {
    xfce4-desktop = {
      "backdrop/screen0/monitorHDMI-1/workspace0/last-image" =
        "${config.xdg.configHome}/xfce4/xfconf/xfce-perchannel-xml/0f6oxa9y9jlb1.png";
    };
  };

  xdg.desktopEntries = {
    nvim = {
      name = "neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %f";
      terminal = true;
      type = "Application";
      settings = {
        Keywords = "Text;editor";
      };
      icon="nvim";
      categories = [ "Utility" "TextEditor" ];
      mimeType=["text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
    };
  };

  # Add a new remote. Keep the default one (flathub)
  # services.flatpak.remotes = lib.mkOptionDefault [{
  #   name = "flathub-beta";
  #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  # }];
  # services.flatpak.update.auto.enable = false;
  # services.flatpak.uninstallUnmanaged = false;
  #
  # # Add here the flatpaks you want to install
  # services.flatpak.packages = [
  #   #{ appId = "com.brave.Browser"; origin = "flathub"; }
  #   "com.usebottles.bottles"
  #   "com.github.tchx84.Flatseal"
  #   "net.lutris.Lutris"
  #   "org.winehq.Wine"
  #   #"im.riot.Riot"
  # ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
