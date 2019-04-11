using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;

namespace CosmosDBCreate
{
    public class Program
    {
        public static void Main(string[] args)
        {
            string endpointUrl = "https://rim-demo-cosmosdb-cosmos.documents.azure.com:443/";
            string authorizationKey = "";

            ProcessAsync(endpointUrl, authorizationKey).GetAwaiter().GetResult();

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }

        private static async Task ProcessAsync(string endpointUrl, string authorizationKey)
        {
            DocumentClient client = new DocumentClient(new Uri(endpointUrl), authorizationKey);

            #region Create a database.

            string databaseId = "Data01";

            // Check if the database already exists.

            Database database = client.CreateDatabaseQuery().Where(db => db.Id == databaseId).AsEnumerable().FirstOrDefault();

            if (database == null)
            {
                Console.WriteLine("Database does not exist");
                database = await client.CreateDatabaseAsync(new Database { Id = databaseId });
            }

            Console.WriteLine($"Database id: {database.Id}, self-link: {database.SelfLink}");

            #endregion

            #region List databases.

            FeedResponse<Database> databases = await client.ReadDatabaseFeedAsync();

            foreach (Database feedDatabase in databases)
            {
                Console.WriteLine(feedDatabase);
            }

            #endregion

            #region Get a database.

            database = await client.ReadDatabaseAsync(UriFactory.CreateDatabaseUri(databaseId));

            Console.WriteLine(database);

            #endregion

            #region Create a collection.



            #endregion
        }
    }
}
