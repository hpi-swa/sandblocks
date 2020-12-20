as yet unclassified
commandsForRoot: aMorph

	| commands |
	commands := aMorph layoutCommands.
	" our root morph needs to be casted to a group, since we cannot move our root morph as part of layouting "
	(commands type = #container and: [commands morph = aMorph" and: [commands morph owner notNil]"])
		ifTrue: [commands := commands copy type: #group].
	^ commands