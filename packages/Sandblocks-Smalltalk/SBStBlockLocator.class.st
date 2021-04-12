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
		class selectorsAndMethodsDo: [:selector :method | | matchedMethod |
			matchedMethod := false.
			method literalsDo: [:literal |
				(literal isSymbol and: [literal matchesRegex: aRegex]) ifTrue: [ | blockMethod matching |
					blockMethod := method asSandblockWithoutSubstitution.
					matching := blockMethod allBlocksSelect: [:b | (b isSymbolBlock or: [b isMessageSend]) and: [b contents matchesRegex: aRegex]].
					self assert: matching notEmpty.
					(method selector matchesRegex: aRegex) ifTrue: [
						matching := matching copyWith: blockMethod.
						matchedMethod := true].
					aBlock value: blockMethod value: matching]].
			
			(matchedMethod not and: [method selector matchesRegex: aRegex]) ifTrue: [ | blockMethod |
				blockMethod := method asSandblockWithoutSubstitution.
				aBlock value: blockMethod value: blockMethod]]]
]
