{ lib, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options = {
          tabstop = 2;       # Number of spaces a <Tab> counts for
            shiftwidth = 2;    # Number of spaces used for each step of auto-indent
            softtabstop = 2;   # Number of spaces a <Tab> counts for while performing editing operations
            expandtab = true;  # Convert tabs to spaces
        };
        globals = {
          mapleader = " ";
        };

        # avante.nvim requires the mega.cmdparse Lua rock at runtime
        luaPackages = [
          "mega-cmdparse"
          "mega-logging"
        ];

        statusline.lualine.enable = true;
        telescope.enable = true;
        git.gitsigns.enable = true;
        tabline.nvimBufferline.enable = true;
        ui = {
          borders.plugins.which-key.enable = true;
          noice.enable = true;
        };


        assistant.avante-nvim = {
          enable = true;
          setupOpts = {
            behaviour.auto_suggestions = true;
            provider = "ollama-qwen";
            providers = {
              ollama-qwen = {
                __inherited_from = "ollama";
                endpoint = "http://127.0.0.1:11434";
                model = "qwen2.5-coder:7b";
                timeout = 3000;
                extra_request_body = {
                  options = {
                    temperature = 0.75;
                    num_ctx = 20480;
                    keep_alive = "5m";
                  };
                };
              };
            };
          };
        }; 

        autocomplete.blink-cmp = {
          enable = true;

          setupOpts = {
            keymap = {
              "<C-j>" = [
                "select_next"
                  "fallback"
              ];

              "<C-k>" = [
                "select_prev"
                  "fallback"
              ];
              "<C-l>" = [
                "accept"
                  "fallback"
              ];
            };

            sources.default = [
              "lsp"
                "path"
                "snippets"
                "buffer"
            ];

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

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          registers = "unnamedplus";
        };

        filetree = {
          neo-tree = {
            enable = true;
            setupOpts = {
              event_handlers = [
              {
                event = "file_open_requested";
# Use mkLuaInline instead of handler.__raw
                handler = lib.generators.mkLuaInline ''
                  function()
                  vim.cmd("Neotree close")
                  end
                  '';
              }
              ];
            };
          };
          nvimTree.setupOpts.disable_netrw = true;
        };

        maps.normal = {
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
          "<leader>x" = { 
            action = ":bdelete<CR>";
            silent = true;
            desc = "Close current Buffer";
          };
        };

        lsp.enable = true;
        languages = {

          nix = {
            enable = true;
            lsp.enable = true;
          };
          bash = {
            enable = true;
            lsp.enable = true;
          };
          go= {
            enable = true;
            lsp.enable = true;
          };
          python = {
            enable = true;
            lsp.enable = true;
          };
          java = {
            enable = true;
            lsp.enable = true;
          };
        };

        viAlias = true;
        vimAlias = true;
        luaConfigRC.avante-cpath = ''
          local f = vim.api.nvim_get_runtime_file("pack/*/opt/avante-nvim/build/avante_templates.so", false)[1]
          if f then
            package.cpath = package.cpath .. ";" .. vim.fn.fnamemodify(f, ":h") .. "/?.so"
          end
        '';
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
      };
    };
  };
}
