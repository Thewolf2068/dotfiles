{ lib, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {

        # ──────────────────────────────────────────────
        # Core editor behavior
        # ──────────────────────────────────────────────
        viAlias = true;
        vimAlias = true;

        globals = {
          mapleader = " ";
        };

        options = {
          tabstop = 2;       # Spaces a <Tab> counts for
          shiftwidth = 2;    # Spaces per auto-indent step
          softtabstop = 2;   # Spaces a <Tab> counts for while editing
          expandtab = true;  # Convert tabs to spaces
        };

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          registers = "unnamedplus";
        };

        # ──────────────────────────────────────────────
        # Appearance
        # ──────────────────────────────────────────────
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        statusline.lualine.enable = true;
        tabline.nvimBufferline.enable = true;

        ui.borders.plugins.which-key.enable = true;

        # ──────────────────────────────────────────────
        # File navigation & search
        # ──────────────────────────────────────────────
        telescope.enable = true;

        # Oil: edit the filesystem like a buffer
        utility.oil-nvim = {
          enable = true;
          gitStatus.enable = true;
          setupOpts = {
            # Keys below are only active inside Oil buffers
            keymaps = {
              # Opens ":!<path under cursor>", type "stat " at the start
              "!" = lib.generators.mkLuaInline ''
                { "actions.open_cmdline", opts = { shell = true }, desc = "Run shell cmd on entry" }
              '';

              # One-key stat of the entry under the cursor
              "gS" = lib.generators.mkLuaInline ''
                {
                  desc = "stat entry",
                  callback = function()
                    local oil = require("oil")
                    local entry = oil.get_cursor_entry()
                    local dir = oil.get_current_dir()
                    if not entry or not dir then return end
                    vim.notify(vim.fn.system({ "stat", dir .. entry.name }))
                  end,
                }
              '';
            };
          };
        };

        # Neo-tree: sidebar tree, closes itself after opening a file
        filetree = {
          neo-tree = {
            enable = true;
            setupOpts.event_handlers = [
              {
                event = "file_open_requested";
                handler = lib.generators.mkLuaInline ''
                  function()
                    vim.cmd("Neotree close")
                  end
                '';
              }
            ];
          };
          nvimTree.setupOpts.disable_netrw = true;
        };

        # ──────────────────────────────────────────────
        # Git
        # ──────────────────────────────────────────────
        git.gitsigns.enable = true;

        # ──────────────────────────────────────────────
        # Editing helpers
        # ──────────────────────────────────────────────
        utility.multicursors.enable = true;

        # ──────────────────────────────────────────────
        # Completion
        # ──────────────────────────────────────────────
        autocomplete.blink-cmp = {
          enable = true;
          setupOpts = {
            keymap = {
              "<C-j>" = [ "select_next" "fallback" ];
              "<C-k>" = [ "select_prev" "fallback" ];
              "<C-l>" = [ "accept" "fallback" ];
            };

            sources.default = [ "lsp" "path" "snippets" "buffer" ];

            completion = {
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 300;
              };
              ghost_text.enabled = true;
            };

            signature.enabled = true;
          };
        };


        autopairs.nvim-autopairs.enable = true;

        # ──────────────────────────────────────────────
        # LSP & languages
        # ──────────────────────────────────────────────
        lsp.enable = true;

        languages = {
          nix    = { enable = true; lsp.enable = true; };
          bash   = { enable = true; lsp.enable = true; };
          go     = { enable = true; lsp.enable = true; };
          python = { enable = true; lsp.enable = true; };
          java   = { enable = true; lsp.enable = true; };
        };

        # ──────────────────────────────────────────────
        # Global keybinds (normal mode)
        # ──────────────────────────────────────────────
        maps.normal = {
          # Buffers
          "<Tab>" = {
            action = ":BufferLineCycleNext<CR>";
            silent = true;
            desc = "Next Buffer";
          };
          "<S-Tab>" = {
            action = ":BufferLineCyclePrev<CR>";
            silent = true;
            desc = "Prev Buffer";
          };

          # File navigation
          "<leader>t" = {
            action = ":Telescope find_files<CR>";
            silent = true;
            desc = "Open Telescope";
          };
          "<leader>nt" = {
            action = ":Neotree toggle<CR>";
            silent = true;
            desc = "Toggle Neotree";
          };
          "<leader>o" = {
            action = ":Oil<CR>";
            silent = true;
            desc = "Open Oil";
          };
        };
      };
    };
  };
}
