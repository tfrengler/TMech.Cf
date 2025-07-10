component displayname="Assert" modifier="final" output="false" accessors="false" persistent="true"
{
    public static string function GetAssertionType() {
        return "TMech.Assertion.Failed";
    }

    public static void function ThatString(required string value, required StringConstraint constraint) output = true {
        arguments.constraint.run(value);
    }
}