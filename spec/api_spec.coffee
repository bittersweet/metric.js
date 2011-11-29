# Fake the window global
jsdom = require('jsdom').jsdom
window = jsdom().createWindow()
global.window = window

require("../src/api.coffee")
describe 'api', ->

  it 'sets api key', ->
    metric = window.metric
    metric.setApiKey("1234")
    expect(metric.api_key).toEqual("1234")

  it 'generates correct URL', ->
    metric = window.metric
    metric.setApiKey("1234")
    url = 'http://api.metric.io/receive?api_key=1234&token=token&metric=hits&range=week&callback=?'
    expect(metric.generateUrl("hits", "week", "token")).toEqual(url)

