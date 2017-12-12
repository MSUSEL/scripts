# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Powershell script to download, install, and configure needed dependencies   #
# to run a SonarQube server on a Microsoft Server 2012 Core.                  #
# Assumed Environment:                                                        #
#   - A clean install of Microsoft Server 2012 Core (no GUI).                 #
# Author:                                                                     #
#   - David Rice, MSU Software Engineering Laboratory                         #
# Last Updated:                                                               #
#   - December 12, 2017                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# java download parameters
$JRE_SOURCE = "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jre-8u151-windows-x64.exe"
$JRE_DEST = "C:\Install\jre-download.exe"
$JRE_COOKIE = "oraclelicense=accept-securebackup-cookie"

# mysql download parameters
$MYSQL_SOURCE = "https://cdn.mysql.com//Downloads/MySQLInstaller/mysql-installer-web-community-5.7.20.0.msi"
$MYSQL_DEST = "C:\Install\mysql-download.msi"

# sonarqube download parameters
$SONAR_SOURCE = "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.7.zip"
$SONAR_DEST = "C:\sonarqube-5.6.7.zip"


### begin download of dependencies
Write-Host 'Adding Install directory.'
mkdir C:\Install

# java
Write-Host 'Downloading Java JRE...'
$client = new-object System.Net.WebClient
$cookie = $JRE_COOKIE
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
$client.DownloadFile($JRE_SOURCE, $JRE_DEST)
Write-Host 'JRE Downloaded.'

# mysql
Write-Host 'Downloading MySQL...'
$client = new-object System.Net.WebClient
$client.DownloadFile($MYSQL_SOURCE, $MYSQL_DEST)
Write-Host 'MySQL .msi Downloaded.'

# sonarqube
Write-Host 'Downloading SonarQube 5.6.7...'
$client = new-object System.Net.WebClient
$client.DownloadFile($SONAR_SOURCE, $SONAR_DEST)
Write-Host 'SonarQube 5.6.7 Downloaded.'


### begin install of dependencies
# silent install of JRE, and add to path
Write-Host 'Beginning silent install of JRE...'
$exelocation = "C:\Install\jre-download.exe"
$proc1 = Start-Process -FilePath $exelocation -ArgumentList "/s REBOOT=ReallySuppress" -Wait -PassThru
$proc1.waitForExit()
Write-Host 'Adding JRE to Path...'
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\Java\jre1.8.0_151\bin", "Machine")
$env:Path = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
Write-Host 'JRE install finished.'

# extract SonarQube to C: directory
Write-Host 'Unzipping SonarQube...'
Add-Type –A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::ExtractToDirectory("C:\sonarqube-5.6.7.zip", "C:\")
rm "C:\sonarqube-5.6.7.zip"
Write-Host 'SonarQube extracted to C: drive.'

Write-Host 'Script finished. Be sure to install MySQL.msi manually.'
