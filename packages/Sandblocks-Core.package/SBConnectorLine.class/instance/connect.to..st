as yet unclassified
connect: anObject to: anotherObject

	from := anObject.
	to := anotherObject.
	from when: #positionChanged send: #update: to: self with: nil.
	to when: #positionChanged send: #update: to: self with: nil.
	from addDependent: self.
	to addDependent: self.
	self update: nil