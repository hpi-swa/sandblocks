as yet unclassified
mouseDown: anEvent

	recording := true.
	points := OrderedCollection new.
	points add: anEvent position - self position.
	self changed