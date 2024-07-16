<cfscript>

    // writeDump(var=application, list="Application");
    // writeDump(var=session, list="Session");

    Test = new Services.ChromeProvider("C:/Temp/Chrome_Test");
    // Test.DownloadLatestVersion("win64", false);
    // Test.DownloadLatestVersion("win64", true);
    // Test.DownloadLatestVersion("linux64", false);
    // Test.DownloadLatestVersion("linux64", true);

    // createObject("component", "../tests/Assert").DoesNotThrow(()=> {
    //     throw("Oh hi!", "Snargle");
    //     return 0;
    // }, "Gnargle");

    // writeOutput(Test.ClearInstallLocation());
    // writeDump(Test.GetCurrentInstalledVersion());
    // writeDump(Test.GetLatestAvailableVersion("win64"));

    writeDump(directoryList(path="C:/Temp/Chromium", recurse=false, listInfo="query", type="all").recordCount);

</cfscript>