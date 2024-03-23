{ pkgs, stdenv, python3Packages, ... }:

python3Packages.buildPythonPackage {
  name = "flask-app";
  pyproject = true;

  src = ./.;

  propagatedBuildInputs = with pkgs; with python3Packages;
  [ flask
    flask-cors
    setuptools
    cachetools
    python-dotenv
  ];
}
