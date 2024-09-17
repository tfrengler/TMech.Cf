/**
 * Quick and dirty assertion library to assist in unit testing. These are simple, static non-configurable assertions with no support for compound validations.
 */
component displayname="Assert" modifier="final" output="false" accessors="false" persistent="true" {

    // BOOLEAN

    public static void function IsTrue(required boolean value) {
        if (!arguments.value) {
            throw("Assertion failed! Expected value to true but found false", "TMech.Cf.Assertion");
        }
    }

    public static void function IsFalse(required boolean value) {
        if (arguments.value) {
            throw("Assertion failed! Expected value to false but found true", "TMech.Cf.Assertion");
        }
    }

    // STRINGS

    public static void function StringEqual(required string actual, required string expected) {
        if ( compare(arguments.actual, arguments.expected) != 0 ) {
            throw("Assertion failed! Expected string #arguments.actual# to be equal to #arguments.expected# (case sensitive)", "TMech.Cf.Assertion");
        }
    }

    public static void function StringEqualNoCase(required string actual, required string expected) {
        if ( compareNoCase(arguments.actual, arguments.expected) != 0 ) {
            throw("Assertion failed! Expected string #arguments.actual# to be equal to #arguments.expected# (case insensitive)", "TMech.Cf.Assertion");
        }
    }

    public static void function StringNotEmpty(required string theString, boolean trimFirst = false) {
        if (arguments.trimFirst) {
            arguments.theString = arguments.theString.trim();
        }

        if ( arguments.theString.len() == 0 ) {
            throw("Assertion failed! Expected string #arguments.theString# to not be empty", "TMech.Cf.Assertion");
        }
    }

    public static void function StringEmpty(required string theString, boolean trimFirst = false) {
        if (arguments.trimFirst) {
            arguments.theString = arguments.theString.trim();
        }

        if ( arguments.theString.len() != 0 ) {
            throw("Assertion failed! Expected string #arguments.theString# to be empty but found: #arguments.theString#", "TMech.Cf.Assertion");
        }
    }

    // NUMBERS

    public static void function NumberEqualTo(required numeric actual, required numeric expected) {
        if (arguments.actual != arguments.expected) {
            throw("Assertion failed! Expected numeric value #arguments.actual# to be equal to #arguments.expected#", "TMech.Cf.Assertion");
        }
    }

    public static void function NumberGreaterThan(required numeric first, required numeric second) {
        if (arguments.first > arguments.second) {
            throw("Assertion failed! Expected numeric value #arguments.first# to be greater than #arguments.second#", "TMech.Cf.Assertion");
        }
    }

    public static void function NumberLessThan(required numeric first, required numeric second) {
        if (arguments.first < arguments.second) {
            throw("Assertion failed! Expected numeric value #arguments.first# to be less than #arguments.second#", "TMech.Cf.Assertion");
        }
    }

    // EXCEPTIONS

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

    // IO (files and dirs)

    public static void function DirExists(required string dir) {
        if (!directoryExists(arguments.dir)) {
            throw("Assertion failed! Expected directory to exist but it does not: #arguments.dir#", "TMech.Cf.Assertion");
        }
    }

    public static void function DirNotExists(required string dir) {
        if (directoryExists(arguments.dir)) {
            throw("Assertion failed! Expected directory to not exist but it does not: #arguments.dir#", "TMech.Cf.Assertion");
        }
    }

    public static void function DirEmpty(required string dir) {
        if (!directoryExists(arguments.dir)) {
            throw("Assertion failed! Cannot determine if dir is empty because it does not exist: #arguments.dir#", "TMech.Cf.Assertion");
        }

        var DirContentCount = directoryList(path=arguments.dir, recurse=false, listInfo="query", type="all").recordCount;
        if (DirContentCount == 0) {
            throw("Assertion failed! Expected #arguments.dir# to not be empty but it is", "TMech.Cf.Assertion");
        }
    }

    public static void function DirNotEmpty(required string dir) {
        if (!directoryExists(arguments.dir)) {
            throw("Assertion failed! Cannot determine if dir is empty because it does not exist: #arguments.dir#", "TMech.Cf.Assertion");
        }

        var DirContentCount = directoryList(path=arguments.dir, recurse=false, listInfo="query", type="all").recordCount;
        if (DirContentCount > 0) {
            throw("Assertion failed! Expected #arguments.dir# to be empty but it is not (has #DirContentCount# files/subdirs)", "TMech.Cf.Assertion");
        }
    }

    public static void function FileExists(required string file) {
        if (!fileExists(arguments.file)) {
            throw("Assertion failed! Expected file to exist but it does not: #arguments.file#", "TMech.Cf.Assertion");
        }
    }

    public static void function FileNotExists(required string file) {
        if (fileExists(arguments.file)) {
            throw("Assertion failed! Expected file to not exist but it does not: #arguments.file#", "TMech.Cf.Assertion");
        }
    }
}