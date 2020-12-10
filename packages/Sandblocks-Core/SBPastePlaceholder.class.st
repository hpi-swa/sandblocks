Class {
	#name : #SBPastePlaceholder,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPastePlaceholder class >> for: aMorph root: aRootMorph copyIn: anEditor [

	| around replacer |
	replacer := self new.
	around := aMorph.
	around replaceBy: replacer.
	anEditor copyBuffer: aRootMorph.
	replacer replaceBy: around.
	^ replacer
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder class >> forAll: aCollection root: aRootMorph copyIn: anEditor [
	" requires aCollection to be a consecutive list of morphs "

	| replacer |
	replacer := self new.
	aCollection first replaceBy: replacer.
	aCollection do: #delete.
	anEditor copyBuffer: aRootMorph.
	replacer replaceBy: aCollection first.
	aCollection first owner addAllMorphs: aCollection allButFirst behind: aCollection first.
	^ replacer
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> drawnColor [

	^ Color red
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> guessClassExpensive [

	^ nil
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> guessedClass [

	^ nil
]

{ #category : #'as yet unclassified' }
SBPastePlaceholder >> initialize [

	super initialize.
	
	self extent: self fontToUse height asPoint
]
