This is a Javascript library to work with [metric.io](https://metric.io).

Currently it allows you to track metrics and also embed them, embedding requires jQuery and Highharts.

## Usage

### Setting up

Before being able to use the JS library you will need to set your api key that you received from the website:

    metric.setApiKey("api_key")

### Tracking

Use `sendRequest` to push data to metric.io, this takes an optional `amount` argument

    metric.sendRequest("sales")

### Getting data out

You can use Highcharts to display a chart

    metric.getChart("graph_container", "sales", "token", "month")

`getChart` takes the following arguments:

* container &mdash; DOM id that will be used to contain the chart
* metric &mdash; name of metric
* token &mdash; hash of your secret key and the metric
* range &mdash; week or month

## Building

This will compile the coffeescript file and compress it with uglifyjs.

    make

## Running specs

    make test
