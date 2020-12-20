as yet unclassified
methodChanged: anEvent

	((self hasProperty: #ignoreChangeNotifier) not and: (anEvent item selector = self selector and: [anEvent item methodClass = self methodClass])) ifTrue: [
		anEvent isRemoved ifTrue: [^ self delete].
		(anEvent isModified) ifTrue: [^ self hasUnsavedChanges ifTrue: [self externalModification: true] ifFalse: [self reloadMethodInPlace]]]