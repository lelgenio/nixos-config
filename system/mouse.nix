{
  # Allow configuring Logitech Peripherals
  services.ratbagd.enable = true;

  # Sway does not undersand high resolution scroll wheels
  # I don't need this, so I disable it
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 X PLUS]
    MatchUdevType=mouse
    MatchBus=usb
    MatchVendor=0x046D
    MatchProduct=0x4099
    AttrEventCode=-REL_WHEEL_HI_RES
  '';
}
