os = nequire 'os'

# Public:
class Platform

    ### Internal: properties ###

    platform: ''
    version: null

    isLinux: false

    isMac: false

    isWindows: false

    ### Public ###

    constructor: () ->
        platformString = os.platform()
        @setVersion(os.release())

        if platformString is 'darwin'
            @isMac = true
            @setPlatform 'mac'

        else if platformString is 'linux'
            @isLinux = true
            @setPlatform 'linux'

        else if platformString.match '^win'
            @isWindows = true
            @setPlatform 'windows'

    getPlatform: () =>
        return @platform

    getVersion: () =>
        return @version

    # minimumVersion - dot-separated {String} of version number. E.g. 10.0.0. See [the Darwin operating system Wikipedia entry](http://en.wikipedia.org/wiki/Darwin_%28operating_system%29#Release_history) for Mac - Darwin versions.
    isOfMinimumVersion: (minimumVersion) =>
        actualVersion = @getVersion()
        for piece, i in minimumVersion.split('.')
            versionPiece = parseInt(piece, 10)

            if not actualVersion[i]?
                break # e.g. 13.1 passed and actual is 13.1.0
            else if actualVersion[i] > versionPiece
                break # doesn't matter what the next bits are, the major version (or whatever) is larger
            else if actualVersion[i] is versionPiece
                continue # to check next version piece
            else
                return false
        return true # all was ok



    ### Internal ###


    # platform - {String}
    setPlatform: (@platform) =>

    # platform - {String} returned from os.release()
    setVersion: (version) =>

        @version = version.split('.').map (item) -> parseInt(item, 10)

module.exports = Platform