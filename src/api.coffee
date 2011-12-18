Metric =
  setApiKey: (api_key) ->
    @api_key = api_key
  setUrl: (url) ->
    @url = url
  getChart: (container, metrics, tokens, range) ->
    if metrics.constructor == String
      metrics = [metrics]
    if tokens.constructor == String
      tokens = [tokens]
    @lineGraph(container, metrics, tokens, range)

  log: (output) ->
    if console
      console.log(output)

  generateUrl: (metric, range, token) ->
    url = @url || "https://api.metric.io"
    "#{url}/receive?api_key=#{@api_key}&token=#{token}&metric=#{metric}&range=#{range}&callback=?"

  getData: (url, callback) ->
    parsed_data = []
    $.getJSON url, (data, textStatus) ->
      $.each data, (index, value) ->
        parsed_data.push([Date.parse(value[0]), parseInt(value[1], 10)])
      callback(parsed_data)

  generateTimeString: ->
    (new Date).getTime().toString()

  generateTrackingUrl: (metric, amount, callback) ->
    callback ||= "metric.log"
    time = @generateTimeString()
    url = @url || "https://api.metric.io"
    if amount
      "#{url}/track?api_key=#{@api_key}&metric=#{metric}&amount=#{amount}&callback=#{callback}&time=#{time}"
    else
      "#{url}/track?api_key=#{@api_key}&metric=#{metric}&callback=#{callback}&time=#{time}"

  sendRequest: (metric, amount, callback) ->
    c = document.createElement("script")
    c.type = "text/javascript"
    c.async = true
    c.defer = true
    c.src = @generateTrackingUrl(metric, amount, callback)
    head = document.getElementsByTagName("head")[0]
    head.appendChild(c)

  lineGraph: (container, metrics, tokens, range) ->
    window.chart = {}

    $ ->
      options =
        chart:
          animation: false
          renderTo: container
          type: 'line'
          marginTop: 20
          marginleft: 20
          marginright: 20
          plotBorderWidth: 2
        colors: ["#a1cf32"]
        credits:
          enabled: false
        tooltip:
          formatter: ->
            "<strong>#{this.series.name}</strong><br/>#{this.y}<br/>#{Highcharts.dateFormat('%B %d, %Y', this.x)}"
        title:
          text: null
        xAxis:
          labels:
            enabled: true
            formatter: ->
              Highcharts.dateFormat('%b %d', this.value)
          type: 'datetime'
          dateTimeLabelFormats:
            day: '%e %b'
          tickWidth: 0
          gridLineWidth: 0
          tickLength: 0
        yAxis:
          title: null
          allowDecimals: false
          labels:
            align: 'left'
            x: 2
            y: -2
          reversed: false
          startOnTick: false
        legend:
          enabled: false
        series: []

      $.each metrics, (index, metric) =>
        url = window.metric.generateUrl(metric, range, tokens[index])
        window.metric.getData url, (parsed_data) ->
          data = {name: metric, data: parsed_data}
          options.series.push(data)
          if index == 0
            window.chart = new Highcharts.Chart(options)
          else
            # We should redraw but this doesn't actually seem to reload in the
            # data, so we're rendering the whole chart for now
            # chart.redraw();
            window.chart = new Highcharts.Chart(options)

if typeof window == 'undefined'
  this.metric = Metric
else
  window.metric = Metric

