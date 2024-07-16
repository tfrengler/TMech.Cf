/**
 * Quick and dirty helper component to facilitate unit testing.
 */
component displayname="UnitTester" modifier="final" output="true" accessors="false" persistent="true"
{
    // PUBLIC
    property name="SuiteName"                   type="string" getter="true" setter="false";
    property name="StopImmediatelyOnFailure"    type="boolean" getter="true" setter="false";
    // PRIVATE
    property name="Failures"                    type="array" getter="false" setter="false";
    property name="Start"                       type="numeric" getter="false" setter="false";

    public UnitTester function Init(required string suiteName, boolean stopImmediatelyOnFailure = false) {
        variables.StopImmediatelyOnFailure = arguments.stopImmediatelyOnFailure;
        variables.Failures = [];
        variables.Start = 0;

        writeOutput("<h1>#arguments.suiteName#</h1>");
    }

    public void function BeginTests(required string label) {
        if (arguments.label.len() == 0) {
            arguments.label = "UNKNOWN"
        }
        variables.Start = getTickCount();
        writeOutput("<fieldset><legend><h2>#arguments.label#</h2></legend>");
    }

    public void function RunTest(required string name, required function testLambda) {
        var Start = getTickCount();
        try {
            arguments.testLambda();
        }
        catch(error) {
            var StackTrace = arrayLast(callStackGet("array"));
            variables.Failures.append({
                "Name": arguments.name,
                "Message": error.Message,
                "TimeTaken": getTickCount() - Start,
                "StackTrace": StackTrace
            });

            if (variables.StopImmediatelyOnFailure) {
                throw("Aborting the rest of the test run");
            }
        }
    }

    public void function EndTests() {
        Finalize();
        writeOutput("</fieldset>");
        arrayClear(variables.Failures);
    }

    // PRIVATE

    private void function Finalize() {
        if (variables.failures.len() > 0) {
            writeOutput("<h3 style='display:inline-block;background-color:red;color:white'>One or more tests failed!</h3>");

            variables.failures.forEach((struct testCase) => {
                writeOutput("<p>");
                writeOutput("<fieldset style='background-color:rgb(242, 242, 242)'>");
                writeOutput("<legend style='background-color:rgb(0, 102, 255);color:white;font-size:1.2rem'>#arguments.testCase.Name# (#arguments.testCase.TimeTaken# ms)</legend>");

                writeOutput("<h3>#arguments.testCase.message#</h3>");
                writeDump(var=arguments.testCase.StackTrace, label="Stack trace");

                writeOutput("</fieldset>");
                writeOutput("</p>");
            })
        }
        else {
            var TimeTaken = getTickCount() - variables.Start;
            writeOutput("<h3 style='display:inline-block;background-color:green;color:white'>All passed! (#TimeTaken# ms)</h3>")
        }
    }
}