# fluent-plugin-rinflux

Output plugin for InfluxDB.

see [Rinflux](https://github.com/winebarrel/rinflux) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-rinflux'
```

And then execute:

    $ bundle

## Configuration

```apache
<match influxdb.**>
  type rinflux
  db mydb
  #host localhost
  #port 8086
</match>
```

## Usage

```sh
echo '{"disk_free":442221834240}' | fluent-cat influxdb.data
```
```sh
echo '{"disk_free":442221834240,"tags":{"hostname":"server01","disk_type":"SSD"}}' | fluent-cat influxdb.data
```
```sh
echo '{"disk_free":{"free_space":442221834240,"disk_type":"SSD"}' | fluent-cat influxdb.data
```
