<cfset redirectUrl = reReplace(CGI.script_name, "^/+", "", "all")  />

<cfif structKeyExists(URL, "Reset") >
    <cfset sessionInvalidate() />

    <cflocation addtoken="false" url="#redirectUrl#?action=reset" />
</cfif>

<cfif structKeyExists(URL, "Restart") >
    <cfset sessionInvalidate() />
    <cfset applicationStop() />

    <cflocation addtoken="false" url="#redirectUrl#?action=restarted" />
</cfif>

<cfoutput>
    <h1>
        <cfif structKeyExists(URL, "action") >
            #URL.action#
        <cfelse>
            nothing...
        </cfif>
    </h1>

    <cfdump var=#session# label="session" />
    <cfdump var=#application# label="application" />
</cfoutput>