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

        autocomplete.blink-cmp = {
          enable = true;
      
          setupOpts = {
            keymap = {
              preset = "default";
      
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
          go= {
            enable = true;
            lsp.enable = true;
          };
          python = {
            enable = true;
            lsp.enable = true;
          };
        };

        viAlias = true;
        vimAlias = true;
  
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
  
        statusline.lualine.enable = true;
        telescope.enable = true;
        tabline.nvimBufferline.enable = true;
        ui.borders.plugins.which-key.enable = true;
      };
    };
  };
}
