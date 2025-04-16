component displayname="Dimension" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="X" type="string" getter="true" setter="false";
    property name="Y" type="string" getter="true" setter="false";

    public Dimension function Init(required numeric x, required numeric y) {
        variables.X = arguments.X;
        variables.Y = arguments.Y;

        return this;
    }

    public boolean function IsValid()
    {
        return variables.X > 0 && variables.Y > 0;
    }

    public static Dimension function None()
    {
        return new Dimension(0,0);
    }
}