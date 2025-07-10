component displayname="StringConstraint" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="predicate" type="function" getter="false" setter="false";

    public StringConstraint function Init(required function predicate) output = false {
        variables.predicate = arguments.predicate;
        return this;
    }

    public void function run(required string value) output = false {
        variables.predicate(arguments.value);
    }
}