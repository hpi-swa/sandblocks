Class {
	#name : #SBSandboxSimulator,
	#superclass : #SBSimulator,
	#instVars : [
		'tempObjects'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> causesSideEffect: method [

	^ #(39 61 64 66 69 72 74 105 144 145 164 166 174 185 186 187 211) includes: method primitive
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> createsObject: method [

	^ #(18 70 71 79 148) includes: method primitive
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> currentContextIsWhiteListed [

	^ SBToggledCode
		comment: 'explicit whitelist needed here, class side object getting some cleanup :('
		active: 1
		do: {
			[currentContext sender methodClass = Encoder and: [currentContext sender selector = #initScopeAndLiteralTables]]
		}
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> initialize [

	super initialize.
	tempObjects := IdentitySet new
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> isAllowedExternalCall: aMethod [

	| module call |
	module := (aMethod literalAt: 1) at: 1.
	call := (aMethod literalAt: 1) at: 2.
	^ module = #LargeIntegers or: [
		(module = #MiscPrimitivePlugin and: [
			#(#primitiveStringHash #primitiveCompareString #primitiveIndexOfAsciiInString) includes: call]) or: [#(#primitiveUtcWithOffset) includes: call]]
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> isBlacklistedPrimitive: method [

	^ (#(76 85 86 87 88 89 92 93 94 95 97 98 99 101 102 108 113 114 115) includes: method primitive) or: [(#(116 118 119 120 124 125 126 127 128 130 131 133 134 136 140) includes: method primitive) or: [(#(160 161 167 172 184 196 218 230 231 232 233 242 243 247 248 249) includes: method primitive) or: [{250. 251. 252. 253. 570. 571} includes: method primitive]]]
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> maxTime [

	^ 100 milliSeconds
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> method: aSymbol for: anObject super: supered numArgs: numArgs [

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: anObject].
	^ lookupClass lookupSelector: aSymbol
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> popIntoReceiverVariable: offset [

	(tempObjects includes: (SBExampleWatch report: currentContext for: 1050030447) receiver) ifFalse: [
		self currentContextIsWhiteListed ifFalse: [^ SBExampleWatch report: nil for: 605804066]].
	^ currentContext popIntoReceiverVariable: offset
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> send: selector super: supered numArgs: numArgs [

	| res receiver lookupClass |
	receiver := currentContext at: currentContext stackPtr - numArgs.
	(self method: selector for: receiver super: supered numArgs: numArgs) ifNotNil: [:method |
		method primitive = 117 ifTrue: [ | module call |
			(self isAllowedExternalCall: method) ifFalse: [^ SBExampleWatch report: nil for: 786950473]].
		(self isBlacklistedPrimitive: method) ifTrue: [^ SBExampleWatch report: nil for: 952327429].
		(self createsObject: method) ifTrue: [
			res := super send: selector super: supered numArgs: numArgs.
			tempObjects add: res top.
			^ res].
		(self causesSideEffect: method) ifTrue: [
			currentContext.
			(tempObjects includes: receiver) ifFalse: [^ SBExampleWatch report: nil for: 923157428]].
		^ super send: selector super: supered numArgs: numArgs].
	^ super send: selector super: supered numArgs: numArgs
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> simulate: aBlock [

	| simulationContext startTime |
	SBExample self: [SBSandboxSimulator new] args: [{[#(12 2 2.0)]}] label: 'array'.
	SBExample self: [SBSandboxSimulator new] args: [{[TextMorph new]}] label: 'text morph'.
	SBExample self: [SBSandboxSimulator new] args: [{[Time current]}] label: 'time'.
	SBExample self: [SBSandboxSimulator new] args: [{[10000 factorial]}] label: 'slow'.
	SBExample self: [SBSandboxSimulator new] args: [{[4 + 5]}] label: 'numbers'.
	SBExample self: [SBSandboxSimulator new] args: [{[ActiveWorld addMorph: Morph new]}] label: 'morph'.
	SBExample self: [SBSandboxSimulator new] args: [{[UIManager default]}] label: 'ui manager'.
	startTime := DateAndTime now.
	aBlock hasMethodReturn ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	simulationContext := thisContext.
	currentContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		currentContext := currentContext interpretNextInstructionFor: self.
		(DateAndTime now - startTime) > self maxTime ifTrue: [^ SBExampleWatch report: nil for: 570645926]].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]
]

{ #category : #'as yet unclassified' }
SBSandboxSimulator >> storeIntoReceiverVariable: offset [

	(tempObjects includes: currentContext receiver) ifFalse: [^ SBExampleWatch report: nil for: 35168154].
	^ super storeIntoReceiverVariable: offset
]
