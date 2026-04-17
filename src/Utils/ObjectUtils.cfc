/**
 * @hint Component representing Selenium. Serves as a helper interface for resolving and getting references to underlying Selenium Java classes, types, enums etc.
 */
component displayname="ObjectUtils" modifier="final" output="false" accessors="false" persistent="true" {

    /**
     * @hint Tests whether an object is a Java-object and optionally whether it is derived from - or is a specific - Java-object.
     *
     * @object          The object to test.
     * @javaClassName   Optional. The name of the Java-class you expect arguments.object to be.
     * @includeDerived  Optional. Determines whether javaClassName should match any derived classes as well or just the concrete class of the object itself.
     */
    public static boolean function IsJavaObject(required any object, string javaClassName = "", boolean includeDerived = true) output = false
    {
        if (isNull(arguments.object)) return false;

        if (
            isSimpleValue(arguments.object) is true ||
            isArray(arguments.object) is true
        ) {
            return false;
        }

        arguments.javaClassName = isNull(arguments.javaClassName) ? "" : trim(arguments.javaClassName);
        var metadata = getMetadata(arguments.object);
        var isJavaObject = metadata.getClass().getName() == "java.lang.Class";
        var mustBeSpecificClass = arguments.javaClassName.len() > 0;

        if (!isJavaObject) {
            return false;
        }

        if (!mustBeSpecificClass) {
            return true;
        }

        var currentJavaClass = arguments.object.getClass();
        var actualClassName = currentJavaClass.getName();

        while(true) {
            if (actualClassName == arguments.javaClassName) {
                return true;
            }

            if (!arguments.includeDerived) {
                break;
            }

            currentJavaClass = currentJavaClass.getSuperClass();

            if (isNull(currentJavaClass)) {
                return false;
            }

            actualClassName = currentJavaClass.getName();
        }

        return false;
    }

    /**
     * @hint Returns the type of a given object as a string or "UNKNOWN" if type cannot be determined:
     * String = "string" |
     * Null = "null" |
     * CFC = "full name of component" |
     * Number = "numeric" |
     * Bool = "boolean" |
     * Date = "date" |
     * Binary object = "binary" |
     * Array = "array" |
     * Function/closure/lambda = "function" |
     * File object = "file" |
     * Query = "query" |
     * XML object = "xml" |
     * Structure = "struct" |
     * Java-object = "name of Java-class"
     */
    public static string function TypeOf(required any object) output = false {

        if (isNull(arguments.object)) {
            return "null";
        }

        if (isObject(arguments.object)) {
            return getMetadata(arguments.object).name;
        }

        if (isSimpleValue(arguments.object)) {

            var javaType = arguments.object.getClass().getName();
            switch (javaType) {
                case "java.lang.String":
                    return "string";
                    break;

                case "java.lang.Long":
                case "java.lang.Double":
                case "java.math.BigDecimal":
                    return "numeric";
                    break;

                case "java.lang.Boolean":
                    return "boolean";
                    break;

                case "lucee.runtime.type.dt.DateTimeImpl":
                    return "date";
                    break;

                default:
                    throw("Unknown simple type");
            }
        }

        if (isBinary(arguments.object)) {
            return "binary";
        }

        if (isArray(arguments.object)) {
            return "array";
        }

        if (isCustomFunction(arguments.object)) {
            return "function";
        }

        if (isFileObject(arguments.object)) {
            return "file";
        }

        if (isQuery(arguments.object)) {
            return "query";
        }

        var javaType = arguments.object.getClass().getName();

        if (left(javaType, 7) == "java.") {
            return javaType;
        }

        if (javaType == "lucee.runtime.text.xml.struct.XMLDocumentStruct") {
            return "xml";
        }

        if (isStruct(arguments.object)) {
            return "struct";
        }

        return "UNKNOWN";
    }
}
