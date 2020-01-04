as yet unclassified
characterFromStrokes: aCollection points: aPointCollection

	| seq |
	seq := aCollection collect: #first as: String.
	
	(seq matchesRegex: 'r') ifTrue: [^ Character space].
	(seq matchesRegex: 'l') ifTrue: [^ Character backspace].
	
	(seq matchesRegex: 'ur?dl?r?') ifTrue: [^ $A].
	(seq matchesRegex: 'durdl?rd?l') ifTrue: [^ $B].
	(seq matchesRegex: 'u?ldru?') ifTrue: [^ $C].
	(seq matchesRegex: 'dur?dl') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.7 of: aPointCollection) ifTrue: [$P] ifFalse: [$D]].
	(seq matchesRegex: 'ld?r?l?d?r') ifTrue: [^ $E].
	(seq matchesRegex: 'lr?d') ifTrue: [^ $F].
	(seq matchesRegex: 'l?drul?rd?') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.2 of: aPointCollection) ifTrue: [$Q] ifFalse: [$G]].
	(seq matchesRegex: 'dr?u?r?d') ifTrue: [^ $H].
	(seq matchesRegex: 'd') ifTrue: [^ $I].
	(seq matchesRegex: 'dl') ifTrue: [^ $J].
	(seq matchesRegex: 'l?dlurdr?') ifTrue: [^ $K].
	(seq matchesRegex: 'dr') ifTrue: [
		^ (aPointCollection last y > (self height * 0.6)) ifTrue: [$L] ifFalse: [$4]]. " potentially wonky, maybe relative? "
	(seq matchesRegex: 'ur?dr?u?r?d') ifTrue: [^ $M].
	(seq matchesRegex: 'ur?dr?u') ifTrue: [^ $N].
	(seq matchesRegex: 'l?drul') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.3 of: aPointCollection) ifTrue: [$O] ifFalse: [$6]].
	(seq matchesRegex: 'dur?dl?d?r?') ifTrue: [^ $R].
	" disambiguate against 8 by checking that we ended in a low area "
	((seq matchesRegex: 'ld?r?d?lu?r?') and: [(self point: aPointCollection last inUpper: 0.3 of: aPointCollection) not]) ifTrue: [^ $S].
	(seq matchesRegex: 'rd') ifTrue: [
		^ (self point: aPointCollection last inLeft: 0.6 of: aPointCollection) ifTrue: [$7] ifFalse: [$T]].
	(seq matchesRegex: 'drud?') ifTrue: [^ $U].
	(seq matchesRegex: 'dur?') ifTrue: [^ $V].
	(seq matchesRegex: 'dr?u?dr?u') ifTrue: [^ $W].
	(seq matchesRegex: 'dlur?') ifTrue: [^ $X].
	(seq matchesRegex: 'dru?d?l?ur?') ifTrue: [^ $Y].
	(seq matchesRegex: 'rl?dl?d?r') ifTrue: [^ $Z].
	
	(seq matchesRegex: 'rdlur') ifTrue: [^ $0].
	(seq matchesRegex: 'u') ifTrue: [^ $1].
	(seq matchesRegex: 'urdl?d?r') ifTrue: [^ $2].
	(seq matchesRegex: 'u?rdl?d?rdlu?') ifTrue: [^ $3].
	(seq matchesRegex: 'drdlu?') ifTrue: [^ $5].
	(seq matchesRegex: 'u?l?dr?d?lur?u?l?') ifTrue: [^ $8].
	(seq matchesRegex: 'ldrudl?u?r?') ifTrue: [^ $9].
	
	^ nil