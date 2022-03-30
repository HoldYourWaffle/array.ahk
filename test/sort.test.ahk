assert.label("sort")
StringCaseSense, On


; test subgroup 1: basic arrays
string_array := ["Delta","alpha","delta","Beta","Charlie","beta","Alpha","charlie"]
number_array := [11,9,5,10,1,6,3,4,7,8,2]
assert_strings := ["Alpha","Beta","Charlie","Delta","alpha","beta","charlie","delta"]
folders_array := ["Folder 9", "Folder 8", "Folder 11", "Folder 10"]

assert.label("sort - String array")
assert.test(string_array.sort(), assert_strings)

assert.label("sort - Number array")
assert.test(number_array.sort(), [1,2,3,4,5,6,7,8,9,10,11])

assert.label("sort - basic array with blank values")
assert.test([40, 100, 1, "", "", 5, 25, 10, ""].sort(), [1, 5, 10, 25, 40, 100, "", "", ""])

; test group 2: complex arrays (objects)
complex_array := [{"symbol": "Delta", "morse": "-***"}
	, {"symbol": "alpha", "morse": "*-"}
	, {"symbol": "delta", "morse": "-**"}
	, {"symbol": "Beta", "morse": "-***"}
	, {"symbol": "Charlie", "morse": "-*-*"}
	, {"symbol": "beta", "morse": "-***"}
	, {"symbol": "Alpha", "morse": "*-"}
	, {"symbol": "charlie", "morse": "-*-*"}]

accessor_fn := func("objProp_get").bind("symbol")
sorting_fn := func("complex_sort").bind(accessor_fn)
complex_array.sort(sorting_fn)

assert.label("sort - Using accessor function with complex arrays: key='symbol'")
assert.test(complex_array.map(accessor_fn), assert_strings)

accessor_fn := func("objProp_get").bind("morse")
assert_morse := ["*-","-***","-*-*","-***","*-","-***","-*-*","-**"]

assert.label("sort - Using accessor function with complex arrays: key='morse'")
assert.test(complex_array.map(accessor_fn), assert_morse)

assert.label("sort - compareFunction")
assert.test(folders_array.sort(func("fn_digitSort")), ["Folder 8", "Folder 9", "Folder 10", "Folder 11"])
assert.test([40, 100, 1, 5, 25, 10].sort(func("myFunction")), [1, 5, 10, 25, 40, 100])

; functions
fn_digitSort(param1, param2)
{
	justNumbers1 := RegExReplace(param1, "\D+", "")
	justNumbers2 := RegExReplace(param2, "\D+", "")
	if (justNumbers1 < justNumbers2) {
		return -1
	}
	if (justNumbers1 > justNumbers2) {
		return 1
	}
	return 0
}

myFunction(a, b) {
	if (a == b) {
		return 0
	}
	if (a > b) {
		return 10
	}
	return -1000
}
