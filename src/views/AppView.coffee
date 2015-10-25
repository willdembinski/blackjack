class window.AppView extends Backbone.View

  el: '.game'

  template: _.template '
  <div class="col-md-2"></div>
    <div class="col-md-8 jumbotron">
      <div class="col-md-6">
        <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
        <span class="badge">Dealer Score: <%= dealer %></span>
        <span class="badge">Player: <%= player %></span>
        <div class="player-hand-container hand"></div>
        <div class="dealer-hand-container hand"></div>
      </div>
      <div class="col-md-6">
        <h1 class="loadingtxt"></h1>
      </div>
    </div>
  <div class="col-md-2"></div>'

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('dealerHand').stand()

  initialize: ->
    @render()
    @listenTo @model, 'disableButtons', @disable
    @listenTo @model, 'winDetected', @render
    @listenTo @model, 'loading', @loading

  render: ->
    clearInterval(window.LInterval)
    @$el.children().detach()
    @$el.html @template({player: @model.get("playerWins"),dealer:@model.get("dealerWins")})
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
  
  disable: ->
    $('button').prop('disabled', true)

  loading: ->
    count = 0;
    fxn = ()->
      count++
      $('.loadingtxt').text("Shuffling" + new Array(count % 10).join('.'))
      return
    
    window.LInterval = setInterval fxn, 100
