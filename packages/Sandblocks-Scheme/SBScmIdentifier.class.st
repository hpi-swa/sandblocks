Class {
	#name : #SBScmIdentifier,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmIdentifier >> asSymbol: converter [
	<convert>
	
	converter do: [SBScmSymbol new contents: self contents]
]

{ #category : #'as yet unclassified' }
SBScmIdentifier >> isIdentifier [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmIdentifier >> printOn: aStream [

	aStream nextPutAll: 'identifier '.
	aStream nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBScmIdentifier >> resolveBinding [

	self binding: self contents for: self class: self containingArtefact relatedClass ifPresent: [:binding | ^ binding].
	^ nil
]

{ #category : #'as yet unclassified' }
SBScmIdentifier >> valid [

	^ self resolveBinding notNil and: [self validContents]
]

{ #category : #'as yet unclassified' }
SBScmIdentifier >> validContents [

	| initial subsequent |
	self contents ifEmpty: [^ false].
	
	initial := [:c | c isLetter or: [#($! $$ $% $& $* $/ $: $< $= $> $? $^ $_ $~ $+ $- $. $#) includes: c]].
	subsequent := [:c | (initial value: c) or: [c isDigit or: [#($+ $- $. $@) includes: c]]].
	^ (initial value: self contents first) and: [self contents viewAllButFirst allSatisfy: subsequent]
]
