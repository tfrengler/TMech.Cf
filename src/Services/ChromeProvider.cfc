component displayname="ChromeProvider" modifier="final" output="false" accessors="false" persistent="true"
{
    // PUBLIC
    property name="InstallLocation" type="string" getter="true" setter="false";
    property name="ManifestURL"     type="string" getter="true" setter="false";
    property name="RequestTimeout"  type="numeric" getter="true" setter="false";

    // PRIVATE
    property name="IsDisposed"      type="boolean" getter="false" setter="false";
    property name="VersionFileName" type="string" getter="false" setter="false";
    property name="TempDir"         type="string" getter="false" setter="false";

    // CUSTOM SETTERS
    public void function SetRequestTimeout(required numeric timeout) {
        if (timeout < 1) {
            variables.RequestTimeout = 30;
        }
        variables.RequestTimeout = arguments.timeout;
    }

    /**
     * Constructor
     * @installLocation The absolute path to the folder where to download and extract Chrome and its driver. Must exist, and be readable.
     */
    public ChromeProvider function Init(required string installLocation) {

        if (!directoryExists(arguments.installLocation)) {
            throw("Error instantiating ChromeProvider. Argument 'installLocation' does not point to a directory that exists: #arguments.installLocation#", "TMech.Cf.NoSuchDir");
        }

        variables.TempDir = arguments.installLocation & "/cf_temp";
        directoryCreate(path=variables.TempDir, ignoreExists=true, createPath=false);

        variables.InstallLocation = arguments.installLocation;
        variables.ManifestURL = "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json";
        variables.RequestTimeout = 30;
        variables.VersionFileName = "VERSION";

        return this;
    }

    /**
     * Returns the version that is currently installed or an empty string if there's no version installed (or the version file is empty or cannot be found).
     */
    public string function GetCurrentInstalledVersion() {
        var FilePath = "#variables.InstallLocation#/#variables.VersionFileName#";
        if (!fileExists(FilePath)) {
            return "";
        }

        return fileRead(FilePath);
    }

    /**
     *  Returns the latest stable version of Chrome that is available online.
     */
    public string function GetLatestAvailableVersion(required string platform) {
        return getBinaryAssetData(arguments.platform)[1].Version;
    }

    /**
     * Returns a list (string) of all platforms this service supports.
     */
    public string function GetSupportedPlatforms() {
        // Note: these values literally match keys in the manifest JSON so DO NOT change!
        return "win64,linux64"
    }

    /**
     * Checks whether a given platform-string matches a platform this service supports.
     */
    public boolean function IsSupportedPlatform(required string platform) {
        return listFind(GetSupportedPlatforms(), arguments.platform) != 0;
    }

    /**
     * Deletes all files and folders in the install location (though it regenerates the temp-subfolder).
     */
    public void function ClearInstallLocation() {
        var InstallLocationDirs = directoryList(path=variables.InstallLocation, recurse=true, listInfo="all", type="dir");

        for(var currentDir in InstallLocationDirs) {
            directoryDelete(currentDir, true);
        }

        var InstallLocationFiles = directoryList(path=variables.InstallLocation, recurse=true, listInfo="all", type="file");
        for(var currentFile in InstallLocationFiles) {
            fileDelete(currentFile);
        }

        directoryCreate(path=variables.TempDir, ignoreExists=true);
    }

    /**
     * Downloads and extracts Chrome and its webdriver (their versions always match each other) into the install location if the currently installed version is lower than the latest available version or if Chrome is not installed.</para>
     * NOTE: If there is already a version of Chrome in the install location it will not be removed first! Existing files will merely be overwritten. This might leave certain version-specific files behind.
     *
     * @platform The platform to download Chrome and its driver for.
     * @skipDriver Optional. Whether to skip download the driver and only download the browser.
     * @force Optional. Whether to force Chrome to be downloaded and installed even if the installed version is already the newest.
     * @retuns True if the browser and/or driver was download, false otherwise.
     */
    public boolean function DownloadLatestVersion(required string platform, boolean skipDriver = false, boolean force = false) {

        var DownloadData = getBinaryAssetData(arguments.platform);
        var MaxIndex = arguments.skipDriver ? 2 : 3;

        var CurrentVersion = Models.Version::FromString( GetCurrentInstalledVersion() );
        var LatestVersion = Models.Version::FromString(DownloadData[1].Version);

        if (!force && LatestVersion.CompareTo(CurrentVersion) != 1) {
            return false;
        }

        for (var index = 1; index < MaxIndex; index++) {

            var OutputName = "chromedriver-win64";
            if (index == 1 && arguments.platform == "win64") {
                OutputName = "chrome-win64"
            }
            else if (index == 1 && arguments.platform == "linux64") {
                OutputName = "chrome-linux64"
            }
            else if (index == 2 && arguments.platform == "win64") {
                OutputName = "chromedriver-win64"
            }
            else if (index == 2 && arguments.platform == "linux64") {
                OutputName = "chromedriver-linux64"
            }

            var TempFile = "#variables.TempDir#/#OutputName#.zip";
            var ExtractedDir = "#variables.TempDir#/#OutputName#";

            var HttpRequest = new http(
                method = "GET",
                charset = "utf-8",
                throwonerror = true,
                redirect  = false,
                timeout = variables.RequestTimeout,
                url = DownloadData[index].DownloadUri);

            var Response = HttpRequest.send().getPrefix();
            if (Response.mimeType != "application/zip") {
                throw("Error downloading and extracting Chrome for Testing. Download url did not return a response with response type 'application/zip' but instead '#Response.mimeType#' (#DownloadData[2].DownloadUri#)");
            }

            fileWrite(TempFile, Response.fileContent);

            cfzip(
                action="unzip", charset="utf-8",
                overwrite=true, destination=variables.TempDir,
                file=TempFile
            );

            directoryCopy(
                source=ExtractedDir, destination=variables.InstallLocation,
                recurse=true, createPath=false
            );

            directoryDelete(ExtractedDir, true);
            fileDelete(TempFile);
        }

        fileWrite("#variables.InstallLocation#/#variables.FilePath#", DownloadData[1].ReadableVersion);
        return true;
    }

    // PRIVATE METHODS

    /**
     * Returns an array where index 1 is the browser data, and index 2 is the driver data
     */
    private array function getBinaryAssetData(required string platform) {

        if (!IsSupportedPlatform(arguments.platform)) {
            throw("Not a valid platform: #arguments.platform#. Supported platforms are #GetSupportedPlatforms()#");
        }

        var args = arguments;

        var HttpRequest = new http(
            method = "GET",
            charset = "utf-8",
            throwonerror = true,
            timeout = variables.RequestTimeout,
            url = variables.ManifestURL);

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
                "Version": Version,
                "DownloadUri": BrowserSearchResult[1].url
            },
            {
                "Version": Version,
                "DownloadUri": DriverSearchResult[1].url
            }
        ]
    }
}