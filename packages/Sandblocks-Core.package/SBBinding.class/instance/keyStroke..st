as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = $: ifTrue: [ | new |
		new := SBUnknown new.
		^ self sandblockEditor
			endInput;
			do: ((SBWrapCommand newFor: self containingArtefact)
				inner: self;
				outer: SBAssignment new;
				wrap: [:outer :inner | outer binding: self value: new]);
			startInput: new at: 0 replacingContents: false].
	
	super keyStroke: anEvent.
	
	(self contents = 'true' or: [self contents = 'false']) ifTrue: [^ self assureClass: SBBoolean].
	self isReserved ifTrue: [^ self assureClass: SBKeywordBinding].
	
	self updateSuggestions