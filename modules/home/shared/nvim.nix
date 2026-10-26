{ lib, pkgs, ... }:

let
  # Helper: wrap a multicursor.nvim call as an nvf lua keymap.
  mc = call: desc: {
    action = "function() require('multicursor-nvim').${call} end";
    lua = true;
    silent = true;
    inherit desc;
  };

  # Keymaps shared between normal ("n") and visual ("x") mode.
  # Applied to maps.normal and maps.visualOnly below.
  mcKeys = {
    # Add or skip cursor above/below the main cursor
    "<up>"             = mc "lineAddCursor(-1)"  "MC: add cursor above";
    "<down>"           = mc "lineAddCursor(1)"   "MC: add cursor below"; 
    "<leader><up>"     = mc "lineSkipCursor(-1)" "MC: skip line above";
    "<leader><down>"   = mc "lineSkipCursor(1)"  "MC: skip line below";

    # Add or skip adding a new cursor by matching word/selection
    "<leader>n"        = mc "matchAddCursor(1)"  "MC: add next match";
    "<leader>s"        = mc "matchSkipCursor(1)" "MC: skip next match";
    "<leader>N"        = mc "matchAddCursor(-1)" "MC: add previous match";
    "<leader>S"        = mc "matchSkipCursor(-1)" "MC: skip previous match";

    # Disable and enable cursors
    "<c-q>"            = mc "toggleCursor()"     "MC: toggle cursor";
  };
in
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
        # multicursor.nvim (jake-stewart) replaces utility.multicursors
        extraPlugins.multicursor-nvim = {
          package = pkgs.vimPlugins.multicursor-nvim;
          setup = ''
            local mc = require("multicursor-nvim")
            mc.setup()

            -- Mappings in a keymap layer only apply when there are
            -- multiple cursors, so they can overlap with normal mappings.
            mc.addKeymapLayer(function(layerSet)
              -- Select a different cursor as the main one
              layerSet({"n", "x"}, "<left>", mc.prevCursor)
              layerSet({"n", "x"}, "<right>", mc.nextCursor)

              -- Delete the main cursor
              layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

              -- Enable and clear cursors using escape
              layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                  mc.enableCursors()
                else
                  mc.clearCursors()
                end
              end)
            end)

            -- Customize how cursors look
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
          '';
        };
        # ──────────────────────────────────────────────
        # Debugger
        # ──────────────────────────────────────────────

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

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
          clang = { enable = true; lsp.enable = true; };
        };

        # ──────────────────────────────────────────────
        # Global keybinds
        # ──────────────────────────────────────────────

        binds.whichKey.enable = true;
        # Visual mode ("x"): multicursor keys only
        maps.visualOnly = mcKeys;

        # Normal mode
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

          # Multicursor: add/remove cursors with control + left click
          "<c-leftmouse>" = {
            action = "require('multicursor-nvim').handleMouse";
            lua = true;
            desc = "MC: add/remove cursor (mouse)";
          };
          "<c-leftdrag>" = {
            action = "require('multicursor-nvim').handleMouseDrag";
            lua = true;
            desc = "MC: drag cursor (mouse)";
          };
          "<c-leftrelease>" = {
            action = "require('multicursor-nvim').handleMouseRelease";
            lua = true;
            desc = "MC: release cursor (mouse)";
          };
        } // mcKeys;
      };
    };
  };
}
