<cfscript>

    // writeDump(var=application, list="Application");
    // writeDump(var=session, list="Session");

    // Tester = createObject("component", "../tests/UnitTester");

    createObject("component", "../tests/Assert").DoesNotThrow(()=> {
        throw("Oh hi!", "Snargle");
        return 0;
    }, "Gnargle");

    writeOutput("Done");

</cfscript>