{ ... }:

{
  # Battery/power state over dbus, used by the quickshell battery widget
  # (home/quickshell/Battery.qml, BatteryMenu.qml) via Quickshell.Services.UPower.
  services.upower.enable = true;
}
