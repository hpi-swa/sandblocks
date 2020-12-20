as yet unclassified
testRequest

	| route |
	route := (service routesFor: #get:) first.
	WebClient httpGet: ('http://localhost:', service portNumber asString), route key