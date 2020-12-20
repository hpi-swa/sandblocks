examples
exampleSimpleChat

	| window picture text |
	picture := PHWidget new color: Color green; minSize: 64 asPoint.
	text := PHLabel text: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'.
	
	window := PHTopLevel new vertical: false; size: 600 asPoint; padding: 15; add: picture; add: text.
	window openInWorld