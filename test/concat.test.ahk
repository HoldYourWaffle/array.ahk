assert.label("concat")
arrays := [[1,2,3]
	, [4,5,6]
	, [7,8,9]]


assert.label("concat - Combine empty array and non empty array")
assert.test([].concat(arrays[1]), [1,2,3])

assert.label("concat - Combine two non empty arrays")
assert.test(arrays[1].concat(arrays[2]), [1,2,3,4,5,6])

assert.label("concat - Combine three non empty arrays")
assert.test([].concat(arrays*), [1,2,3,4,5,6,7,8,9])


assert.label("concat - empty array in, empty array out")
assert.test([].concat([]), [])
assert.test([].concat(), [])

assert.label("concat - plain values as arguments")
assert.test([].concat("Bill", "Ted"), ["Bill", "Ted"])
assert.test(["Bill"].concat("Ted"), ["Bill", "Ted"])


assert.label("concat - plain values and arrays")
assert.test([].concat(["Bill", "Ted"], "Socrates", ["Lincoln", "Joan of Arc"]), ["Bill", "Ted", "Socrates", "Lincoln", "Joan of Arc"])

; sparse arrays / associative objects
arr := []
arr[1] := ""
arr[2] := "Bill"
arr[3] := "Ted"

arr2 := []
arr2[1] := ""
arr2[2] := "Socrates"
arr2[3] := "Lincoln"

assert.label("concat - sparse array")
assert.test([].concat(arr), ["", "Bill", "Ted"])
assert.test(arr.concat("Socrates"), ["", "Bill", "Ted", "Socrates"])
assert.test(arr.concat(arr2), ["", "Bill", "Ted", "", "Socrates", "Lincoln"])
