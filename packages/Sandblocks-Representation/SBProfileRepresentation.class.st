Class {
	#name : #SBProfileRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBProfileRepresentation class >> causesSideEffects [

	^ true
]

{ #category : #'as yet unclassified' }
SBProfileRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBProfileRepresentation class >> matches: anObject [
^ anObject isSandblock and: [anObject isBlockBody]
]

{ #category : #'as yet unclassified' }
SBProfileRepresentation class >> newFor: anObject [


	anObject evaluate timeProfile.
	^ SBRepl new
		receiver: nil;
		statements: {
			(SBMessageSend new receiver: anObject selector: #timeProfile)
		}
]
