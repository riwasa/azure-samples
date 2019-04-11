using System;
using System.IO;
using System.Threading.Tasks;

using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Blob;

namespace NETCoreSDK
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            string storageAccountName = "rimdemostrnetcoresdk";
            string storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=rimdemostrnetcoresdk;AccountKey=;EndpointSuffix=core.windows.net";

            ProcessAsync(storageAccountName, storageConnectionString).GetAwaiter().GetResult();

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }

        private static async Task ProcessAsync(string storageAccountName, string storageConnectionString)
        {
            #region Get the Storage Account.

            CloudStorageAccount storageAccount = null;

            if (!CloudStorageAccount.TryParse(storageConnectionString, out storageAccount))
            {
                Console.WriteLine("ERROR: Could not parse the storage connection string.");
                return;
            }

            #endregion

            #region Get the Blob client.

            // Create a Blob client that represents the Blob storage endpoint for the Storage Account.
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            #endregion

            #region Create a Blob container.

            string containerName = "netcoresdk" + DateTime.UtcNow.ToString("yyyyMMddHHmmss");

            CloudBlobContainer blobContainer = blobClient.GetContainerReference(containerName);

            await blobContainer.CreateAsync();

            Console.WriteLine($"Created container '{blobContainer.Name}'.");

            #endregion

            #region Set permissions on the container.

            BlobContainerPermissions containerPermissions = new BlobContainerPermissions
            {
                PublicAccess = BlobContainerPublicAccessType.Blob
            };

            await blobContainer.SetPermissionsAsync(containerPermissions);

            Console.WriteLine("Set public permissions on blobs.");

            #endregion

            #region Create a temporary file.

            string localPath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string localFileName = "QuickStart_" + Guid.NewGuid().ToString() + ".txt";
            string sourcePath = Path.Combine(localPath, localFileName);
            File.WriteAllText(sourcePath, "Hello world!");

            Console.WriteLine($"Created temporary file '{sourcePath}'");

            #endregion

            #region Upload the file.

            CloudBlockBlob blob = blobContainer.GetBlockBlobReference(localFileName);
            await blob.UploadFromFileAsync(sourcePath);

            Console.WriteLine($"Uploaded '{localFileName}'.");

            #endregion

            #region Upload another copy of the file in a subfolder called 'demo'.

            string copyFileName = "demo/" + localFileName;

            CloudBlockBlob blobCopy = blobContainer.GetBlockBlobReference(copyFileName);
            await blobCopy.UploadFromFileAsync(sourcePath);

            Console.WriteLine($"Uploaded '{copyFileName}'.");

            #endregion

            #region List the blobs.

            BlobContinuationToken blobContinuationToken = null;

            do
            {
                var results = await blobContainer.ListBlobsSegmentedAsync(null, blobContinuationToken);

                blobContinuationToken = results.ContinuationToken;

                foreach (IListBlobItem item in results.Results)
                {
                    Console.WriteLine(item.Uri);
                }
            } while (blobContinuationToken != null);

            #endregion

            #region Download.

            string destinationPath = sourcePath.Replace(".txt", "_downloaded.txt");
            await blob.DownloadToFileAsync(destinationPath, FileMode.Create);

            Console.WriteLine($"Downloaded '{destinationPath}'.");

            #endregion

            #region Create a Shared Access Policy on the Blob container.

            SharedAccessBlobPolicy policy = new SharedAccessBlobPolicy
            {
                Permissions = SharedAccessBlobPermissions.Read,
                SharedAccessStartTime = DateTime.UtcNow.AddSeconds(-10),
                SharedAccessExpiryTime = DateTime.UtcNow.AddDays(1)
            };

            BlobContainerPermissions newContainerPermissions = await blobContainer.GetPermissionsAsync();

            newContainerPermissions.SharedAccessPolicies.Add("Read Policy", policy);

            newContainerPermissions.PublicAccess = BlobContainerPublicAccessType.Off;

            await blobContainer.SetPermissionsAsync(newContainerPermissions);

            #endregion

            #region Create a SAS token from the policy.

            BlobContainerPermissions sasTokenPermissions = await blobContainer.GetPermissionsAsync();

            SharedAccessBlobPolicy sasTokenPolicy = sasTokenPermissions.SharedAccessPolicies["Read Policy"];

            string sasToken = blobContainer.GetSharedAccessSignature(sasTokenPolicy);

            Console.WriteLine($"SAS Token: {sasToken}");

            // Note, if using the SAS token on the Windows command line, such as passing it to AzCopy, you must replace
            // any % with %% (i.e. escape the character), since % is a special character.

            #endregion

            #region Use the SAS token.

            string blobEndpoint = $"https://{storageAccountName}.blob.core.windows.net";

            StorageCredentials credentials = new StorageCredentials(sasToken);

            CloudBlobClient sasTokenBlobClient = new CloudBlobClient(new Uri(blobEndpoint), credentials);

            CloudBlobContainer sasTokenBlobContainer = sasTokenBlobClient.GetContainerReference(containerName);

            CloudBlockBlob sasTokenBlob = sasTokenBlobContainer.GetBlockBlobReference(copyFileName);

            string sasTokenBlobPath = sourcePath.Replace(".txt", "_downloadedsas.txt");
            await sasTokenBlob.DownloadToFileAsync(sasTokenBlobPath, FileMode.Create);

            #endregion

            #region Clean up.

            Console.WriteLine("Press any key to clean up...");
            Console.ReadKey();

            if (blobContainer != null)
            {
                await blobContainer.DeleteIfExistsAsync();
            }

            File.Delete(sourcePath);
            File.Delete(destinationPath);
            File.Delete(sasTokenBlobPath);

            #endregion
        }
    }
}
