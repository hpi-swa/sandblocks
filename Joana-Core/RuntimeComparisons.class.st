Class {
	#name : #RuntimeComparisons,
	#superclass : #Object,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
RuntimeComparisons >> main [
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: 'example'.
	workload := SBVariant
		named: 'workload'
		associations: {
			'ordered' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			'random' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: '6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179'
		isActive: true.
	set := SBVariant
		named: 'set'
		associations: {
			'' -> [HashSet new].
			'' -> [
				CustomHashSet reserve: (SBVariant
					named: 'reserve:'
					associations: {'' -> [100]. '' -> [1000]. '' -> [10000]}
					activeIndex: 3
					id: '3c9b78de-a961-1b40-9629-2c9db7d9c24f'
					isActive: true)]}
		activeIndex: 2
		id: 'ad068d8c-76f1-6347-81f6-55d1300ca3d3'
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]
]
