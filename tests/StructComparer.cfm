<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Struct comparer tests</title>
    <style>
        body {
            margin-left: 20%;
            margin-right: 20%;
        }
    </style>
</head>
<body>

<cfoutput>
    <cfif !structKeyExists(FORM, "doTest") >
        <form action="" method="POST">
            <input name="doTest" type="hidden" value="true" />
            <button type="submit">EXECUTE TESTS</button>
            <cfabort/>
        </form>
    </cfif>
</cfoutput>

<cfscript>
    Tester = new TestRunner("StructComparer.cfc");
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Struct";

    Tester.BeginTests("ContainingKey()");

        Tester.RunTest("When Is.ContainingKey against value with matching key then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    { "test": 1 },
                    Assertions.StructValue::Is().ContainingKey("test")
                );
            });
        });

    Tester.EndTests();
</cfscript>
</body>
</html>
