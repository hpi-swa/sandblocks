as yet unclassified
connect: anObject to: anotherObject representation: aRepresentationClass

	self connect: anObject to: anotherObject.
	
	from containingArtefact when: #changed send: #update to: self.
	lastSource := from object.
	currentRepresentation := aRepresentationClass