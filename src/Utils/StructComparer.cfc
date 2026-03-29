/**
 * @hint Component representing Selenium. Serves as a helper interface for resolving and getting references to underlying Selenium Java classes, types, enums etc.
 */
component displayname="StructComparer" modifier="final" output="false" accessors="false" persistent="true" {

    property name="structure" type="struct" setter="false" getter="false";
    // Array of structs. Layout: { 1: first struct, 2: second struct }
    property name="previouslyComparedStructs" type="array" setter="false" getter="false";
    property name="maxDepth" type="numeric" setter="false" getter="false";
    property name="currentDepth" type="numeric" setter="false" getter="false";
    property name="typeOf" type="function" setter="false" getter="false";

    public StructComparer function Init(required struct structure) output = false {

        variables.previouslyComparedStructs = [];
        variables.structure = arguments.structure;
        variables.maxDepth = 32;
        variables.currentDepth = 1;
        variables.typeOf = new Utils.ObjectUtils().typeOf;

        return this;
    }

    public boolean function isSimilarTo(required struct otherStruct) output = false {
        return compareStructs(variables.structure, arguments.otherStruct);
    }

    private boolean function compareStructs(required struct first, required struct second) output = false {

        variables.previouslyComparedStructs.append({1: arguments.first, 2: arguments.second});

        if (arguments.first === arguments.second) {
            writeDump("Structs are the same");
            return true;
        }

        var keysOfFirst = structKeyArray(arguments.first);
        var keysOfSecond = structKeyArray(arguments.second);

        if (keysOfFirst.len() != keysOfSecond.len()) {
            writeDump("Structs have different amount of keys (first: #keysOfFirst.len()# vs second: #keysOfSecond.len()#)");
            return false;
        }

        for(var key in keysOfFirst) {
            if (arrayFind(keysOfSecond, key) == 0) {
                writeDump("Struct does not contain key: #key# (keys of first: #arrayToList(keysOfFirst)# | keys of second: #arrayToList(keysOfSecond)#)");
                return false;
            }
        }

        for(var item in keysOfFirst) {

            var itemFirst = arguments.first[item];
            var itemSecond = arguments.second[item];

            var typeOfFirst = typeOf(itemFirst);
            var typeOfSecond = typeOf(itemSecond);

            if (!compareValues(itemFirst, itemSecond, typeOfFirst, typeOfSecond)) {
                writeDump("Values in key '#item#' are not equal"); //"Expected: #itemFirst# (#typeOf(itemFirst)#) vs actual: #itemSecond# (#typeOf(itemSecond)#)");
                return false;
            }
        }

        return true;
    }

    private boolean function recurseOnStruct(required any first, required any second) output = false {

        var args = arguments;
        if (variables.currentDepth > variables.maxDepth) {
            throw("Reached max recursion depth of nested structs (#variables.maxDepth#)");
        }

        var itemsAlreadyCompared = arraySome(variables.previouslyComparedStructs, (st) => {
            return arguments.st.1 === args.First && arguments.st.2 === args.Second;
        });

        if (itemsAlreadyCompared) {
            writeDump("Structs already compared");
            return false;
        }

        writeDump("Recursing into struct");
        variables.currentDepth++;
        return compareStructs(arguments.first, arguments.second);
    }

    private boolean function sequenceCompareArrays(required array first, required array second) output = false {

        if (arguments.first.len() != arguments.second.len()) {
            writeDump("Arrays do not have the same length (#first.len()# vs #second.len()#)");
            return false;
        }

        for(var index = 1; index <= arguments.first.len(); index++) {

            var itemFirst = arguments.first[index];
            var itemSecond = arguments.second[index];

            if (!compareValues(itemFirst, itemSecond, variables.typeof(itemFirst), variables.typeof(itemSecond)))
            {
                return false;
            }
        }

        return true;
    }

    private boolean function compareValues(
        required any first,
        required any second,
        required string typeOfFirst,
        required string typeOfSecond) output = false
    {

        if (arguments.typeOfFirst != typeOfSecond) {
            writeDump("Values are not the same type (Expected: #arguments.typeOfFirst# vs actual: #typeOfSecond#)");
            return false;
        }

        // Can't do value or reference comparison here
        if (arguments.typeOfFirst == "null" && typeOfSecond == "null") {
            return true;
        }

        if (isSimpleValue(arguments.first)) {
            if (arguments.first !== arguments.second) {
                writeDump("Values are not the same. Expected: #arguments.first# (#arguments.typeOfFirst#) vs actual: #arguments.second# (#arguments.typeOfSecond#)");
                return false;
            }
            writeDump("Values are the same. Expected: #arguments.first# (#arguments.typeOfFirst#) vs actual: #arguments.second# (#arguments.typeOfSecond#)");
        }

        if (arguments.typeOfFirst == "struct") {
            writeDump("Value is struct. Potential recursion");
            return recurseOnStruct(arguments.first, arguments.second);
        }

        if (arguments.typeOfFirst == "array") {
            writeDump("Comparing arrays (#variables.currentDepth#)");
            var arraysEqual = sequenceCompareArrays(arguments.first, arguments.second);
            writeDump("Arrays are equal? #arraysEqual#");
            return arraysEqual;
        }

        return true;
    }

    /*
        TODO:
            Default value comparison is done on both type and value. Make it possible to allow for coercion.

    */

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
    */
}
