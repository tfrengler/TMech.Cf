component displayname="ChromeProvider" modifier="final" output="false" accessors="false" persistent="true"
{
    // PUBLIC
    property name="InstallLocation" type="string" getter="true" setter="false";
    property name="ManifestURL"     type="string" getter="true" setter="false";
    property name="RequestTimeout"  type="numeric" getter="true" setter="false";

    // PRIVATE
    property name="IsDisposed"      type="boolean" getter="false" setter="false";
    property name="VersionFileName" type="string" getter="false" setter="false";

    // CUSTOM SETTERS
    public void function SetRequestTimeout(required numeric timeout) {
        if (timeout < 1) {
            variables.RequestTimeout = 30;
        }
    }

    /**
     * Constructor
     * @output false
     */
    public ChromeProvider function Init(required string installLocation) {

        if (!directoryExists(arguments.installLocation)) {
            throw("Error instantiating ChromeProvider. Argument 'installLocation' does not point to a directory that exists: #arguments.installLocation#");
        }

        variables.ManifestURL = "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json";
        variables.RequestTimeout = 30;

        return this;
    }

    // ClearInstallLocation
    // GetCurrentInstalledVersion
    // GetLatestAvailableVersion
    // DownloadLatestVersion

    public string function GetSupportedPlatforms() {
        // Note: these values literally match keys in the manifest JSON so DO NOT change!
        return "win64,linux64"
    }

    public boolean function IsSupportedPlatform(required string platform) {
        return listFind(GetSupportedPlatforms(), arguments.platform) != 0;
    }

    // PRIVATE METHODS

    private array function getBinaryAssetData(required string platform) {

        if (!IsSupportedPlatform(arguments.platform)) {
            throw("Not a valid platform: #arguments.platform#. Supported platforms are #GetSupportedPlatforms()#");
        }

        var args = arguments; 

        var HttpRequest = new http(
            method = "GET",
            charset = "utf-8",
            throwonerror = true,
            timeout = variables.getRequestTimeout(),
            url = variables.getManifestURL());

        var Response = HttpRequest.send().getPrefix();
        if (Response.mimeType != "application/json") {
            throw("Failed to fetch the asset manifest for 'Chrome for Testing' (#variables.ManifestURL#). Expected the response to return JSON but it was: #response.mimeType#");
        }

        try {
            var Manifest = deserializeJSON(response.fileContent);
        }
        catch (error) {
            throw("Failed to deserialize the asset manifest for 'Chrome for Testing' (#variables.ManifestURL#): #error.message#");
        }
        
        var Version = Manifest.channels.stable.version;
        
        var BrowserSearchResult = arrayFilter(Manifest.channels.stable.downloads.chrome, (struct value)=> {
            return arguments.value.platform == args.platform;
        });

        var DriverSearchResult = arrayFilter(Manifest.channels.stable.downloads.chromedriver, (struct value)=> {
            return arguments.value.platform == args.platform;
        });

        if (BrowserSearchResult.len() == 0 || DriverSearchResult.len() == 0) {
            throw("Failed to find a browser and/or driver in the manifest that matched the chosen platform: #arguments.platform# (manifest.channels.stable.downloads.chrome/chromedriver)");
        }

        return [
            {
                "ReadableVersion": Version,
                "Version": "",
                "DownloadUri": BrowserSearchResult[1].url
            },
            {
                "ReadableVersion": Version,
                "Version": "",
                "DownloadUri": DriverSearchResult[1].url
            }
        ]
    }
}