<cfcomponent output="false">

    <cfset this.name="TMech.Cf" />
    <cfset this.applicationtimeout = CreateTimeSpan(1,0,0,0) />

    <cfset this.sessionmanagement = true />
    <cfset this.setClientCookies = true />
    <cfset this.sessioncookie.secure = true />
    <cfset this.sessiontimeout = CreateTimeSpan(0,1,0,0) />
    <cfset this.sessionType = "cfml" />
    <cfset this.loginstorage = "session" />

    <cfset this.scriptProtect = "all" />
    <cfset this.invokeImplicitAccessor = false />

    <cfset this.appRoot = getDirectoryFromPath(getCurrentTemplatePath()) />
    <cfset this.srcRoot = this.appRoot & "src/" />

    <cfset this.mappings = {} />
    <cfset this.mappings["/Models"] = this.srcRoot & "Models" />
    <cfset this.mappings["/Services"] = this.srcRoot & "Services" />
    <cfset this.mappings["/Utils"] = this.srcRoot & "Utils" />

    <cffunction name="onApplicationStart" returnType="boolean" output="true">
    <cfscript>
        application.assert = (required bool condition, string message = "") => {
            if (!condition) {
                throw("ERROR: Assertion failed! #message#");
            }
        }

        session.Selenium = new src.Utils.Selenium(this.appRoot & "SeleniumLibs");

        return true;
    </cfscript>
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean" output="false" >
        <cfargument type="string" name="targetPage" required="true" />
        <!--- Otherwise the webserver might buffer the proxied response from Lucee and cfflush won't emit anything--->
        <cfheader name="X-Accel-Buffering" value="no" />

        <cfif structKeyExists(URL, "Reset") >
            <cfset onSessionEnd(session, application) />
            <cflocation url=#listFirst(cgi.REQUEST_URL, "?")# />
        </cfif>

        <!--- For testing purposes, this nukes the session and restarts the application --->
        <cfif structKeyExists(URL, "Restart") >
            <cfset onSessionEnd(session, application) />
            <cfset applicationStop() />
            <cflocation url=#listFirst(cgi.REQUEST_URL, "?")# />
        </cfif>

        <cfreturn true />
    </cffunction>

    <cffunction name="onSessionEnd" returntype="void" output="false">
        <cfargument name="sessionScope" type="struct" required="true" />
        <cfargument name="applicationScope" type="struct" required="true" />

        <cfset sessionInvalidate() />
    </cffunction>

</cfcomponent>