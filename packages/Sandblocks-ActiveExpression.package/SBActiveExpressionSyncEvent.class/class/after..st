as yet unclassified
after: anObject

	| subject |
	subject := thisContext sender receiver.
	self flag: #performance. " we assume that this operation happens only occurs rarely, since the user would likely be overloaded by the amount of informations otherwise "
	SBAEMarbles allInstancesDo: [:marbles |
		marbles isInWorld ifTrue: [
			marbles addSyncEventFrom: subject with: anObject]].
	^ anObject