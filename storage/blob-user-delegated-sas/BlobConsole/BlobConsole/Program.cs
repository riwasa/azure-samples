using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;

using Microsoft.Extensions.Configuration;

// Example of using user delegation SAS to interact with blob storage.
// See https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-user-delegation-sas-create-dotnet for more info.

// Get application configuration, including .NET user secrets.
var config = new ConfigurationBuilder()
    .AddUserSecrets<Program>()
    .Build();

// Get a client for the Blob service for the Storage Account.
BlobServiceClient blobServiceClient = GetServicePrincpalBlobServiceClient(config);

// Get a blob-scoped user delegated SAS token.
Uri blobUri = await CreateBlobSasToken(blobServiceClient, "files", "test.pdf");

// Upload the blob using the blob-scoped user delegated SAS token.
await UploadBlobUsingBlobSasToken(blobUri, Directory.GetCurrentDirectory() + "\\test.pdf");

// Get a container-scoped user delegated SAS token.
//Uri blobContainerUri = await CreateContainerSasToken(blobServiceClient, "files");

// Upload the blob using the container-scoped user delegated SAS tokenb.
//await UploadBlobUsingContainerSasToken(blobContainerUri, Directory.GetCurrentDirectory() + "\\test.pdf", "test.pdf");

// Gets a blob service client for a Service Principal.
static BlobServiceClient GetServicePrincpalBlobServiceClient(IConfigurationRoot config)
{
    // Get Storage Account info from the .NET user secrets for the app.
    IConfigurationSection storageSection = config.GetSection("storage");

    string? storageAccountName = storageSection.GetSection("accountName").Value;

    string blobEndpoint = string.Format("https://{0}.blob.core.windows.net", storageAccountName);

    // Get Service Principal info from the .NET user secrets for the app.
    IConfigurationSection section = config.GetSection("sp");

    string? tenantId = section.GetSection("tenantId").Value;
    string? appId = section.GetSection("appId").Value;
    string? appPassword = section.GetSection("appPassword").Value;

    ClientSecretCredential credential = new ClientSecretCredential(tenantId, appId, appPassword);

    BlobServiceClient blobServiceClient = new BlobServiceClient(new Uri(blobEndpoint), credential);

    return blobServiceClient;
}

// Gets a user delegation key that can be used to create a user delegated SAS token.
static async Task<UserDelegationKey> GetUserDelegationKey(BlobServiceClient blobServiceClient)
{
    UserDelegationKey key = await blobServiceClient.GetUserDelegationKeyAsync(DateTimeOffset.UtcNow, DateTimeOffset.UtcNow.AddMinutes(15));

    return key;
}

// Create a user delegated SAS token to allow creation of a specific blob in a specific container.
static async Task<Uri> CreateBlobSasToken(BlobServiceClient blobServiceClient, string containerName, string blobName)
{
    // Get a user delegation key.
    UserDelegationKey key = await GetUserDelegationKey(blobServiceClient);

    // Get a client for the blob.
    BlobClient blobClient = blobServiceClient.GetBlobContainerClient(containerName).GetBlobClient(blobName);

    // Create a SAS token for the blob.
    BlobSasBuilder sasBuilder = new BlobSasBuilder()
    {
        BlobContainerName = containerName,
        BlobName = blobName,
        Resource = "b",
        StartsOn = DateTimeOffset.UtcNow,
        ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(1)
    };

    // Grant Create permissions only.
    sasBuilder.SetPermissions(BlobSasPermissions.Create);
    
    // Add the SAS token to the blob URI.
    BlobUriBuilder blobUriBuilder = new BlobUriBuilder(blobClient.Uri)
    {
        Sas = sasBuilder.ToSasQueryParameters(key, blobServiceClient.AccountName)
    };

    // Generate the blob URI.
    Uri uri = blobUriBuilder.ToUri();

    return uri;
}

// Create a user delegated SAS token to allow creation of blobs in a specific container.
static async Task<Uri> CreateContainerSasToken(BlobServiceClient blobServiceClient, string containerName)
{
    // Get a user delegation key.
    UserDelegationKey key = await GetUserDelegationKey(blobServiceClient);

    // Get a client for the container.
    BlobContainerClient blobContainerClient = blobServiceClient.GetBlobContainerClient(containerName);

    // Create a SAS token for the blob.
    BlobSasBuilder sasBuilder = new BlobSasBuilder()
    {
        BlobContainerName = containerName,
        Resource = "c",
        StartsOn = DateTimeOffset.UtcNow,
        ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(1)
    };

    // Grant Create permissions only.
    sasBuilder.SetPermissions(BlobSasPermissions.Create);

    // Add the SAS token to the container URI.
    BlobUriBuilder blobUriBuilder = new BlobUriBuilder(blobContainerClient.Uri)
    {
        Sas = sasBuilder.ToSasQueryParameters(key, blobServiceClient.AccountName)
    };

    // Generate the blob URI.
    Uri uri = blobUriBuilder.ToUri();

    return uri;
}

// Uploads a blob using a user delegated SAS token for a container and blob.
static async Task UploadBlobUsingBlobSasToken(Uri blobUri, string filePath)
{
    // Create a blob client using the provided URI with the SAS token.
    BlobClient blobSasClient = new BlobClient(blobUri, null);

    try
    {
        // If the blob already exists in blob storage, the upload will fail with the error
        // "This request is not authorized to perform blob overwrites."
        Console.WriteLine("Uploading blob");
        await blobSasClient.UploadAsync(filePath);

        // Try to download the blob the was just uploaded. This will fail with the error
        // "This request is not authorized to perform this operation using this permission."
        Console.WriteLine("Downloading blob");
        await blobSasClient.DownloadToAsync(filePath + ".new.pdf");
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex);
    }
}

/// Uploads a blob using a user delegated SAS token for a container.
static async Task UploadBlobUsingContainerSasToken(Uri blobContainerUri, string filePath, string blobName)
{
    // Create a blob client using the provided URI
    BlobContainerClient blobContainerSasClient = new BlobContainerClient(blobContainerUri);
    BlobClient blobClient = blobContainerSasClient.GetBlobClient(blobName);

    try
    {
        Console.WriteLine("Uploading blob");
        await blobClient.UploadAsync(filePath);

        // Try to download the blob the was just uploaded. This will fail with the error
        // "This request is not authorized to perform this operation using this permission."
        Console.WriteLine("Downloading blob");
        await blobClient.DownloadToAsync(filePath + ".new.pdf");
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex);
    }
}

