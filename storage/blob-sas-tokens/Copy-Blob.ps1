# *****************************************************************************
#
# File:        Copy-Blob.ps1
#
# Description: Copies a blob from one Storage Account to another.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# *****************************************************************************

function Get-ServiceSasToken {

  param (
    [string]$storageAccountName,
    [string]$storageAccountKey,
    [string]$containerName,
    [string]$blobName,
    [string]$signedPermissions
  )

  $signedStart = (Get-Date -AsUTC).AddMinutes(-5).ToString("yyyy-MM-ddTHH:mm:ssZ");
  $signedExpiry = (Get-Date -AsUTC).AddMinutes(5).ToString("yyyy-MM-ddTHH:mm:ssZ");

  $canonicalizedResource = "/blob/" + $storageAccountName + "/" + $containerName + "/" + $blobName
  $signedIdentifier = ""
  $signedIP = ""
  $signedProtocol = "https"
  $signedVersion = "2021-12-02"
  $signedResource = "b"
  $signedSnapshotTime = ""
  $signedEncryptionScope = ""
  $rscc = ""
  $rscd = ""
  $rsce = ""
  $rscl = ""
  $rsct = ""

  $stringToSign = $signedPermissions + "`n" +
    $signedStart + "`n" +
    $signedExpiry + "`n" +
    $canonicalizedResource + "`n" +
    $signedIdentifier + "`n" +
    $signedIP + "`n" +
    $signedProtocol + "`n" +
    $signedVersion + "`n" +
    $signedResource + "`n" +
    $signedSnapshotTime + "`n" +
    $signedEncryptionScope + "`n" +
    $rscc + "`n" +
    $rscd + "`n" +
    $rsce + "`n" +
    $rscl + "`n" +
    $rsct

  $hmacsha256 = New-Object System.Security.Cryptography.HMACSHA256
  $hmacsha256.Key = [Convert]::FromBase64String($storageAccountKey)

  $signature = [Convert]::ToBase64String($hmacsha256.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign)))

  $sasToken = "sv=" + $signedVersion + `
    "&sr=" + $signedResource + `
    "&spr=" + $signedProtocol + `
    "&st=" + $signedStart + `
    "&se=" + $signedExpiry + `
    "&sp=" + $signedPermissions + `
    "&sig=" + [System.Web.HttpUtility]::UrlEncode($signature)

  Write-Host $sasToken

  return $sasToken
}

$sourceStorageAccountName = "<name-of-the-source-storage-account>"
$sourceAccountKey = "<source-storage-account-key>"
$sourceContainerName = "<source-blob-container-name>"
$sourceBlobName = "<source-blob-name>"

$sourceSasToken = Get-ServiceSasToken -storageAccountName $sourceStorageAccountName -storageAccountKey $sourceAccountKey `
    -containerName $sourceContainerName -blobName $sourceBlobName -signedPermissions "r"

$destStorageAccountName = "<name-of-the-destination-storage-account>"
$destAccountKey = "<destination-storage-account-key>"
$destContainerName = "<destination-blob-container-name>"

$destSasToken = Get-ServiceSasToken -storageAccountName $destStorageAccountName -storageAccountKey $destAccountKey `
    -containerName $destContainerName -blobName $sourceBlobName -signedPermissions "w"

$destUrl = "https://" + $destStorageAccountName + ".blob.core.windows.net/" + $destContainerName + "/" + $sourceBlobName + `
  "?" + $destSasToken

$headers = @{
  "x-ms-date" = [System.Web.HttpUtility]::UrlEncode($currentDateTime)
  "x-ms-copy-source" = "https://" + $sourceStorageAccountName + ".blob.core.windows.net/" + $sourceContainerName + "/" + $sourceBlobName + `
    "?" + $sourceSasToken
  "x-ms-version" = "2021-12-02"
  "Content-length" = 0
}

Invoke-WebRequest $destUrl -Method "PUT" -Headers $headers
