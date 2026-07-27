{ ... }:

{
  # Battery/power state over dbus, used by the quickshell battery widget
  # (home/quickshell/Battery.qml, BatteryMenu.qml) via Quickshell.Services.UPower.
  services.upower.enable = true;

  # Power profile switching (eco/balanced/performance), driven from
  # BatteryMenu.qml via the powerprofilesctl CLI (Quickshell has no QML
  # binding for this service, so it's shelled out to over Quickshell.Io).
  services.power-profiles-daemon.enable = true;
}
