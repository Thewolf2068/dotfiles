{ ... }:
{
  xdg.configFile."mango/config.conf".text = ''
    # Layout settings
    default_layout=dwindle

    tagrule=id:1,layout_name:scroller
    tagrule=id:2,layout_name:scroller
    tagrule=id:3,layout_name:scroller
    tagrule=id:4,layout_name:dwindle
    tagrule=id:5,layout_name:dwindle
    tagrule=id:6,layout_name:dwindle
    tagrule=id:7,layout_name:dwindle
    tagrule=id:8,layout_name:dwindle
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
    exec-once=swaybg -m fill -i ${./images/wallpapers/mifulu/5.png}
    exec-once=swayosd-server
    exec-once=swaync
    exec-once=zen-beta
    exec-once=spotify

    # =============================================================================
    # Base Keybindings (Default Mode)
    # =============================================================================

    # Mous Keybindings
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresizea


    keymode=default
    bind=SUPER,Q,spawn,kitty
    bind=SUPER,D,spawn,fuzzel
    bind=SUPER,C,killclient
    bind=SUPER,F,togglefullscreen
    bind=SUPER,T,togglefloating
    bind=SUPER,N,spawn,swaync-client -t
    bind=SUPER+SHIFT,R,reload_config
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
    # Media Keys
    bind=NONE,XF86AudioRaiseVolume,spawn,swayosd-client --output-volume raise --max-volume 100
    bind=NONE,XF86AudioLowerVolume,spawn,swayosd-client --output-volume lower --max-volume 100
    bind=NONE,XF86MonBrightnessUp,spawn,swayosd-client --brightness +5
    bind=NONE,XF86MonBrightnessDown,spawn,swayosd-client --brightness -5
    # =============================================================================
    # Window Rules (Auto-Assigning Apps to Tags via 'tags:')
    # =============================================================================
    windowrule=tags:4,appid:zen-beta
    windowrule=tags:5,appid:Spotify
    windowrule=tags:6,appid:signal
    windowrule=tags:6,appid:vesktop
    windowrule=tags:7,appid:kitty
    windowrule=tags:8,appid:steam
    windowrule=tags:8,appid:gamescope,isfullscreen:1

    windowrule=isfloating:1,appid:blueman-manager
    windowrule=isfloating:1,appid:nm-connection-editor
    # =============================================================================
    # Submap: "Summon" Mode
    # =============================================================================
    bind=SUPER,Space,setkeymode,summon
    keymode=summon
    bind=NONE,Escape,setkeymode,default
    bind=NONE,Return,setkeymode,default
    # Tag Jump Commands (view tag + exit submap in one shot via mmsg)
    bind=NONE,1,spawn_shell,mmsg dispatch view,1 && mmsg dispatch setkeymode,default
    bind=NONE,2,spawn_shell,mmsg dispatch view,2 && mmsg dispatch setkeymode,default
    bind=NONE,3,spawn_shell,mmsg dispatch view,3 && mmsg dispatch setkeymode,default
    bind=NONE,b,spawn_shell,mmsg dispatch view,4 && mmsg dispatch setkeymode,default
    bind=NONE,s,spawn_shell,mmsg dispatch view,5 && mmsg dispatch setkeymode,default
    bind=NONE,d,spawn_shell,mmsg dispatch view,6 && mmsg dispatch setkeymode,default
    bind=NONE,k,spawn_shell,mmsg dispatch view,7 && mmsg dispatch setkeymode,default
    bind=NONE,g,spawn_shell,mmsg dispatch view,8 && mmsg dispatch setkeymode,default
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



