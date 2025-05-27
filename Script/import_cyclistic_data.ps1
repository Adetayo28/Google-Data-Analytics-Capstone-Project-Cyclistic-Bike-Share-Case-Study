# PostgreSQL credentials
$pgUser = "postgres"
$pgDb = "cyclistic_data"
$dataPath = "C:\Users\owner\Desktop\Data\cyclistic_db"
$tempPath = "$dataPath\cleaned"
$logPath = "$dataPath\logs"
$summaryFile = "$logPath\import_summary.txt"

# Create necessary folders
foreach ($path in @($tempPath, $logPath)) {
    if (!(Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path
    }
}

# Initialize summary log
if (Test-Path $summaryFile) {
    Remove-Item $summaryFile
}
New-Item -Path $summaryFile -ItemType File | Out-Null

# Step 1: Get existing ride_ids from DB
Write-Host "Fetching existing ride_ids from database..."
$existingIDs = psql -U $pgUser -d $pgDb -t -c "SELECT ride_id FROM cyclistic_trip;" | ForEach-Object { $_.Trim() }
$existingSet = @{}
foreach ($id in $existingIDs) {
    $existingSet[$id] = $true
}

# Step 2: Loop through all CSV files
Get-ChildItem -Path $dataPath -Filter "*.csv" | ForEach-Object {
    $file = $_.FullName
    $filename = $_.Name
    $cleanFile = "$tempPath\$filename"
    $logFile = "$logPath\$($filename.Replace('.csv', '_skipped.txt'))"

    Write-Host "`nCleaning $filename..."

    $reader = New-Object System.IO.StreamReader($file)
    $writer = New-Object System.IO.StreamWriter($cleanFile, $false)
    $logWriter = New-Object System.IO.StreamWriter($logFile, $false)

    $header = $reader.ReadLine()
    $writer.WriteLine($header)

    $total = 0
    $skipped = 0
    $imported = 0

    while (($line = $reader.ReadLine()) -ne $null) {
        $total++
        $fields = $line.Split(",")
        $ride_id = $fields[0]

        if (-not $existingSet.ContainsKey($ride_id)) {
            $writer.WriteLine($line)
            $existingSet[$ride_id] = $true
            $imported++
        } else {
            $logWriter.WriteLine($ride_id)
            $skipped++
        }
    }

    $reader.Close()
    $writer.Close()
    $logWriter.Close()

    Write-Host "Summary for $filename"
    Write-Host "   Total rows     : $total"
    Write-Host "   Imported rows  : $imported"
    Write-Host "   Skipped (dupes): $skipped"

    Add-Content -Path $summaryFile -Value "File: $filename"
    Add-Content -Path $summaryFile -Value "  Total rows     : $total"
    Add-Content -Path $summaryFile -Value "  Imported rows  : $imported"
    Add-Content -Path $summaryFile -Value "  Skipped (dupes): $skipped"
    Add-Content -Path $summaryFile -Value ""

    Write-Host "Importing cleaned file into database..."
    psql -U $pgUser -d $pgDb -c "\copy cyclistic_trip FROM '$cleanFile' DELIMITER ',' CSV HEADER;"
    Write-Host "Done importing $filename"
}
