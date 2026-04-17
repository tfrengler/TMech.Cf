<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tests</title>
</head>
<body>

    <h1>Test cases</h1>
<cfscript>

    testFiles = directoryList(
        path=getDirectoryFromPath(getTemplatePath()),
        recurse=false,
        listInfo="name",
        filter="*.cfm",
        type="file"
    );

    writeOutput("<ul>");

    for (testFile in testFiles) {
        if (testFile.findNoCase("debug") || testFile.findNoCase("index.cfm")) {
            continue;
        }

        writeOutput("<li><a href='#testFile#' target='_blank'>#listFirst(testFile, ".")#</a></li>");
    }

    writeOutput("</ul>");
</cfscript>
</body>
</html>