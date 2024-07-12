<cfscript>

    // writeDump(var=application, list="Application");
    // writeDump(var=session, list="Session");

    test = WebdriverContext::CreateLocal("CHROME");
    // writeDump( getMetadata(test) );

    test.Browser = "something else";
    writeDump(test.Browser);
    writeDump(test);
    writeDump(test.getBrowser());

</cfscript>