as yet unclassified
guessClassExpensive

	^ self guessedClass ifNil: [[(SBSandboxSimulator new simulate: [self evaluate]) ifNotNil: #class] on: Error do: [nil]]