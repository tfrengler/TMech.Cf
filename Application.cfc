<cfcomponent output="false">

    <cfset this.name="Sandbox" />
    <cfset this.applicationtimeout = CreateTimeSpan(14,0,0,0) />

    <cfset this.sessionmanagement = true />
    <cfset this.setClientCookies = true />
    <cfset this.sessioncookie.secure = true />
    <cfset this.sessiontimeout = CreateTimeSpan(0,1,0,0) />
    <cfset this.sessionType = "cfml" />
    <cfset this.loginstorage = "session" />

    <cfset this.scriptProtect = "all" />
    <cfset this.invokeImplicitAccessor = false />

    <!--- <cfset this.defaultdatasource = {
        class: "org.sqlite.JDBC",
        connectionString: "jdbc:sqlite:#this.root#dfa8c46a-29b3-4a1f-947e-0bdd385380bb/RecipeDB.sdb",
        timezone: "CET",
        custom: {useUnicode: true, characterEncoding: 'UTF-8', Version: 3},
        blob: true,
        clob: true,
        validate: true
    } /> --->

    <cffunction name="onApplicationStart" returnType="boolean" output="false">
        <cfscript>

        application.assert = (required bool condition, string message = "") => {
            if (!condition) {
                throw("ERROR: Assertion failed! #message#");
            }
        }
        // this.root = getDirectoryFromPath( getCurrentTemplatePath() );
        session.Selenium = new Selenium(expandPath("./SeleniumLibs"));

        return true;
        </cfscript>
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean" output="false" >
        <cfargument type="string" name="targetPage" required="true" />
        <!--- Otherwise nginx will buffer the proxied response from Lucee and cfflush won't emit --->
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