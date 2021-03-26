Class {
	#name : #SBScmSplitModule,
	#superclass : #SBScmModule,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmSplitModule >> binding: aString for: block class: aClass ifPresent: aBlock [

	self parentSandblock moduleDefinitions do: [:def | def ifDefinition: [:name | aString = name ifTrue: [aBlock value: def]] otherwise: []].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBScmSplitModule >> bindingOf: aSymbol [

	self parentSandblock moduleDefinitions do: [:def | def ifDefinition: [:name | aSymbol = name ifTrue: [^ aSymbol -> def definitionValue]] otherwise: []].
	^ nil
]

{ #category : #'as yet unclassified' }
SBScmSplitModule >> floating [

	^ true
]
