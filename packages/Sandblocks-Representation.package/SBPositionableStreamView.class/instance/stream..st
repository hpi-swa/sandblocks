as yet unclassified
stream: aStream

	| start stop |
	SBExample
		self: [SBPositionableStreamView new]
		args: [
			{
				({1. 2. 3. 4. 5. 8. 12. 2. 14} readStream
					next;
					yourself)
			}]
		label: 'example'.
	stream := aStream.
	self firstSubmorph removeAllMorphs.
	self submorphs second contents: aStream position asString.
	self submorphs third contents: aStream size asString.
	start := aStream position - 5 max: 1.
	stop := aStream position + 5 min: aStream size.
	
	start > 1 ifTrue: [
		self firstSubmorph addMorphBack: (SBStringMorph new contents: '...')].
	aStream originalContents
		from: start
		to: stop
		do: [:item |
			self firstSubmorph addMorphBack: (item anyRepresentationThat: #(#isSandblock))].
	stop < aStream size ifTrue: [
		self firstSubmorph addMorphBack: (SBStringMorph new contents: '...')].
	
	aStream position > 0 ifTrue: [
		((self firstSubmorph submorphs select: #isSandblock) at: (aStream position - start) + 1) attachDecorator: SBErrorDecorator new]