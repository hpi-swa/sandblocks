as yet unclassified
reportValue: aMorph

	| form |
	form := [aMorph imageForm]
		on: Error
		do: [ | fallback |
			fallback := Form extent: 30 asPoint depth: 32.
			fallback getCanvas
				 frameAndFillRectangle: fallback boundingBox fillColor: Color red borderWidth: 1 borderColor: Color yellow;
				 line: 0 @ 0 to: 30 asPoint width: 1 color: Color yellow;
				 line: 30 @ 0 to: 0 @ 30 width: 1 color: Color yellow.
			fallback].
	self image: ((form width > 100 or: [form height > 100]) ifTrue: [form scaledIntoFormOfSize: 100 asPoint] ifFalse: [form])