Set-ExecutionPolicy –Scope CurrentUser –ExecutionPolicy Unrestricted
mkdir C:\Install

$jreSource = "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jre-8u151-windows-x64.exe"
$jreDestination = "C:\Install\jre-8u151-windows-x64.exe"
$jreClient = new-object System.Net.WebClient
$cookie = "oraclelicense=accept-securebackup-cookie"
$jreClient.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
$jreClient.DownloadFile($jreSource, $jreDestination)

$sqlServerSource = "https://go.microsoft.com/fwlink/?linkid-853016"
$sqlServerDestination = "C:\Install\SQLServer2017-SSEI-Dev.exe"
$sqlServerClient = new-object System.Net.WebClient
$sqlServerClient.DownloadFile($sqlServerSource, $sqlServerDestination)

$jdbcSource = "https://download.microsoft.com/download/F/0/F/F0FF3F95-D42A-46AF-B0F9-8887987A2C4B/sqljdbc_4.2.8112.100_enu.exe"
$jdbcDestination = "C:\Install\SQLServer2017-SSEI-Dev.exe"
$jdbcClient = new-object System.Net.WebClient
$jdbcClient.DownloadFile($jdbcSource, $jdbcDestination)

$sonarQubeSource = "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.7.zip"
$sonarQubeDestination = "C:\sonarqube-5.6.7.zip"
$sonarQubeClient = new-object System.Net.WebClient
$sonarQubeClient.DownloadFile($sonarQubeSource, $sonarQubeDestination)
Expand-Archive C:\sonarqube-5.6.7.zip –DestinationPath C:\
rm sonarqube-5.6.7.zip

mkdir C:\sonarqube-5.6.7\scanners
mkdir C:\sonarqube-5.6.7\scanners\msbuild-scanner
$sonarScannerSource = "https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/3.0.2.656/sonar-scanner-msbuild-3.0.2.656.zip"
$sonarScannerDestination = "C:\sonarqube-5.6.7\scanners\msbuild-scanner\sonar-scanner-msbuild-3.0.2.656.zip"
$sonarScannerClient = new-object System.Net.WebClient
$sonarScannerClient.DownloadFile($sonarScannerSource, $sonarScannerDestination)
Expand-Archive C:\sonarqube-5.6.7\scanners\msbuild-scanner\sonarqube-5.6.7.zip –DestinationPath C:\sonarqube-5.6.7\scanners\msbuild-scanner\
rm \sonarqube-5.6.7\scanners\msbuild-scanner\sonar-scanner-msbuild-3.0.2.656.zip
