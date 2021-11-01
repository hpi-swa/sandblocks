Class {
	#name : #SBStReachabilitySimulator,
	#superclass : #SimulationContext,
	#type : #variable,
	#instVars : [
		'store'
	],
	#category : #'Sandblocks-Simulation'
}

{ #category : #'initialize-release' }
SBStReachabilitySimulator >> initializeFrom: anotherContext [

	super initializeFrom: anotherContext.
	store := anotherContext store.
]

{ #category : #private }
SBStReachabilitySimulator >> report [

	store report: self method pc: self pc.
]

{ #category : #'system simulation' }
SBStReachabilitySimulator >> step [

	self report.
	^ super step
]

{ #category : #accessing }
SBStReachabilitySimulator >> store [

	^ store
]

{ #category : #accessing }
SBStReachabilitySimulator >> store: aColorPolicy [

	store := aColorPolicy
]
