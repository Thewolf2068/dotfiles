{ pkgs, ... }:

let
  # The summon script adapted for MangoWM
  workspaceManager = pkgs.writeShellApplication {
    name = "workspace-manager";
    runtimeInputs = [ pkgs.jq ]; # mmsg is assumed to be in your system $PATH via your WM package
    text = ''
      TAG_NUM=$1

      # 1. Convert human-readable tag (1-9) to a bitmask
      TARGET_MASK=$(( 1 << (TAG_NUM - 1) ))

      # 2. Determine the currently focused monitor
      CURRENT_MON=$(mmsg get focusing-client | jq -r '.monitor // empty')

      # Fallback to cursor position if no client is focused
      if [[ -z "$CURRENT_MON" || "$CURRENT_MON" == "null" ]]; then
          CURRENT_MON=$(mmsg get cursorpos | jq -r '.monitor')
      fi

      # 3. Pull clients from other monitors
      mmsg get all-clients | jq -c ".[] | select(.monitor != \"$CURRENT_MON\")" | while read -r client; do
          CLIENT_TAGS=$(echo "$client" | jq -r '.tags')
          CLIENT_ID=$(echo "$client" | jq -r '.id')
          
          # Check if the window belongs to our target tag
          if (( CLIENT_TAGS & TARGET_MASK )); then
              mmsg dispatch tagcrossmon,$TARGET_MASK,$CURRENT_MON client,$CLIENT_ID
          fi
      done

      # 4. Switch the current monitor's view to the target tag
      mmsg dispatch viewcrossmon,$TARGET_MASK,$CURRENT_MON
    '';
  };

  wmScript = "${workspaceManager}/bin/workspace-manager";
in
{
  xdg.configFile."mango/config.conf".text = ''
    # Layout settings
    tagrule=id:1,layout_name:scroller
    tagrule=id:2,layout_name:scroller
    tagrule=id:3,layout_name:scroller
    tagrule=id:4,layout_name:dwindle
    tagrule=id:5,layout_name:dwindle
    tagrule=id:6,layout_name:dwindle
    tagrule=id:7,layout_name:scroller
    tagrule=id:8,layout_name:scroller
    tagrule=id:9,layout_name:dwindle

    # Monitors
    monitorrule=name:^HEADLESS-.*$,width:2560,height:1440,refresh:144,x:1920,y:0,scale:1,rr:0,vrr:0
    monitorrule=name:eDP-1,width:1920,height:1200,refresh:60,scale:1,vrr:1

    # =============================================================================
    # Visuals: Transparency, Blur & Animations
    # =============================================================================
    border_radius=11
    focused_opacity=0.9
    unfocused_opacity=0.85
    blur=1
    blur_optimized=1
    blur_params_radius=2
    blur_params_num_passes=2
    shadows=1
    layer_shadows=1
    borderpx=1

    # =============================================================================
    # Startup Applications
    # =============================================================================
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=systemctl --user start mango-session.target
    exec-once=noctalia msg wallpaper set ${./images/wallpapers/mifulu/5.png}
    exec-once=zen-beta
    exec-once=spotify
    exec-once=nm-applet

    # =============================================================================
    # Hotarea config
    # =============================================================================
    enable_hotarea=1
    hotarea_corner=0

    # =============================================================================
    # Base Keybindings (Default Mode)
    # =============================================================================

    # Mouse Keybindings
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresizea

    keymode=default
    bind=SUPER,Q,spawn,kitty
    bind=SUPER,D,spawn,noctalia msg panel-toggle launcher
    bind=SUPER,C,killclient
    bind=SUPER,F,togglemaximizescreen
    bind=SUPER+SHIFT,F,togglefullscreen
    bind=SUPER,T,togglefloating
    bind=SUPER,N,spawn,noctalia msg panel-toggle control-center notifications
    bind=SUPER+SHIFT,R,reload_config
    bind=SUPER,V,spawn,noctalia msg panel-toggle clipboard

    # Vim Focus Navigation
    bind=SUPER,H,focusdir,left
    bind=SUPER,J,focusdir,down
    bind=SUPER,K,focusdir,up
    bind=SUPER,L,focusdir,right

    # Vim Window Swapping
    bind=SUPER+SHIFT,H,exchange_client,left
    bind=SUPER+SHIFT,J,exchange_client,down
    bind=SUPER+SHIFT,K,exchange_client,up
    bind=SUPER+SHIFT,L,exchange_client,right

    # Media Keys & Hardware Controls via Noctalia
    bind=NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up
    bind=NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down
    bind=NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up
    bind=NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down

    # Window Resizing
    bind=SUPER,code:20,resizewin,-50,0
    bind=SUPER,code:21,resizewin,+50,0

    # Back and forth
    view_current_to_back=1 
    bind=SUPER,code:23,view,1,0

    # =============================================================================
    # Window Rules (Auto-Assigning Apps to Tags via 'tags:')
    # =============================================================================
    windowrule=tags:4,focused_opacity:0.8,focused_opacity:0.75,appid:zen-beta
    windowrule=tags:5,appid:Spotify
    windowrule=tags:6,appid:signal
    windowrule=tags:6,appid:discord
    windowrule=tags:7,appid:kitty
    windowrule=tags:8,appid:steam
    windowrule=tags:8,appid:gamescope,isfullscreen:1
    windowrule=tags:8,appid:org.prismlauncher.PrismLauncher
    windowrule=tags:8,appid:io.github.Faugus.faugus-launcher
    windowrule=tags:8,appid:heroic

    windowrule=isfloating:1,appid:blueman-manager
    windowrule=isfloating:1,appid:nm-connection-editor
    windowrule=isfloating:1,appid:org.pulseaudio.pavucontrol

    # =============================================================================
    # Submap: "Summon" Mode
    # =============================================================================
    bind=SUPER,Space,setkeymode,summon
    keymode=summon
    bind=NONE,Escape,setkeymode,default
    bind=NONE,Return,setkeymode,default
    
    # Tag Jump Commands (Summons windows from other monitors to current + exits submap)
    bind=NONE,1,spawn_shell,${wmScript} 1 && mmsg dispatch setkeymode,default
    bind=NONE,2,spawn_shell,${wmScript} 2 && mmsg dispatch setkeymode,default
    bind=NONE,3,spawn_shell,${wmScript} 3 && mmsg dispatch setkeymode,default
    bind=NONE,b,spawn_shell,${wmScript} 4 && mmsg dispatch setkeymode,default
    bind=NONE,s,spawn_shell,${wmScript} 5 && mmsg dispatch setkeymode,default
    bind=NONE,d,spawn_shell,${wmScript} 6 && mmsg dispatch setkeymode,default
    bind=NONE,k,spawn_shell,${wmScript} 7 && mmsg dispatch setkeymode,default
    bind=NONE,g,spawn_shell,${wmScript} 8 && mmsg dispatch setkeymode,default
    
    # Move Focused Window to Tag & Reset Mode
    bind=SHIFT,1,spawn_shell,mmsg dispatch tag,1 && mmsg dispatch setkeymode,default
    bind=SHIFT,2,spawn_shell,mmsg dispatch tag,2 && mmsg dispatch setkeymode,default
    bind=SHIFT,3,spawn_shell,mmsg dispatch tag,3 && mmsg dispatch setkeymode,default
    bind=SHIFT,B,spawn_shell,mmsg dispatch tag,4 && mmsg dispatch setkeymode,default
    bind=SHIFT,S,spawn_shell,mmsg dispatch tag,5 && mmsg dispatch setkeymode,default
    bind=SHIFT,D,spawn_shell,mmsg dispatch tag,6 && mmsg dispatch setkeymode,default
    bind=SHIFT,K,spawn_shell,mmsg dispatch tag,7 && mmsg dispatch setkeymode,default
    bind=SHIFT,G,spawn_shell,mmsg dispatch tag,8 && mmsg dispatch setkeymode,default
    keymode=default
  '';

  systemd.user.targets.mango-session = {
    Unit = {
      Description = "mango compositor session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}
