#New-Item -Path "c:\" -Name "temptemptemptemp" -ItemType Directory

$folderPath = "C:\MyNewFolder5"

if (-not (Test-Path -Path $folderPath)) {
	    New-Item -Path $folderPath -ItemType Directory
	        Write-Output "Folder Created Successfully!"
}
else {
	    Write-Output "Folder already exists!"
	    exit
}

$url = "https://github.com/bassmanrod/scripts/blob/master/README.md"

$path_to_file = "$folderPath\goodness1.ps1"

Write-Output "Beginning fetch.";
Invoke-RestMethod $url -OutFile $path_to_file
Write-Output "Fetch ended.";

Write-Output "Done."
