(function() {
  var Metric;

  Metric = {
    setApiKey: function(api_key) {
      return this.api_key = api_key;
    },
    getChart: function(container, metrics, tokens, range) {
      if (metrics.constructor === String) metrics = [metrics];
      if (tokens.constructor === String) tokens = [tokens];
      return this.lineGraph(container, metrics, tokens, range);
    },
    log: function(output) {
      if (console) return console.log(output);
    },
    generateUrl: function(metric, range, token) {
      return "https://api.metric.io/receive?api_key=" + this.api_key + "&token=" + token + "&metric=" + metric + "&range=" + range + "&callback=?";
    },
    getData: function(url, callback) {
      var parsed_data;
      parsed_data = [];
      return $.getJSON(url, function(data, textStatus) {
        $.each(data, function(index, value) {
          return parsed_data.push([value[0], parseInt(value[1], 10)]);
        });
        return callback(parsed_data);
      });
    },
    generateTimeString: function() {
      return (new Date).getTime().toString();
    },
    generateTrackingUrl: function(metric, amount, callback) {
      var time;
      callback || (callback = "metric.log");
      time = this.generateTimeString();
      if (amount) {
        return "https://api.metric.io/track?api_key=" + this.api_key + "&metric=" + metric + "&amount=" + amount + "&callback=" + callback + "&time=" + time;
      } else {
        return "https://api.metric.io/track?api_key=" + this.api_key + "&metric=" + metric + "&callback=" + callback + "&time=" + time;
      }
    },
    sendRequest: function(metric, amount, callback) {
      var c, head;
      c = document.createElement("script");
      c.type = "text/javascript";
      c.async = true;
      c.defer = true;
      c.src = this.generateTrackingUrl(metric, amount, callback);
      head = document.getElementsByTagName("head")[0];
      return head.appendChild(c);
    },
    lineGraph: function(container, metrics, tokens, range) {
      window.chart = {};
      return $(function() {
        var options;
        var _this = this;
        options = {
          chart: {
            animation: false,
            renderTo: container,
            type: 'line',
            marginTop: 20,
            marginleft: 20,
            marginright: 20,
            plotBorderWidth: 2
          },
          colors: ["#a1cf32"],
          credits: {
            enabled: false
          },
          tooltip: {
            formatter: function() {
              return "<strong>" + this.series.name + "</strong><br/>" + this.y + "<br/>" + (Highcharts.dateFormat('%B %d, %Y', this.x));
            }
          },
          title: {
            text: null
          },
          xAxis: {
            labels: {
              enabled: true,
              formatter: function() {
                return Highcharts.dateFormat('%b %d', this.value);
              }
            },
            type: 'datetime',
            dateTimeLabelFormats: {
              day: '%e %b'
            },
            tickWidth: 0,
            gridLineWidth: 0,
            tickLength: 0
          },
          yAxis: {
            title: null,
            allowDecimals: false,
            labels: {
              align: 'left',
              x: 2,
              y: -2
            },
            reversed: false,
            startOnTick: false
          },
          legend: {
            enabled: false
          },
          series: []
        };
        return $.each(metrics, function(index, metric) {
          var url;
          url = window.metric.generateUrl(metric, range, tokens[index]);
          return window.metric.getData(url, function(parsed_data) {
            var data;
            data = {
              name: metric,
              data: parsed_data
            };
            options.series.push(data);
            if (index === 0) {
              return window.chart = new Highcharts.Chart(options);
            } else {
              return window.chart = new Highcharts.Chart(options);
            }
          });
        });
      });
    }
  };

  if (typeof window === 'undefined') {
    this.metric = Metric;
  } else {
    window.metric = Metric;
  }

}).call(this);
