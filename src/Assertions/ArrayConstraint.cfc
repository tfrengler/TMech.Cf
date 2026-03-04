component displayname="ArrayConstraint" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="predicate" type="function" getter="false" setter="false";

    public ArrayConstraint function Init(required function predicate) output = false {
        variables.predicate = arguments.predicate;
        return this;
    }

    public void function run(required array value) output = false {
        variables.predicate(arguments.value);
    }
}