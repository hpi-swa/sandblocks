as yet unclassified
initialize

	super initialize.
	
	recording := false.
	points := OrderedCollection new.
	text := ''.
	
	self extent: TextStyle defaultFont height asPoint * (40 @ 16)