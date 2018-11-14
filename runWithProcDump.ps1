try
{
  $job = Start-Job {    
    $procDumpFolder = "./obj";
    mkdir "$procDumpFolder" -Force;
    $procDumpFolder = Resolve-Path $procDumpFolder;
    Invoke-WebRequest https://download.sysinternals.com/files/Procdump.zip -OutFile "$procDumpFolder/procdump.zip";
    Expand-Archive "$procDumpFolder/procdump.zip" -DestinationPath "$procDumpFolder" -Force;
  
    $sleepTime = (1 * 5 * 60)
    Start-Sleep -Seconds $sleepTime;
    $dumpsFolder = "./artifacts/dumps";
    mkdir $dumpsFolder;
    Write-Host $dumpsFolder;
    $processes = Get-Process dotnet*;
    $processes | Format-Table;
    Write-Host "$procDumpFolder/procdump.exe";
    
    $processes |
     Select-Object -ExpandProperty ID | 
     ForEach-Object { &"./obj/procdump.exe" -accepteula -ma $_ $dumpsFolder }
  }
  Write-Host "Process dump capture job started. Running run.ps1 next";
  ./run.ps1 default-build @args
  Receive-Job $job
  # Stop-Job $job
  # Remove-Job $job
}
catch
{
  write-host $_
  exit -1;
}