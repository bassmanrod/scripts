# Define the path to the Chrome cache folder
$chromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"

# Check if the cache folder exists
if (Test-Path $chromeCachePath) {
    try {
        # Remove all files and folders in the cache directory
        Remove-Item -Path $chromeCachePath\* -Recurse -Force
        Write-Output "Chrome cache has been deleted successfully."
    } catch {
        Write-Output "An error occurred while deleting Chrome cache: $_"
    }
} else {
    Write-Output "Chrome cache folder does not exist."
}
