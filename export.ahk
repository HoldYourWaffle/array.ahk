; Apply "native" support, redefines Array() to add custom _Array base object
; Array(prms*) {
	; Since prms is already an array of the parameters, just give it a
	; new base object and return it. Using array method, _Array.__New()
	; is not called and any instance variables are not initialized.
	; prms.base := _Array
	; return prms
; }


; Define the base class.
class Arrays {

	static concat(arrays*) {

		result := []

		for key, array in arrays {
			if (IsObject(array)) {
				for key2, element in array {
					result.push(element)
				}
			} else {
				result.push(array)
			}
		}
		return result
	}


	static every(array, callback) {

		for index, element in array
			if !callback.Call(element, index, array)
				return false

		return true
	}


	static fill(array, value, start:=0, end:=0) {

		len := array.Length

		; START: Adjust 1 based index, check signage, set defaults
		if (start > 0)
			begin := start - 1 ; Include starting index going forward
		else if (start < 0)
			begin := len + start ; Count backwards from end
		else
			begin := start


		; END: Check signage and set defaults
		if (end > 0)
			last := end
		else if (end < 0)
			last := len + end ; Count backwards from end
		else
			last := len


		loop (last - begin)
			array[begin + A_Index] := value

		return array
	}


	static filter(array, callback) {

		result := []

		for index, element in array
			if (callback.Call(element, index, array))
				result.push(element)

		return result
	}


	; Modified to return "" instead of 'undefined'
	static find(array, callback) {

		for index, element in array
			if (callback.Call(element, index, array))
				return element

		return ""
	}


	static findIndex(array, callback) {

		for index, value in array
			if (callback.Call(value, index, array))
				return index

		return -1
	}



	static forEach(array, callback) {

		for index, element in array
			callback.Call(element, index, array)

		return ""
	}


	static includes(array, searchElement, fromIndex:=0) {
		return Arrays.indexOf(array, searchElement, fromIndex) > 0 ? true : false
	}


	static indexOf(array, searchElement, fromIndex:=0) {
		len := array.Length

		if (fromIndex > 0)
			start := fromIndex - 1 ; Include starting index going forward
		else if (fromIndex < 0)
			start := len + fromIndex ; Count backwards from end
		else
			start := fromIndex


		loop (len - start)
			if (array[start + A_Index] = searchElement)
				return start + A_Index

		return -1
	}


	static join(array, delim:=",") {

		result := ""

		for index, element in array
			result .= element (index < array.Length ? delim : "")

		return result
	}


	static keys(array) {

		result := []

		for key, value in array {
			result.push(key)
		}
		return result
	}


	; if the provided index is negative, the array is still searched from front to back
	; - Are we not able to return the first found starting from the back?
	static lastIndexOf(array, searchElement, fromIndex:=0) {

		len := array.Length
		foundIdx := -1

		if (fromIndex > len)
			return foundIdx

		if (fromIndex > 0)
			start := fromIndex - 1 ; Include starting index going forward
		else if (fromIndex < 0)
			start := len + fromIndex ; Count backwards from end
		else
			start := fromIndex

		loop (len - start)
			if (array[start + A_Index] = searchElement)
				foundIdx := start + A_Index

		return foundIdx
	}


	static map(array, callback) {

		result := []

		for index, element in array
			result.push(callback.Call(element, index, array))

		return result
	}


	static reduce(array, callback, initialValue:="__NULL__") {

		len := array.Length

		; initialValue not defined
		if (initialValue == "__NULL__") {

			if (len < 1) {
				; Empty array with no intial value
				return
			}
			else if (len == 1) {
				; Single item array with no initial value
				return array[1]
			}

			; Starting value is last element
			initialValue := array[1]

			; Loop n-1 times (start at 2nd element)
			iterations := len - 1

			; Set index A_Index+1 each iteration
			idxOffset := 1

		} else {
		; initialValue defined

			if (len == 0) {
				; Empty array with initial value
				return initialValue
			}

			; Loop n times (starting at 1st element)
			iterations := len

			; Set index A_Index each iteration
			idxOffset := 0
		}

		; if no initialValue is passed, use first index as starting value and reduce
		; array starting at index n+1. Otherwise, use initialValue as staring value
		; and start at arrays first index.
		Loop (iterations)
		{
			adjIndex := A_Index + idxOffset
			initialValue := callback.Call(initialValue, array[adjIndex], adjIndex, array)
		}

		return initialValue
	}


	static reduceRight(array, callback, initialValue:="__NULL__") {

		len := array.Length

		; initialValue not defined
		if (initialValue == "__NULL__") {

			if (len < 1) {
				; Empty array with no intial value
				return
			}
			else if (len == 1) {
				; Single item array with no initial value
				return array[1]
			}

			; Starting value is last element
			initialValue := array[len]

			; Loop n-1 times (starting at n-1 element)
			iterations := len - 1

			; Set index A_Index-1 each iteration
			idxOffset := 0

		} else {
		; initialValue defined

			if (len == 0)
				; Empty array with initial value
				return initialValue

			; Loop n times (start at n element)
			iterations := len

			; Set index A_Index each iteration
			idxOffset := 1
		}

		; If no initialValue is passed, use last index as starting value and reduce
		; array starting at index n-1. Otherwise, use initialValue as starting value
		; and start at arrays last index.
		Loop (iterations)
		{
			adjIndex := len - (A_Index - idxOffset)
			initialValue := callback.Call(initialValue, array[adjIndex], adjIndex, array)
		}

		return initialValue
	}


	static reverse(array) {

		len := array.Length

		Loop (len // 2)
		{
			idxFront := A_Index
			idxBack := len - (A_Index - 1)

			tmp := array[idxFront]
			array[idxFront] := array[idxBack]
			array[idxBack] := tmp
		}

		return array
	}


	static shift(array) {

		return array.RemoveAt(1)
	}


	static slice(array, start:=0, end:=0) {

		len := array.Length

		; START: Adjust 1 based index, check signage, set defaults
		if (start > 0)
			begin := start - 1 ; Include starting index going forward
		else if (start < 0)
			begin := len + start ; Count backwards from end
		else
			begin := start


		; END: Check signage and set defaults
		; MDN States: "to end (end not included)" so subtract one from end
		if (end > 0)
			last := end - 1
		else if (end < 0)
			last := len + end ; Count backwards from end
		else
			last := len


		result := []

		loop (last - begin)
			result.push(array[begin + A_Index])
		if (result.Count() == 0) {
			return ""
		}
		return result
	}


	static some(array, callback) {

		for index, value in array
			if callback.Call(value, index, array)
				return true

		return false
	}


	static sort(array, compare_fn:=0) {

		; Quicksort
		array._Call(array, compare_fn)

		return array
	}


	static splice(array, start, deleteCount:=-1, args*) {

		len := array.Length
		exiting := []

		; Determine starting index
		if (start > len)
			start := len

		if (start < 0)
			start := len + start

		; deleteCount unspecified or out of bounds, set count to start through end
		if ((deleteCount < 0) || (len <= (start + deleteCount))) {
			deleteCount := len - start + 1
		}

		; Remove elements
		Loop (deleteCount)
		{
			exiting.push(array[start])
			array.RemoveAt(start)
		}

		; Inject elements
		Loop (args.Count())
		{
			curIndex := start + (A_Index - 1)

			array.InsertAt(curIndex, args[1])
			args.removeAt(1)
		}

		return exiting
	}


	static toString(array) {
		str := ""

		for i,v in array
			str .= v (i < array.Length ? "," : "")

		return str
	}


	static unshift(array, args*) {

		for index, value in args
			array.InsertAt(A_Index, value)

		return array.Length
	}


	static values(array) {

		result := []

		for key, value in array {
			result.push(value)
		}
		return result
	}


	; Internal functions
	static _compare_alphanum(array, a, b) {
		; return 0 if a and b are the same
		; return -1 if b is "" or undefined
		; return 1 if a is greater than b
		; return -1 if a is less than b

		if (a == b) {
			return 0
		} else if (b == "" || !IsSet(b)) {
			return -1
		} else if (a > b) {
			return 1
		} else if (a < b) {
			return -1
		}
	}


	; TODO double-check _sort, _partition and _Call


	static _sort(array, compare_fn, left, right) {
		if (array.Length > 1) {
			centerIdx := Arrays._partition(array, compare_fn, left, right)
			if (left < centerIdx - 1) {
				Arrays._sort(array, compare_fn, left, centerIdx - 1)
			}
			if (centerIdx < right) {
				Arrays._sort(array, compare_fn, centerIdx, right)
			}
		}
	}


	static _partition(array, compare_fn, left, right) {
		pivot := array[floor(left + (right - left) / 2)]
		i := left
		j := right

		while (i <= j) {
			while (compare_fn.Call(array[i], pivot) < 0) { ;array[i] < pivot
				i++
			}
			while (compare_fn.Call(array[j], pivot) > 0) { ;array[j] > pivot
				j--
			}
			if (i <= j) {
				Arrays._swap(array, i, j)
				i++
				j--
			}
		}
		return i
	}


	static _swap(array, idx1, idx2) {
		tempVar := array[idx1]
		array[idx1] := array[idx2]
		array[idx2] := tempVar
	}


	; Left/Right remain from a standard implementation, but the adaption is
	; ported from JS which doesn't expose these parameters.
	;
	; To expose left/right: Call(array, compare_fn:=0, left:=0, right:=0), but
	; this would require passing a falsey value to compare_fn when only
	; positioning needs altering: Call(myArr, <false/0/"">, 2, myArr.Count())
	static _Call(array, compare_fn:=0) {
		; Default comparator
		if !(compare_fn) {
			compare_fn := objBindMethod(array, "_compare_alphanum")
		}

		; Default start/end index
		left := left ? left : 1
		right := right ? right : array.Length

		; Perform in-place sort
		Arrays._sort(array, compare_fn, left, right)

		; Return object ref for method chaining
		return array
	}


	; Redirect to newer calling standard
	static __Call(array, method, args*) {
		if (method = "")
			return array._Call(args*)
		if (IsObject(method))
			return array._Call(method, args*)
	}
}
