{ pkgs, config, lib, ... }:
#
# Default service module for this Flask app
#

let
  cfg = config.services.flask-app;
in
{
options.services.flask-app = with lib; {
  enable = mkEnableOption "Demo flask app";

  host = mkOption {
    type = types.str;
    description = "HTTP host to listen on.";
    default = "0.0.0.0";
  };

  port = mkOption {
    type = types.int;
    description = "HTTP port to listen on.";
    default = 5000;
  };

  package = mkOption {
    type = types.package;
    description = "The API server package to use.";
    default = pkgs.flask-app;
  };

  envFile = mkOption {
    type = types.str;
    description = "Path to the file containing environment variables and secrets.";
    example = "/srv/flask-app/env.txt";
  };
};

config.nixpkgs.overlays =
  [ (final: prev: { flask-app = prev.callPackage ../. {}; }) ];

config.services = lib.mkIf cfg.enable
{ uwsgi.enable = true;
  uwsgi.plugins = [ "python3" ];
  uwsgi.instance.type = "emperor";
  uwsgi.instance.vassals = {
      "flask-app" = {
        type = "normal";
        pythonPackages = self: with self; [ cfg.package ];
        http = "${cfg.host}:${builtins.toString cfg.port}";
        module = "flask_app.wsgi";
        env = [ "API_ENVFILE=${cfg.envFile}" ];
        plugin = "python3";
      };
  };
};
}
