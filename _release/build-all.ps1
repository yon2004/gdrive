$APP_NAME= "gdrive"
$PLATFORMS= @(
    #"darwin/386"
    #"darwin/amd64"
    #"darwin/arm"
    #"darwin/arm64"
    #"dragonfly/amd64"
    #"freebsd/386"
    #"freebsd/amd64"
    #"freebsd/arm"
    #"linux/386"
    #"linux/amd64"
    #"linux/arm"
    #"linux/arm64"
    #"linux/ppc64"
    #"linux/ppc64le"
    #"linux/mips64"
    #"linux/mips64le"
    #"linux/rpi"
    #"netbsd/386"
    #"netbsd/amd64"
    #"netbsd/arm"
    #"openbsd/386"
    #"openbsd/amd64"
    #"openbsd/arm"
    #"plan9/386"
    #"plan9/amd64"
    #"solaris/amd64"
    "windows/386"
    "windows/amd64"
)

$BIN_PATH=".\_release\bin"

foreach ($PLATFORM in $PLATFORMS){
   
    $pos = $PLATFORM.IndexOf('/')
    $GOOS= $PLATFORM.Substring(0, $pos)
    $GOARCH= $PLATFORM.Substring($pos+1)
    
    if($GOOS -eq "darwin"){
        $niceGOOS = "osx"
    } else {
        $niceGOOS = $GOOS
    }

    if($GOARCH -eq "amd64"){
        $niceGOARCH = "x64"
    } else {
        $niceGOARCH = $GOARCH
    }

    $BIN_NAME="$APP_NAME-$niceGOOS-$niceGOARCH"

    if ($GOOS -eq "windows"){
        $BIN_NAME="${BIN_NAME}.exe"
    }

    # Raspberrypi seems to need arm5 binaries
    if ($GOARCH -eq "rpi"){
        $env:GOARM=5
        $env:GOARCH="arm"
    } else {
        Remove-Item env:\GOARM -ErrorAction SilentlyContinue
    }

    $env:GOOS=$GOOS
    $env:GOARCH=$GOARCH

    Write-Output "Building $BIN_NAME"

    go build -ldflags '-w -s' -o ${BIN_PATH}/${BIN_NAME}
}