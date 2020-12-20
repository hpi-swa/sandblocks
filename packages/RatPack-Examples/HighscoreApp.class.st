"
This is an app which saves highscores for SWA games. 
"
Class {
	#name : #HighscoreApp,
	#superclass : #SBRPApplication,
	#category : #'RatPack-Examples'
}

{ #category : #templating }
HighscoreApp >> bootstrapTemplate [

	^ '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>'
]

{ #category : #templating }
HighscoreApp >> customCssTemplate [

	^ '<style>
		</style>'
]

{ #category : #templating }
HighscoreApp >> gameListCssTemplate [

	^ '<style>
			.card {
				margin-top: 10px;
			}
		</style>'
]

{ #category : #templating }
HighscoreApp >> gameListTemplate [

	| htmlString |
	
	htmlString := self htmlBeginTemplate, self gameListCssTemplate,
	'<% games do: [ :game | %>
  		<div class="card game-card" >
			<img class=card-img-top" src="data:image/png;base64, <%= game object image %>" style="object-fit: cover;height: 20rem;"/>
	  		<div class="card-body">
	    		<h5 class="card-title"><%= game object name %></h5>
	    		<p class="card-text"><%= game object description %></p>	
				<a href="/highscores/<%= game metadata at: #id %>/" class="btn btn-primary">Highscores</a>		
			</div>
		</div>
	<% ]. %>', self htmlEndTemplate.

	^ htmlString
]

{ #category : #handler }
HighscoreApp >> getGameList [

	"Using pragmas, you can define routes for your application"
	<get: '/games/'>
	
	| games |
	
	games := self database loadModelObjectsOf: GameModel.
	
	self sendHtml: (self est: (self gameListTemplate)).
	



]

{ #category : #handler }
HighscoreApp >> getHighscoreListFor: aGameId [

	<get: '/highscores/(\d+)/'>
	
	| game scoresSql scoresDict scores comparator |
	game := self database loadModelObject: aGameId asInteger from: GameModel.
	scoresSql := self database executeSQLStatement: 'SELECT * FROM ', ScoreModel tableName, ' WHERE game=', (game metadata at: #id).
	scoresDict := self database transformToCollection: scoresSql.
	scores := scoresDict collect: [:each | (ScoreModel constructModel: each)].
	
	comparator := [ :score1 :score2 | (score1 object score asInteger) > (score2 object score asInteger). ].
	scores := scores sort: comparator.
	
	self sendHtml: (self est: (self highscoreListTemplate)).
	



]

{ #category : #handler }
HighscoreApp >> getPlayerDetailsFor: aPlayerId [

	<get: '/players/(\d+)/'>
	
	| player scoresSql scoresDict scores comparator |
	
	player := self database loadModelObject: aPlayerId asInteger from: SwaPlayerModel.
	scoresSql := self database executeSQLStatement: 'SELECT * FROM ', ScoreModel tableName, ' WHERE player=', (player metadata at: #id).
	scoresDict := self database transformToCollection: scoresSql.
	scores := scoresDict collect: [:each | (ScoreModel constructModel: each)].
	
	comparator := [ :score1 :score2 | (score1 object score) > (score2 object score). ].
	scores := scores sort: comparator.
	
	self sendHtml: (self est: (self playerDetailsTemplate )).
	



]

{ #category : #handler }
HighscoreApp >> getPlayerList [
	<get: '/players/'>

	| players |
	players := SBNewWatch report: (self database loadModelObjectsOf: SwaPlayerModel) for: 21983831.
	
	self sendHtml: (self est: self playerListTemplate)
]

{ #category : #templating }
HighscoreApp >> highscoreListCssTemplate [

	^ '<style>
			.list-group {
				margin-top: 10px;
			}
			
			.page-header {
				margin-top: 20px;
				margin-bottom: 20px;
			}
		</style>'
]

{ #category : #templating }
HighscoreApp >> highscoreListTemplate [

	| htmlString |
	
	htmlString := self htmlBeginTemplate, self highscoreListCssTemplate, '
	<div class="page-header">
		<h1>Highscores für <%= game object name %></h1>
	</div>
	<div class="list-group">
		<% scores doWithIndex: [ :score :index | %>
			<% player := self database loadModelObject: (score object player) from: SwaPlayerModel. %> 
	  		<a href="/players/<%= player metadata at: #id %>/" class="list-group-item list-group-item-action"><b>Platz <%= index %> </b>: <%= score object score %> Punkte - <%= player object name %></a>
		<% ]. %>
	</div>', self htmlEndTemplate.

	^ htmlString
]

{ #category : #templating }
HighscoreApp >> htmlBeginTemplate [

	^ '<html><head><title>SWA-Highscores</title></head><body>', self bootstrapTemplate, self customCssTemplate, self navbarTemplate, '<div class="container">'.
]

{ #category : #templating }
HighscoreApp >> htmlEndTemplate [

	^ '</div></body>'
]

{ #category : #initialization }
HighscoreApp >> initialize [ 

	super initialize.
	self database: RPImageDatabase new.
	self
		registerModel: SwaPlayerModel;
		registerModel: GameModel;
		registerModel: ScoreModel.
]

{ #category : #initialization }
HighscoreApp >> initializeSettings [
	self settings globalMiddleware: {
		"#RequestDebugMiddleware."
		#AuthenticationMiddleware } asOrderedCollection.
]

{ #category : #templating }
HighscoreApp >> navbarTemplate [

	^ '<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  			<a class="navbar-brand" href="/games/">SWA-Highscores</a>
  			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" 				aria-label="Toggle navigation">
    			<span class="navbar-toggler-icon"></span>
  			</button>
	
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
    			<ul class="navbar-nav mr-auto">
					<a class="nav-link" href="/games/">Spiele</a>
					<a class="nav-link" href="/players/">Spieler</a>
      			</ul>
  			</div>
</nav>'
]

{ #category : #templating }
HighscoreApp >> playerDetailsTemplate [

	| htmlString |
	
	htmlString := self htmlBeginTemplate, self highscoreListCssTemplate, '
	<div class="page-header">
		<h1>Highscores von <%= player object name %></h1>
	</div>
	<div class="list-group">
		<% scores doWithIndex: [ :score :index | %>
			<% game := (self database) loadModelObject: (score object game) from: GameModel. %>
	  		<a href="#" class="list-group-item list-group-item-action"><b><%= game object name %> </b>: <%= score object score %> Punkte</a>
		<% ]. %>
	</div>', self htmlEndTemplate.

	^ htmlString
]

{ #category : #templating }
HighscoreApp >> playerListCssTemplate [

	^ '<style>
			.list-group {
				margin-top: 10px;
			}
		</style>'
]

{ #category : #templating }
HighscoreApp >> playerListTemplate [

	| htmlString |
	
	htmlString := self htmlBeginTemplate, self playerListCssTemplate,
	'<div class="list-group">
		<% players do: [ :player | %>
	  		<a href="/players/<%= player metadata at: #id %>/" class="list-group-item list-group-item-action"><%= player object name %></a>
		<% ]. %>
	</div>', self htmlEndTemplate.

	^ htmlString
]
