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
    url = 'http://api.metric.io/receive?api_key=1234&token=token&metric=hits&range=week&callback=?'
    expect(metric.generateUrl("hits", "week", "token")).toEqual(url)

  it 'generates correct tracking URL', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'http://api.metric.io/track?api_key=1234&metric=hits&callback=metric.log&time=123'
    expect(metric.generateTrackingUrl("hits")).toEqual(url)

  it 'generates correct tracking URL with amount', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'http://api.metric.io/track?api_key=1234&metric=hits&amount=2&callback=metric.log&time=123'
    expect(metric.generateTrackingUrl("hits", 2)).toEqual(url)

  it 'generates script tag for tracking', ->
    spyOn(metric, 'generateTimeString').andReturn(123)
    url = 'http://api.metric.io/track?api_key=1234&metric=hits&callback=metric.log&time=123'
    metric.sendRequest("hits")
    script = document.getElementsByTagName("script")[0]
    expect(script.getAttribute("src")).toEqual(url)
