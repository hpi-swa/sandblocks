as yet unclassified
valid

	| stream |
	SBExample self: [SBNumber new contents: '43a'] args: [{}] label: 'invalid'.
	SBExample self: [SBNumber new contents: '43'] args: [{}] label: 'valid'.
	stream := self contents readStream.
	[
		(ExtendedNumberParser on: stream) nextNumber.
		stream position = self contents size ifFalse: [^ false]] on: NumberParserError do: [^ false].
	^ true