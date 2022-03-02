Extension { #name : #TestResult }

{ #category : #'*Sandblocks-Babylonian-accessing' }
TestResult >> sandblocksAddError: aTestCase [

	^ errors add: aTestCase
]

{ #category : #'*Sandblocks-Babylonian-accessing' }
TestResult >> sandblocksAddFailure: aTestCase [

	^ failures add: aTestCase
]

{ #category : #'*Sandblocks-Babylonian-accessing' }
TestResult >> sandblocksAddPass: aTestCase [

	^ passed add: aTestCase
]
