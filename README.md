# Racewerk Device configurator

[Download the current software in Github releases](https://github.com/TobiasJacob/gcrdeviceconfigurator/releases)

This is the configuration Software for the Racewerk pedals. It is fully open source. Feel free to submit pull requests or fiddle with the presets.

![Demo](docs/Demo.png)

It works with the Racewerk Box:

![Demo](docs/GameController.png)

## Development

Contributions are always welcome. Please open an issue before submitting a pull-request to give us a chance to review the need for the feature before you start working on it.

[Setup flutter](https://docs.flutter.dev/get-started/install/windows) and then run

```console
# Run code generator for datastructures
flutter pub run build_runner build

# Update favicon
dart run flutter_launcher_icons

# Run development tool
flutter run
```

## Releasing

Create a new Github tag named v1.1.0 and push it

```console
git tag v1.1.0
git push origin v1.1.0
```
