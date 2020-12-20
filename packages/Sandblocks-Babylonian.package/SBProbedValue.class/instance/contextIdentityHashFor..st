as yet unclassified
contextIdentityHashFor: aMethod

	^ frames detect: [:frame | frame method = aMethod] ifFound: [:frame | frame contextIdentityHash]