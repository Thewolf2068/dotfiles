{ ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        settings = {
          main = {
            capslock = "esc"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
	    esc = "capslock";
          };
        };
      };
    };
  };
}
