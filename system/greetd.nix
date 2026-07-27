{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # --time: show clock, --greeting: custom banner, --remember(-session):
        # pre-fill last username/session, --asterisks: mask password input.
        command = "${pkgs.tuigreet}/bin/tuigreet --time --greeting 'Welcome to nixos' --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };
}
