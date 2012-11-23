Metric =
  setApiKey: (api_key) ->
    @api_key = api_key
  setUrl: (url) ->
    @url = url

  log: (output) ->
    if console
      console.log(output)

  track: (metric, amount, callback) ->
    url = @generateTrackingUrl(metric, amount)
    @sendRequest(url, callback)

  generateTimeString: ->
    (new Date).getTime().toString()

  generateTrackingUrl: (metric, amount) ->
    time = @generateTimeString()
    url = @url || "https://api.metric.io"
    amount ||= 1
    "#{url}/v1/sites/#{@api_key}/track?metric=#{metric}&amount=#{amount}&time=#{time}"

  generateStatisticsUrl: (metric, range, token) ->
    url = @url || "https://api.metric.io"
    "#{url}/v1/sites/#{@api_key}/statistics?metric=#{metric}&range=#{range}&token=#{token}"

  receive: (metric, amount, token) ->
    url = @generateStatisticsUrl(metric, amount, token)
    @sendRequest(url, callback)

  sendRequest: (url, callback) ->
    callback ||= @log
    request = new XMLHttpRequest()
    if request.withCredentials != undefined
      request.open("GET", url, true)
      request.onreadystatechange = (e) ->
        if request.readyState == 4
          if request.status == 200
            callback(request.responseText)
          else
            Metric.log("Bad HTTP status", request.status, request.statusText)
      request.send();

if typeof window == 'undefined'
  this.metric = Metric
else
  window.metric = Metric

