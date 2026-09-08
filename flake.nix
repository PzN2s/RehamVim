{

  description = "RehamVim - Isolated Neovim Configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  outputs = { self, nixpkgs }:

    let

      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      configFiles = pkgs.stdenv.mkDerivation {
        name = "rehamvim-config";
        src = ./.;
        installPhase = ''
          mkdir -p $out/rehamvim
          cp -r init.lua lua colors lazy-lock.json lazyvim.json stylua.toml $out/rehamvim/
        '';
      };

      extraPackages = with pkgs; [

        ripgrep
        fd
        lazygit
        gh
        gcc
        git
        go
        rustup
        nodejs
        python3
        icu

        lua-language-server
        nil

        stylua

      ];

    in {

      packages.${system}.default = pkgs.writeShellApplication {

        name = "rehamvim";

        runtimeInputs = [ pkgs.neovim ] ++ extraPackages;

        text = ''
          export NVIM_APPNAME="rehamvim"
          export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share/rehamvim"
export XDG_STATE_HOME="$HOME/.local/state/rehamvim"
          export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

          if [ ! -f "$HOME/.config/rehamvim/init.lua" ]; then
            echo "Initializing RehamVim config in $HOME/.config/rehamvim..."
            mkdir -p "$HOME/.config/rehamvim"
            cp -rf ${configFiles}/rehamvim/. "$HOME/.config/rehamvim/"
            chmod -R u+w "$HOME/.config/rehamvim"
          fi

          exec nvim "$@"
        '';

      };

    };

}

