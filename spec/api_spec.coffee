# Fake the window global
jsdom = require('jsdom').jsdom
fs = require('fs')
page_template = fs.readFileSync('spec/index.html','utf-8')
window = jsdom().createWindow()
document = jsdom(page_template)
global.window = window
global.document = document

require("../src/api.coffee")
describe 'api', ->
  metric = window.metric
  metric.setApiKey("1234")

  it 'sets api key', ->
    expect(metric.api_key).toEqual("1234")

  it 'generates correct URL', ->
    url = 'https://api.metric.io/v1/sites/1234/statistics?metric=hits&range=week&token=token'
    expect(metric.generateStatisticsUrl("hits", "week", "token")).toEqual(url)

  it 'allows overriding of api endpoint when receiving', ->
    metric.setUrl('http://localhost')
    url = 'http://localhost/v1/sites/1234/statistics?metric=hits&range=week&token=token'
    expect(metric.generateStatisticsUrl("hits", "week", "token")).toEqual(url)
    metric.setUrl('https://api.metric.io')

  it 'allows overriding of api endpoint when tracking', ->
    metric.setUrl('http://localhost')
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'http://localhost/v1/sites/1234/track?metric=hits&amount=1&time=123'
    expect(metric.generateTrackingUrl("hits")).toEqual(url)
    metric.setUrl('https://api.metric.io')

  it 'generates correct tracking URL', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'https://api.metric.io/v1/sites/1234/track?metric=hits&amount=1&time=123'
    expect(metric.generateTrackingUrl("hits")).toEqual(url)

  it 'generates correct tracking URL with amount', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'https://api.metric.io/v1/sites/1234/track?metric=hits&amount=2&time=123'
    options = {amount: 2}
    expect(metric.generateTrackingUrl("hits", options)).toEqual(url)

  it 'generates correct tracking URL with meta', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'https://api.metric.io/v1/sites/1234/track?metric=hits&amount=2&time=123&meta=user%201'
    options = {amount: 2, meta: 'user 1'}
    expect(metric.generateTrackingUrl("hits", options)).toEqual(url)

  it 'builds url', ->
    url = 'track?metric=hits&amount=2&meta=user%201'
    options = {metric: 'hits', amount: 2, meta: 'user 1'}
    expect(metric.buildUrl("track", options)).toEqual(url)

  it 'builds url with nested objects', ->
    url = 'track?metric=hits&amount=2&customer%5Bid%5D=1'
    options = {metric: 'hits', amount: 2, customer: {'id': 1}}
    expect(metric.buildUrl("track", options)).toEqual(url)

