<cfscript>

    // writeDump(var=application, list="Application");
    // writeDump(var=session, list="Session");

    // httpService = new http(
    //     method = "GET",
    //     charset = "utf-8",
    //     throwonerror = true,
    //     timeout = 30,
    //     url = "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json");

    // response = httpService.send().getPrefix();
    // writeDump(response);

    // returnData = deserializeJSON(response.fileContent);
    // // writeDump(returnData.channels.stable.version);
    // // writeDump(returnData.channels.stable.downloads.chrome);
    // writeDump(returnData.channels.stable.downloads.chromedriver);

    // result = arrayFilter(returnData.channels.stable.downloads.chromedriver, (struct value)=> {
    //     return arguments.value.platform == "win64";
    // })[1].url;

    // writeDump(result);

    baseString = "126.0.6478.126";
    baseVersion = Models.Version::FromString(baseString);

    string2 = "126.0.6478.127";
    versionGreaterMinor = Models.Version::FromString(string2);

    string3 = "126.0.6478.125";
    versionLesserMinor = Models.Version::FromString(string3);

    string4 = "127.0.6478.126";
    versionGreaterMajor = Models.Version::FromString(string4);

    string5 = "124.0.6478.126";
    versionLesserMajor = Models.Version::FromString(string5);

    versionEqual = Models.Version::FromString(baseString);

    writeDump( var=baseVersion.CompareTo(versionGreaterMinor) == -1, label="versionGreaterMinor == TRUE" );
    writeDump( var=baseVersion.CompareTo(versionLesserMinor) == 1, label="versionLesserMinor == TRUE" );
    writeDump( var=baseVersion.CompareTo(versionGreaterMajor) == -1, label="versionGreaterMajor == TRUE" );
    writeDump( var=baseVersion.CompareTo(versionLesserMajor) == 1, label="versionGreaterMajor == TRUE" );
    writeDump( var=baseVersion.CompareTo(versionEqual) == 0, label="versionEqual == TRUE" );

</cfscript>