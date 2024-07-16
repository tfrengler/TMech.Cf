/**
 * Component representing a version in the form a major and minor revision number.
 * An instance can be created via the constructor or parsed from a string using FromString().
 * Contains methods for comparing two instances to determine whether they are greater than, lesser than or equal to each other.
 */
component displayname="Version" modifier="final" output="false" accessors="false" persistent="true"
{
    // PUBLIC
    property name="Major"           type="numeric" getter="true" setter="false";
    property name="Minor"           type="numeric" getter="true" setter="false";

    public Version function Init(required numeric major, required numeric minor) {
        if (arguments.major < 0) {
            arguments.major = 0;
        }
        if (arguments.minor < 0) {
            arguments.minor = 0;
        }

        variables.Major = arguments.major;
        variables.Minor = arguments.minor;

        return this;
    }

    public numeric function CompareTo(required Version other) {
        return Version::Compare(this, arguments.other);
    }

    /* STATIC METHODS */

    // 1  = x is greater than y
    // 0  = x and y are equal
    // -1 = y is greater than x
    public static numeric function Compare(required Version x, required Version y) {

        var xMajor = x.getMajor();
        var xMinor = x.getMinor();
        var yMajor = y.getMajor();
        var yMinor = y.getMinor();

        if (xMajor > yMajor || (xMajor == yMajor && xMinor > yMinor)) return 1;
        if (xMajor < yMajor || (xMajor == yMajor && xMinor < yMinor)) return -1;

        return 0;
    }

    /**
     * Parses a version string (dot-delimited list of numbers) into a Version-instance.
     *
     * @input The string to parse into a Version-instance. If empty (or the string is malformed) then a Version-instance with 0 as minor and major revision is returned.
     */
    public static Version function FromString(required string input) {

        if (arguments.input.trim().len() == 0) {
            return new Version(0,0);
        }

        var InputString = arguments.input.trim();
        // Because of Geckodriver whose version string has a leading 'v'
        if (left(InputString, 1) == "v") {
            InputString = removeChars(InputString, 1, 1);
        }

        // split is a Java function that returns a Java-array (https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#split-java.lang.String-)
        var VersionParts = InputString.split("\.");
        if (arrayLen(VersionParts) == 1) {
            return new Version(0,0);
        }

        var Major = val(VersionParts[1]);
        VersionParts[1] = "0";

        // Yes, we are calling arrayMap first to convert the string-elements into numeric values.
        // I'd rather not rely on Coldfusion to coerce the values under the hood to numbers.
        var Minor = arraySum(arrayMap(VersionParts, (string element) => {
            return val(arguments.element);
        }));

        return new Version(Major, Minor);
    }
}