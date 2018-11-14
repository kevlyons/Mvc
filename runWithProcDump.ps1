try
{
  $procDumpFolder = "$PSScriptRoot/obj";
  mkdir "$procDumpFolder" -Force;
  Invoke-WebRequest https://download.sysinternals.com/files/Procdump.zip -OutFile "$procDumpFolder/procdump.zip";
  Expand-Archive "$procDumpFolder/procdump.zip" -DestinationPath "$procDumpFolder" -Force;

  $job = Start-Job {    
    # $sleepTime = (1 * 20 * 60)
    # Start-Sleep -Seconds $sleepTime;
    $dumpsFolder = "$PSScriptRoot/artifacts/dumps";
    mkdir $dumpsFolder;
    Write-Host $dumpsFolder;
    $processes = Get-Process dotnet*;
    $processes | Format-Table;
    Write-Host "$procDumpFolder/procdump.exe";
    
    $processes |
     Select-Object -ExpandProperty ID | 
     ForEach-Object { &"$procDumpFolder/procdump.exe" -accepteula -ma $_ $dumpsFolder }
  }
  ./run.ps1 default-build $args
  Stop-Job $job
  Remove-Job $job
}
catch
{
  write-host $_
  exit -1;
}