as yet unclassified
hash

	^ (self methodClass hash bitXor: (self selector hash bitXor: self pc hash)) hashMultiply