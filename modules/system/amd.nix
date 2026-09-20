{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;


  # For stuff like overclocking
  services.lact.enable = true;
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
}
