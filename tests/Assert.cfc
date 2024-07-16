/**
 * Quick and dirty assertion library to assist in unit testing
 */
component displayname="Assert" modifier="final" output="false" accessors="false" persistent="true" {

    // BOOLEAN

    public static void function IsTrue(required boolean value) {
        if (!arguments.value) {
            throw("Assertion failed! Expected value to true but found false");
        }
    }

    public static void function IsFalse(required boolean value) {
        if (arguments.value) {
            throw("Assertion failed! Expected value to false but found true");
        }
    }

    // STRINGS

    public static void function StringEqual(required string actual, required string expected) {
        if ( compare(arguments.actual, arguments.expected) != 0 ) {
            throw("Assertion failed! Expected string #arguments.actual# to be equal to #arguments.expected# (case sensitive)");
        }
    }

    public static void function StringEqualNoCase(required string actual, required string expected) {
        if ( compareNoCase(arguments.actual, arguments.expected) != 0 ) {
            throw("Assertion failed! Expected string #arguments.actual# to be equal to #arguments.expected# (case insensitive)");
        }
    }

    // NUMBERS

    public static void function NumberEqualTo(required numeric actual, required numeric expected) {
        if (arguments.actual != arguments.expected) {
            throw("Assertion failed! Expected numeric value #arguments.actual# to be equal to #arguments.expected#");
        }
    }

    public static void function NumberGreaterThan(required numeric first, required numeric second) {
        if (arguments.first > arguments.second) {
            throw("Assertion failed! Expected numeric value #arguments.first# to be greater than #arguments.second#");
        }
    }

    public static void function NumberLessThan(required numeric first, required numeric second) {
        if (arguments.first < arguments.second) {
            throw("Assertion failed! Expected numeric value #arguments.first# to be less than #arguments.second#");
        }
    }

    // OTHER

    public static void function Throws(required function functionThatThrows, string exceptionType) {

        var TheException = 0;
        var ThrewException = false;

        try {
            arguments.functionThatThrows();
        }
        catch (any exception) {
            ThrewException = true;
            TheException = exception;
        }

        if (!ThrewException) {
            throw("Assertion failed! Expected function to throw an exception but it did not", "TMech.Cf.Assertion");
        }

        if (!structKeyExists(arguments, "exceptionType")) {
            return;
        }

        var ExceptionTypeName = TheException.type;
        var ExpectedExpectionTypeName = arguments.exceptionType.trim();

        if (ExceptionTypeName != ExpectedExpectionTypeName) {
            throw("Assertion failed! Expected function to throw an exception of type #arguments.exceptionType# but instead found #ExceptionTypeName#", "TMech.Cf.Assertion");
        }
    }

    public static void function DoesNotThrow(required function functionThatShouldNotThrow) {

        var TheException = 0;
        var ThrewException = false;

        try {
            arguments.functionThatShouldNotThrow();
        }
        catch (any exception) {
            ThrewException = true;
            TheException = exception;
        }

        if (ThrewException) {
            throw("Assertion failed! Expected function to not throw an exception but it did: #TheException.message# (type: #TheException.type#)", "TMech.Cf.Assertion");
        }
    }
}