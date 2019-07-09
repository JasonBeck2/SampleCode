configuration DomainJoin 
{ 
   param 
    ( 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]$domainName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]$adminCreds,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]$sourceCodeUrl
    ) 
    
    Import-DscResource -ModuleName CertificateDsc, xComputerManagement, xWebAdministration

    $domainCreds = New-Object System.Management.Automation.PSCredential("$domainName\$($adminCreds.UserName)", $adminCreds.Password)

    $localSourceCodePath = "C:\temp\sourceCode.zip"

    $extractSourceCodePath = "C:\ExtractionDirectory"
   
    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature ADPowershell
        {
            Ensure = "Present"
            Name = "RSAT-AD-PowerShell"
        } 

        xComputer DomainJoin
        {
            Name = $env:COMPUTERNAME
            DomainName = $domainName
            Credential = $domainCreds
            DependsOn = "[WindowsFeature]ADPowershell" 
        }

        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
            IncludeAllSubFeature = $true
            DependsOn = "[xComputer]DomainJoin"
        }

        Script DownloadSourceCode
        {
            GetScript = { return @{ 'Result' = (dir "C:\") } }
            TestScript = { Test-Path $using:localSourceCodePath }
            SetScript = {
                if(!(Test-Path "C:\temp")){
                    New-Item -ItemType Directory -Force -Path "C:\temp"
                }
                # Use TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $client = New-Object System.Net.WebClient
                $client.DownloadFile($using:sourceCodeUrl, $using:localSourceCodePath)
            }
        }

        Archive ExtractSourceCode
        {
            Destination = $extractSourceCodePath
            Path = $localSourceCodePath
            DependsOn = "[Script]DownloadSourceCode"
        }

        Script OverWriteIisSplashPage
        {
            GetScript = { return @{ 'Result' = (dir "C:\inetpub\wwwroot\") } }
            TestScript = { 
                if(Test-Path "C:\inetpub\wwwroot\iisstart.htm"){
                    $contents = Get-Content "C:\inetpub\wwwroot\iisstart.htm"
                    if($contents.Contains($env:computername)){
                        $true
                    }
                    else{
                        $false
                    }
                }
                else{
                    $false
                }
            }
            SetScript = {
                "<h1>Hostname:$env:computername</h1>" | Out-File -FilePath "C:\inetpub\wwwroot\iisstart.htm" -Force
            }
            DependsOn = "[WindowsFeature]IIS"
        }
        
   }
}