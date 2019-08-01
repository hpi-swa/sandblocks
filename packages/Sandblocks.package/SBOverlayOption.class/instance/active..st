as yet unclassified
active: aBoolean

	active = aBoolean ifTrue: [^ self].
	
	active := aBoolean.
	
	self backgroundColor: (aBoolean ifTrue: [Color red] ifFalse: [Color white]).
	self color: (aBoolean ifTrue: [Color white] ifFalse: [Color black]).
	
	suboptions ifNil: [^ self].
	aBoolean
		ifTrue: [suboptions do: [:morph |
					morph
						center: morph parentOption center;
						moveBy: morph place.
					self owner addMorphBack: morph]]
		ifFalse: [suboptions do: #delete]