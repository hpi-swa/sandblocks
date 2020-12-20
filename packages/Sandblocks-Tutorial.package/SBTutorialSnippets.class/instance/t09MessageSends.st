as yet unclassified
t09MessageSends

	SBLabel text: [
		'Change the call to a with:do: with a second array (see the statement after for a finished example).

To do so, select the `do:` and press *. Type ''with'' and press tab. Type { to create a new array.
Finally, select the block argument :num and press + to add another binding and adapt the showln:'].
	{42. 12} do: [:num | Transcript showln: num].
	
	SBLabel text: ['This could be your final result:'].
	{42. 12} with: {54. 32} do: [:num :num2 | Transcript showln: {num. num2}].
	
	SBLabel text: [
		'One final note for statements: for convenience, o and O will insert statements in the current block.
This allows you to quickly create a new statement, even when you do not have a statement selected.

For example, select the 42 and press O.'].
	^ 42 squared