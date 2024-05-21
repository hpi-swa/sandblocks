Class {
	#name : #RuntimeComparisons,
	#superclass : #Object,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
RuntimeComparisons >> main [

	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: 'example'.
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	[workload do: [:aNumber | set add: aNumber]] timeToRun
]
