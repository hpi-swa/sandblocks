input
labelString

	^ 'Sandblocks Editor', (workspace ifNotNil: [:w | ' - ', w name] ifNil: [''])