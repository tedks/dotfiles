{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tedks";
  home.homeDirectory = "/home/tedks";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Development tools
    git
    ripgrep
    fd
    jq
    htop

    # Add more packages here as needed
  ];

  # Home Manager can manage your dotfiles. The home.file option allows you to
  # symlink files into your home directory.
  home.file = {
    ".emacs".source = ./.emacs;
    ".emacs.d".source = ./.emacs.d;
    ".xsession".source = ./.xsession;
  };

  # Home Manager can also manage your shell environment variables through
  # home.sessionVariables.
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # XDG config files
  xdg.configFile = {
    "i3".source = ./.config/i3;
    "i3status".source = ./.config/i3status;
    "mpv".source = ./.config/mpv;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git configuration (customize as needed)
  programs.git = {
    enable = true;
    userName = "tedks";
    # userEmail = "your-email@example.com";  # Uncomment and set your email
  };
}
