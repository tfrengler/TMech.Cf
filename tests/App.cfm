<cfif structKeyExists(URL, "Reset") >
    <cfset sessionInvalidate() />
    <cfset request.action = "Reset" />
    <cflocation addtoken="false" url="#CGI.SCRIPT_NAME#?action=reset" />
</cfif>

<cfif structKeyExists(URL, "Restart") >
    <cfset pagePoolClear() />
    <cfset componentCacheList() />

    <cfobjectcache type="function"  action="clear">
    <cfobjectcache type="include"   action="clear">
    <cfobjectcache type="query"     action="clear">

    <cfset sessionInvalidate() />
    <cfset applicationStop() />

    <cfset request.action = "Restarted" />
    <cflocation addtoken="false" url="#CGI.SCRIPT_NAME#?action=restarted" />
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