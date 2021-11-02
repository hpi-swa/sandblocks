Class {
	#name : #SBTypeCollectSimulator,
	#superclass : #SimulationContext,
	#type : #variable,
	#instVars : [
		'methodMap',
		'topContext'
	],
	#category : #'Sandblocks-Simulation'
}

{ #category : #'instruction decoding' }
SBTypeCollectSimulator >> doPrimitive: primitiveIndex method: meth receiver: rcvr args: arguments [

	| result |
	result := super doPrimitive: primitiveIndex method: meth receiver: rcvr args: arguments.
	(self isDead not and: [self stackPtr > 0]) ifTrue: [self reportTypeInfo: self top at: self].
	
	"value:... block closure invocation"
	((primitiveIndex between: 201 and: 222)
	 and: [(self objectClass: receiver) includesBehavior: BlockClosure]) ifTrue: [
		result arguments withIndexDo: [:argument :index |
			self
				reportTypeInfo: argument
				at: (SBStCodeContext for: result)
				findNode: [:methodMorph | (methodMorph blockBodyForPC: result method -> result pc)
					ifNotNil: [:block | block bindings at: index]]]].
	
	^ result
]

{ #category : #'initialize-release' }
SBTypeCollectSimulator >> initializeFrom: anotherContext [

	super initializeFrom: anotherContext.
	methodMap := anotherContext methodMap.
]

{ #category : #accessing }
SBTypeCollectSimulator >> maxTime [

	^ 100 milliSeconds
]

{ #category : #accessing }
SBTypeCollectSimulator >> methodMap [

	^ methodMap
]

{ #category : #accessing }
SBTypeCollectSimulator >> methodMap: aDictionary [

	methodMap := aDictionary
]

{ #category : #private }
SBTypeCollectSimulator >> reportTypeInfo: anObject at: aContext [

	"location := (SBCodeContext for: aContext) pc: (aContext previousPc)."
	"self assert: ((InstructionStream on: aContext method) pc: pc; nextInstruction) selector = #send:super:numArgs:."
	methodMap at: aContext method sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (method blockForPC: aContext previousPc)]
]

{ #category : #private }
SBTypeCollectSimulator >> reportTypeInfo: anObject at: aContext findNode: aBlock [

	aContext method ifNotNil: [:m |
		methodMap at: m sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (aBlock value: method)]]
]

{ #category : #'instruction decoding' }
SBTypeCollectSimulator >> return: value from: aSender [

	aSender == aSender home ifTrue: ["method return"
		self reportTypeInfo: value at: self methodReturnContext sender].
	^ super return: value from: aSender
]

{ #category : #'instruction decoding' }
SBTypeCollectSimulator >> send: selector to: rcvr with: arguments lookupIn: lookupClass [

	(lookupClass lookupSelector: selector) ifNotNil: [:method |
		arguments withIndexDo: [:argument :index |
			SBStCodeContext class: lookupClass selector: selector ifValid: [:location |
				self
					reportTypeInfo: argument
					at: location
					findNode: [:methodMorph | methodMorph arguments at: index]]]].
	
	^ super send: selector to: rcvr with: arguments lookupIn: lookupClass
]
