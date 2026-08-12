{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMonoNF-Regular";
    };
    settings = {
      enable_audio_bell = "no";
      cursor_shape = "beam";
      confirm_os_window_close = "0";
      cursor_trail = "1";
      cursor_trail_decay = "0.1 0.25";
    };
  };
}
