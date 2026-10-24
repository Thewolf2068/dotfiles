{ pkgs, ... }:

let
  # ide              -> open/re-attach the session for the current dir
  # ide ~/foo        -> same for another dir
  # ide pick         -> fuzzy-pick any existing session
  # ide ls           -> list sessions
  # ide kill [name]  -> kill + delete a session (fzf if no name)
  ide = pkgs.writeShellApplication {
    name = "ide";
    runtimeInputs = [ pkgs.zellij pkgs.fzf pkgs.coreutils pkgs.gnugrep ];
    text = ''
      sessions() { zellij list-sessions --short --no-formatting 2>/dev/null || true; }
      pick()     { sessions | fzf --prompt="ide> " --height=40% --reverse --bind 'j:down,k:up,ctrl-j:preview-down,ctrl-k:preview-up'; }

      not_nested() {
        if [ -n "''${ZELLIJ:-}" ]; then
          echo "Already inside zellij - detach first (Alt+d)." >&2
          exit 1
        fi
      }

      case "''${1:-}" in
        ls)
          zellij list-sessions || true
          ;;
        pick)
          not_nested
          name=$(pick) || exit 0
          exec zellij attach "$name"
          ;;
        kill)
          name="''${2:-$(pick)}" || exit 0
          zellij delete-session --force "$name"
          ;;
        *)
          not_nested
          dir=$(realpath "''${1:-.}")
          base=''${dir##*/}
          hash=$(printf '%s' "$dir" | sha256sum | cut -c1-6)
          name="ide-''${base:-root}-$hash"
          existing=$(sessions)
          if grep -qxF -- "$name" <<<"$existing"; then
            exec zellij attach "$name"
          fi
          cd "$dir"
          exec zellij --session "$name" --new-session-with-layout ide
          ;;
      esac
    '';
  };
in
{
  home.packages = [ ide ];

  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # only start zellij manually, via `ide`

    settings = {
      show_startup_tips = false;
      mouse_hover_tips = false;               # hides the "Ctrl <MouseScroll>..." resize hint
      ui.pane_frames.rounded_corners = true;

      # Alt+d detaches (Alt+f already toggles floating panes by default)
      keybinds.shared_except = {
        _args = [ "locked" ];
        bind = {
          _args = [ "Alt d" ];
          Detach = { };
        };
      };
    };

    layouts.ide = {
      layout._children = [
        { pane.command = "nvim"; }
        {
          floating_panes.pane = {
            x = "10%";
            y = "10%";
            width = "80%";
            height = "80%";
          };
        }
      ];
    };
  };
}
