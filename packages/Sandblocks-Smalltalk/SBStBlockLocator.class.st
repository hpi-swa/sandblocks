Class {
	#name : #SBStBlockLocator,
	#superclass : #Object,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBlockLocator >> symbolsMatching: aRegex inPackage: packageName do: aBlock [

	| classes |
	classes := (PackageInfo named: packageName) classesAndMetaClasses.
	classes do: [:class |
		class selectorsAndMethodsDo: [:selector :method |
			method literalsDo: [:literal |
				(literal isSymbol and: [literal matchesRegex: aRegex]) ifTrue: [ | blockMethod matching |
					blockMethod := method asSandblockWithoutSubstitution.
					matching := blockMethod allBlocksSelect: [:b | (b isSymbolBlock or: [b isMessageSend]) and: [b contents matchesRegex: aRegex]].
					self assert: matching notEmpty.
					aBlock value: blockMethod value: matching]]]]
]
