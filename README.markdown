This is a Javascript library to work with [metric.io](https://metric.io).

Currently it allows you to track metrics and also embed them, embedding requires jQuery and Highcharts.

## Usage

### Setting up

Before being able to use the JS library you will need to set your api key that you get when creating a site

    metric.setApiKey("api_key")

### Tracking

Use `sendRequest` to push data to metric.io, this takes an optional `amount` argument

    metric.sendRequest("sales")

### Getting data out

You can use Highcharts to display a line graph with your data

    metric.getChart("graph_container", "sales", "token", "month")

`getChart` takes the following arguments:

* container &mdash; DOM id that will be used to contain the chart
* metric &mdash; name of metric
* token &mdash; hash of your secret key and the metric
* range &mdash; week or month

## Todo

* Cover every API method of getting data out &mdash; the only way to get data out of metric.io now is by using `getChart`
which automatically generates a linegraph. We need to expose more methods so you can do whatever you want with the data.
* Make it compatible with nodejs &mdash; tracking currently relies on generating script tags 
with srcs that point to the API, because nodejs of course has no document to write too this 
will need to take another approach.


## Building

This will compile the coffeescript file and compress it with uglifyjs.

    make

## Running specs

    make test
