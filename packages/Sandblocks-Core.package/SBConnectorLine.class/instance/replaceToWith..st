as yet unclassified
replaceToWith: anObject

	to removeActionsWithReceiver: self.
	to removeDependent: self.
	self update: nil.
	
	to replaceBy: anObject.
	
	to := anObject.
	to when: #positionChanged send: #update: to: self with: nil.
	to addDependent: self.
	self update: nil.
	to when: #outOfWorld send: #delete to: self