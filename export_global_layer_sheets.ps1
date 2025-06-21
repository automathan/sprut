if (-not $args[0]) {
    Write-Host "Please provide a directory name"
    exit
}

$inputFolder = $args[0]
$layerToFiles = @{}

$files = Get-ChildItem -Path $inputFolder -Filter *.aseprite -Recurse
$files += Get-ChildItem -Path $inputFolder -Filter *.ase -Recurse
$files = $files | Sort-Object

foreach ($file in $files) {
    $asepriteOutput = & Aseprite.exe -b --list-layers "$($file.FullName)" | Write-Output

    foreach ($line in $asepriteOutput) {
        $layerName = $line.Trim()
    
        if (-not $layerToFiles.ContainsKey($layerName)) {
            $layerToFiles[$layerName] = @()
        }
        $layerToFiles[$layerName] += $file.FullName
    }
}


$layerToFiles.GetEnumerator() | ForEach-Object {
    Write-Output "Exporting layer `"$($_.Key)`" from $($_.Value.Count) $(&{ if ($_.Value.Count -eq 1) { 'file' } else { 'files' } })"
    Aseprite.exe -b --layer=$($_.Key) $($_.Value) --sheet "export/$($_.Key).png" --data "metadata/$($_.Key).json"
}