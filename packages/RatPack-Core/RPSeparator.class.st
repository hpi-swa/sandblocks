Class {
	#name : #RPSeparator,
	#superclass : #RPRouteNamingStrategy,
	#instVars : [
		'separator'
	],
	#category : #'RatPack-Core'
}

{ #category : #'as yet unclassified' }
RPSeparator class >> newWithSeparator: aSeparator [

	| strategy | 
	strategy := RPSeparator new.
	strategy separator: aSeparator.
	
	^ strategy
]

{ #category : #accessing }
RPSeparator >> findSeparatorPositionsFor: aClassName [

	| separatorPositions char nextChar secondNextChar|

	separatorPositions := OrderedCollection new.
	1 to: aClassName size do: [ :index | 
		char := aClassName at: index.
		(index + 2 <= aClassName size ) ifTrue: [
			nextChar := (aClassName at: (index + 1)) asCharacter.
			secondNextChar := (aClassName at: (index + 2)) asCharacter.
			((nextChar isUppercase and: [ secondNextChar isLowercase. ]) or: 
			(nextChar isUppercase and: [ secondNextChar isUppercase and: [char isLowercase ]] )) ifTrue: [
				separatorPositions add: index. ]. ]. ].
	
	^ separatorPositions
]

{ #category : #routing }
RPSeparator >> nameRoute: aClassName [

	| separatorPositions routeName lastSeparatorPosition |

	separatorPositions := self findSeparatorPositionsFor: aClassName.
		
	routeName := ''.
	lastSeparatorPosition := 1.
	separatorPositions do: [ :position | 
		routeName := routeName, (aClassName copyFrom: lastSeparatorPosition to: position), self separator .
		lastSeparatorPosition := position + 1.].
	
	routeName := routeName, (aClassName copyFrom: lastSeparatorPosition to: aClassName size).
	
	
	^ routeName
]

{ #category : #accessing }
RPSeparator >> separator [
	^ separator asString
]

{ #category : #accessing }
RPSeparator >> separator: anObject [
	separator := anObject
]
