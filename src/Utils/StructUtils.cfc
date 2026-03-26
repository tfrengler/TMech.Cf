/**
 * @hint Component representing Selenium. Serves as a helper interface for resolving and getting references to underlying Selenium Java classes, types, enums etc.
 */
component displayname="StructUtils" modifier="final" output="false" accessors="false" persistent="true" {

    public boolean function areEqual(required struct first, required struct second) {
        return _compareStructs(arguments.first, arguments.second, [], 32);
    }

    private boolean function _compareStructs(required struct first, required struct second, required array listOfPreviousStructs, required numeric recursionsLeft) {

        arguments.listOfPreviousStructs.append(arguments.first);
        arguments.listOfPreviousStructs.append(arguments.second);

        if (arguments.first === arguments.second) {
            return true;
        }

        var keysOfFirst = structKeyArray(arguments.first);
        var keysOfSecond = structKeyArray(arguments.second);
        var typeOf = new Utils.ObjectUtils().typeOf;

        if (keysOfFirst.len() != keysOfSecond.len()) {
            throw("Structs have different amount of keys (first: #keysOfFirst.len()# vs second: #keysOfSecond.len()#)");
        }

        for(var item in keysOfFirst) {
            if (arrayFind(keysOfSecond, item) == 0) {
                throw(message="Struct does not contain key: #item# (keys of first: #arrayToList(keysOfFirst)# | keys of second: #arrayToList(keysOfSecond)#)");
                return false;
            }
        }

        for(var item in arguments.first) {

            var itemFirst = arguments.first[item];
            var itemSecond = arguments.second[item];

            var typeOfFirst = typeOf(itemFirst);
            var typeOfSecond = typeOf(itemSecond);

            if (typeOfFirst != typeOfSecond) {
                throw("Item #item# is not the same type (Expected: #typeOfFirst# vs actual: #typeOfSecond#)");
            }

            if (typeOfFirst == "null" && typeOfSecond == "null") {
                continue;
            }

            if (isSimpleValue(arguments.first[item])) {
                if (itemFirst !== itemSecond) {
                    throw(message="Item '#item#' is not the same value. Expected: #itemFirst# (#typeOf(itemFirst)#) vs actual: #itemSecond# (#typeOf(itemSecond)#)");
                }
                continue;
            }
            // Both structs are the same
            if (itemFirst === itemSecond) {
                writeDump("Structs in #item# refer to the same struct");
                continue;
            }
            // Need to compare tuples. We want to know if the combo of itemFirst and itemSecond have been compared before
            // in order to avoid infinite recursion
            if (typeOfFirst == "struct") {

                if (arraySome(arguments.listOfPreviousStructs, (st) => arguments.st === itemFirst)) {
                    continue;
                }

                if (arguments.recursionsLeft == 0) {
                    throw("Reached max recursion depth of nested structs");
                }

                writeDump("Recurse: #item#");
                _compareStructs(itemFirst, itemSecond, arguments.listOfPreviousStructs, arguments.recursionsLeft - 1);
            }
        }

        return true;
    }

    /*
    dateNow = now();

    testStruct1 = {
        "string": "a string",
        "integer": 42,
        "float": 84.42,
        "bool": true,
        "date": dateNow,
        "array": [1,2,3],
        "struct": {a=1,b=2,c=3},
        "query": queryNew("col1,col2"),
        "func": (x) => x + 2,
        "xml": xmlNew(),
        "null": nullValue(),
        "cfc": new DebugCFC(),
        "java": createObject("java", "java.lang.StringBuilder").init("java-string"),
        "file": fileOpen("Debug.cfm"),
        "binary": fileReadBinary("Debug.cfm"),
        // "TESTY": 1
    }

    testStruct2 = {
        "string": "a string",
        "integer": 42,
        "float": 84.42,
        "bool": true,
        "date": dateNow,
        "array": [1,2,3],
        // "struct": {a=1,b=2,c=3},
        "struct": {a=1,b=2,c=3},
        "query": queryNew("col1,col2"),
        "func": (x) => x + 2,
        "xml": xmlNew(),
        "null": nullValue(),
        "cfc": new DebugCFC(),
        "java": createObject("java", "java.lang.StringBuilder").init("java-string"),
        "file": fileOpen("Debug.cfm"),
        "binary": fileReadBinary("Debug.cfm")
    }

    testArray1 = [1,2,3];
    testArray2 = [1,2,3];
    testArray3 = testArray1;


    st1 = {
        a:1,b=2,c=3,
        d: {e=4, f=5, g=5},
        // x: st1
    }

    st2 = {
        a:1,b=2,c=3,
        d: {e=4, f=5, g=5},
        // x: st2
    }

    st1.d.x = st1;
    st2.d.x = st2;
    st1.y = {x=1,y=2};
    st2.y = st2;
    */
}
