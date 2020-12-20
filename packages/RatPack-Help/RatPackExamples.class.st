Class {
	#name : #RatPackExamples,
	#superclass : #RatPackHelp,
	#category : #'RatPack-Help'
}

{ #category : #accessing }
RatPackExamples class >> bookName [ 
	^ 'Example app'
]

{ #category : #pages }
RatPackExamples class >> overview [
	^ HelpTopic 
		title: 'Example app'
		contents: 'This section will explain the basic usage of the example app. It can be used to create and view highscores for your swa game.' 
]

{ #category : #pages }
RatPackExamples class >> page1 [
	^HelpTopic 
		title: 'Setting up the example app.'
		contents: 'First, set up the example app as described in the chapter RatPack usage.'
]

{ #category : #pages }
RatPackExamples class >> page2 [
	^HelpTopic 
		title: 'Adding objects'
		contents: 'You need to add your swa game to the application in order to post highscores. You can do this via RatPack Control Panel or by sending a json to the route api/games/. The json object should look like this:
			
			{
				"name": "Name of your game",
				"description": "Description of your game",
				"password": "Password for your game - could be used in AuthenticationMiddleware for example",
				"image": "Base64 encoded image of your game"
			}
			
			If you view the /games/ route now, your game should be visible. Then you can add players by making a post request to api/players/. It should contain the following values:
			
			{
				"name": "Name of the player"
			}
			
			If you view the /players/ route now, the player should be visible now.'

]

{ #category : #pages }
RatPackExamples class >> page3 [
	^HelpTopic 
		title: 'Sending highscores'
		contents: 'You can send highscores directly from your SWA app using the WebClient package. Use the following code and replace player in the json with the id of the player who scored this, game with the id of the game and score with the score. These ids will be returned when an object is created or can be read from the api.
		
		body := ''{ "player": "1", "game": 3, "score": "42"}''
		url := ''http://localhost:4567/api/highscores''.
	
		client := (WebClient new) initializeFromUrl: url.
		request := client requestWithUrl: url.
		request method: ''POST''.
		request headerAt: ''Content-Type'' put: ''application/json''.
		request headerAt: ''Content-Length'' put: body size.
		request headerAt: ''Authorization'' put: ''a:12345''. 
		response := client sendRequest: request content: body readStream size: body size.'

]

{ #category : #accessing }
RatPackExamples class >> pages [

	^ #(overview page1 page2 page3)
]

{ #category : #accessing }
RatPackExamples class >> priority [

	^ 30
]
