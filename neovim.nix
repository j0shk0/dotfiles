{
  config,
  lib,
  pkgs,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "nixos-26.05";
    }
  );
in
{
  imports = [ nixvim.nixosModules.nixvim ];

  options.dotfiles.neovim.enable = lib.mkEnableOption "neovim module";

  config.programs.nixvim = lib.mkIf config.dotfiles.neovim.enable {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      background = "light";
      cursorline = true;
      number = true;
      expandtab = true;
      shiftwidth = 2;
      softtabstop = 2;
      showtabline = 2;
    };

    globals = {
      vimtex_quickfix_mode = 0;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "latte";
    };

    extraPlugins = with pkgs.vimPlugins; [
      ultisnips
    ];

    lsp.servers = {
      nil_ls = {
        enable = true;
        packageFallback = true;
      };
      lua_ls = {
        enable = true;
        packageFallback = true;
      };
      ts_ls = {
        enable = true;
        packageFallback = true;
      };
      rust_analyzer = {
        enable = true;
        packageFallback = true;
      };
      clangd = {
        enable = true;
        packageFallback = true;
        config.cmd = [
          "clangd"
          "--background-index"
        ];
      };
      pyright = {
        enable = true;
        packageFallback = true;
      };
      elixirls = {
        enable = true;
        packageFallback = true;
      };
      jdtls = {
        enable = true;
        packageFallback = true;
      };
    };

    extraFiles = {
      "UltiSnips/typst.snippets".source = ./dotfiles/typst.snippets;
    };

    extraPackagesAfter = [
      pkgs.cargo
      pkgs.rustc
    ];

    plugins = {
      nvim-autopairs.enable = true;
      typst-vim.enable = true;
      lsp-signature.enable = true;
      smear-cursor.enable = true;
      nvim-tree.enable = true;

      vimtex = {
        enable = true;
        texlivePackage = null; # use the one from system.
      };

      lualine = {
        enable = true;
        settings.tabline.lualine_a = [
          {
            __unkeyed-1 = "tabs";
            mode = 1;
            max_length.__raw = "vim.o.columns";
          }
        ];
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {

          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "ultisnips"; }
            { name = "buffer"; }
          ];

          mapping = {
            "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
            "<Tab>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";

            "<Down>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
            "<Up>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";

            "<Esc>" = "cmp.mapping.abort()";
            "<C-Space>" = "cmp.mapping.complete()";
            "<M-k>" = "cmp.mapping.scroll_docs(-4)";
            "<M-j>" = "cmp.mapping.scroll_docs(4)";
          };

          completion.completeopt = "menu,menuone,noinsert";
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            python = [ "black" ];
            rust = [ "rustfmt" ];
            elixir = [ "mix" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
            java = [ "google-java-format" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            json = [ "prettierd" ];
            yaml = [ "prettierd" ];
            markdown = [ "prettierd" ];
            sh = [ "shfmt" ];
            "*" = [ "trim_whitespace" ];
          };
        };
      };

      lspconfig.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          highlight.disable = [ "latex" ];
          indent.enable = true;
        };
      };
    };

    extraPackages = with pkgs; [
      rustfmt
      elixir
      clang-tools
      nixfmt
      black
      shfmt
      prettierd
      google-java-format
    ];

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<C-M-l>";
        action.__raw = ''
          function()
            require("conform").format({ async = true, lsp_format = "fallback" })
          end
        '';
        options.desc = "Format file / selection";
      }
      {
        mode = "n";
        key = "<M-1>";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file tree";
      }
    ];
  };
}
