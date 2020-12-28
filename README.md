# Smarthome Bridge

This application provides a software Bridge between Apple Homekit and your FritzBox Smarthome thermostats.

Powered by:
* [RubyHome](https://github.com/karlentwistle/ruby_home)
* [FritzBox::SmartHome](https://github.com/klausmeyer/fritzbox-smarthome)

Designed to run in Docker on a Raspberry Pi computer.

## Config:

Available Environment Variables:

* `FRITZBOX_ENDPOINT`:<br>
  URL to your FritzBox (Default: `https://fritz.box`)
* `FRITZBOX_USERNAME`:<br>
  Username to login to your FritzBox (Default: `smarthome`)
* `FRITZBOX_PASSWORD`:<br>
  Passwort to login to your FritzBox (Default: `verysmart`)
* `FRITZBOX_VERIFY_SSL`:<br>
  Check the FritzBox's SSL cert (Default: `false`)
* `RUBYHOME_NAME`:<br>
  How the Bridge should be named (Default: `Ruby Home`)


## Usage:

```
docker build -t klausmeyer/smarthome-bridge .
docker run --net=host --hostname=$(hostname -f) --volume $PWD/data:/app/data klausmeyer/smarthome-bridge
```
