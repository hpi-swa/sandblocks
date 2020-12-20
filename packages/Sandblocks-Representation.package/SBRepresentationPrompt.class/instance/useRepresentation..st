as yet unclassified
useRepresentation: aRepresentation

	| newRepresentation |
	newRepresentation := aRepresentation newFor: target.
	
	currentRepresentation
		ifNotNil: [:c |
			c removeActionsWithReceiver: self.
			newRepresentation position: currentRepresentation position.
			
			currentRepresentation replaceBy: newRepresentation.
			newRepresentation center: currentRepresentation center]
		ifNil: [
			self sandblockEditor openMorphInView: newRepresentation.
			newRepresentation position: position].
	
	self flag: #todo.
	currentRepresentation := newRepresentation.
	self updatePosition.
	newRepresentation
		when: #positionChanged send: #updatePosition to: self;
		when: #extentChanged send: #updatePosition to: self.
	
	sourceMorph ifNotNil: [
		newRepresentation owner addMorphBack: (SBRepresentationConnector connect: sourceMorph to: newRepresentation representation: aRepresentation)]