assert.label("join")

array := [1,2,3,4,5]


assert.label("join - Join elements with newlines")
assert.test("1`n2`n3`n4`n5", array.join("`n"))

assert.label("join - Join elements with commas")
assert.test("1,2,3,4,5", array.join())
