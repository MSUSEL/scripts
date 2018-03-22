# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Powershell script to download, install, and configure needed dependencies   #
# to run a SonarQube server on a Microsoft Server 2012 Core.                  #
# Assumed Environment:                                                        #
#   - A clean install of Microsoft Server 2012 Core 64 bit (GUI optional).    #
# Author:                                                                     #
#   - David Rice, MSU Software Engineering Laboratory                         #
# Last Updated:                                                               #
#   - March 21, 2018                                                          #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# java download parameters
$JAVA_VERS_A = "8"
$JAVA_VERS_B = "161"
$JAVA_VERS = $JAVA_VERS_A + "u" + $JAVA_VERS_B
$JRE_SOURCE = "http://download.oracle.com/otn-pub/java/jdk/" + $JAVA_VERS + "-b12/2f38c3b165be4555a1fa6e98c45e0808/jre-" + $JAVA_VERS + "-windows-x64.exe"
$JRE_DEST = "C:\Install\jre-download.exe"
$JRE_COOKIE = "oraclelicense=accept-securebackup-cookie"

# mysql download parameters
$MYSQL_SOURCE = "https://cdn.mysql.com//Downloads/MySQLInstaller/mysql-installer-web-community-5.7.20.0.msi"
$MYSQL_DEST = "C:\Install\mysql-download.msi"

# sonarqube download parameters
$SONAR_SOURCE = "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.7.zip"
$SONAR_DEST = "C:\sonarqube-5.6.7.zip"
$SONAR_PROP = ""


### begin download of dependencies
Write-Host "Beginning download of dependencies..." -ForegroundColor Green
Try {
    Write-Host "Adding Install directory."
    $path = "C:\Install"
    If(!(test-path $path))
    {
        mkdir C:\Install
    }
}
Catch {
    Write-Error "Unable to add Install directory at C:\Install" -ErrorAction Stop
}

# java
Try {
    Write-Host "Downloading Java JRE..."
    $client = new-object System.Net.WebClient
    $cookie = $JRE_COOKIE
    $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
    $client.DownloadFile($JRE_SOURCE, $JRE_DEST)
    Write-Host "JRE Downloaded. Java version: $JAVA_VERS"
}
Catch {
    Write-Error "Download of Java $JAVA_VERS JRE failed. Ensure the C:\Install directory exists. Ensure the Java source URL and cookie variables are correct." -ErrorAction Stop
}

# mysql
Try {
    Write-Host "Downloading MySQL..."
    $client = new-object System.Net.WebClient
    $client.DownloadFile($MYSQL_SOURCE, $MYSQL_DEST)
    Write-Host "MySQL .msi Downloaded."
}
Catch {
    Write-Error "Download of MySQL .msi file failed. Ensure the C:\Install directory exists. Ensure the MYSQL_SOURCE source URL is correct" -ErrorAction Stop
}


# sonarqube
Try {
    Write-Host "Downloading SonarQube 5.6.7..."
    $client = new-object System.Net.WebClient
    $client.DownloadFile($SONAR_SOURCE, $SONAR_DEST)
    Write-Host "SonarQube 5.6.7 Downloaded."
}
Catch {
    Write-Error "Download of SonarQube .zip file failed. Ensure the SONAR_SOURCE source URL is correct" -ErrorAction Stop
}


### begin install of dependencies
Write-Host "Beginning install of dependencies..." -ForegroundColor Green
# silent install of JRE, and add to path
Try {
    Write-Host "Beginning silent install of JRE..."
    $exelocation = "C:\Install\jre-download.exe"
    $proc1 = Start-Process -FilePath $exelocation -ArgumentList "/s REBOOT=ReallySuppress" -Wait -PassThru
    $proc1.waitForExit()
    Write-Host "Adding JRE to Path..."
    [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\Java\jre1." + $JAVA_VERS_A + ".0_" + $JAVA_VERS_B + "\bin", "Machine")
    $env:Path = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    java -version
    Write-Host "JRE install finished."
}
Catch {
    Write-Error "Silent install of JRE failed. Ensure the executable is located at C:\Install\jre-download.exe" -ErrorAction Stop
}

# extract SonarQube to C: directory
Try {
    Write-Host "Unzipping SonarQube into C:\ drive..."
    Add-Type –A System.IO.Compression.FileSystem
    [IO.Compression.ZipFile]::ExtractToDirectory("C:\sonarqube-5.6.7.zip", "C:\")
    Remove-Item "C:\sonarqube-5.6.7.zip"
    Write-Host "SonarQube extracted to C: drive."
}
Catch {
    Write-Error "SonarQube unzip failed. Ensure C:\sonarqube-5.6.7.zip exists on the system." -ErrorAction Stop
}
# configure SonarQube properties


Write-Host 'Script finished. Be sure to install and configure MySQL.msi manually.'