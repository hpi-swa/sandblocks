Class {
	#name : #SBConvertTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBConvertTest >> expectedFailures [

	^ #(#testListOptions)
]

{ #category : #'as yet unclassified' }
SBConvertTest >> testListOptions [

	| obj options |
	obj := SBConvertTestObject new.
	options := Array streamContents: [:str | obj allConversionsFor: SBInterfaces topLevel do: [:option | str nextPut: option]].
	
	options detect: [:option | option name = 'conditionalConvert:']
]
