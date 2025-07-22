component displayname="NumberConstraint" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="predicate" type="function" getter="false" setter="false";

    public NumberConstraint function Init(required function predicate) output = false {
        variables.predicate = arguments.predicate;
        return this;
    }

    public void function run(required numeric value) output = false {
        variables.predicate(arguments.value);
    }
}