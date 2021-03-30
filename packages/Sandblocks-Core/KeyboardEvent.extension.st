Extension { #name : #KeyboardEvent }

{ #category : #'*Sandblocks-Core' }
KeyboardEvent >> sbStoreString [

	^ '{1} setType: {2} buttons: {3} position: {4} keyValue: {5} hand: nil stamp: nil' format: {self className. type storeString. buttons storeString. position storeString. keyValue storeString}
]
