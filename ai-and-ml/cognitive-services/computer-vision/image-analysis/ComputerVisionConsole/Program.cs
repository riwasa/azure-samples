using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;

namespace ImageAnalyze
{
    public class Program
    {
        // subscriptionKey = "0123456789abcdef0123456789ABCDEF"
        private const string subscriptionKey = "1945c84f06ae4a56bdafde83d78a8166";

        // localImagePath = @"C:\Documents\LocalImage.jpg"
        //private const string localImagePath = @"..\..\..\..\Winter.jpg";
        //private const string localImagePath = @"..\..\..\..\Wolf.jpg";
        //private const string localImagePath = @"..\..\..\..\celeb1.jpg";
        //private const string localImagePath = @"..\..\..\..\celeb2.jpg";
        //private const string localImagePath = @"..\..\..\..\land1.jpg";
        //private const string localImagePath = @"..\..\..\..\land2.jpg";
        private const string localFolder = @"..\..\..\..\TestImages";

        private const string remoteImageUrl =
            "http://upload.wikimedia.org/wikipedia/commons/3/3c/Shaki_waterfall.jpg";

        // Specify the features to return
        private static readonly List<VisualFeatureTypes> features =
            new List<VisualFeatureTypes>()
        {
            VisualFeatureTypes.Categories, VisualFeatureTypes.Description,
            VisualFeatureTypes.Faces, VisualFeatureTypes.ImageType,
            VisualFeatureTypes.Tags, VisualFeatureTypes.Adult, VisualFeatureTypes.Color, VisualFeatureTypes.Objects
        };

        static void Main(string[] args)
        {
            ComputerVisionClient computerVision = new ComputerVisionClient(
                new ApiKeyServiceClientCredentials(subscriptionKey),
                new System.Net.Http.DelegatingHandler[] { });

            // You must use the same region as you used to get your subscription
            // keys. For example, if you got your subscription keys from westus,
            // replace "westcentralus" with "westus".
            //
            // Free trial subscription keys are generated in the "westus"
            // region. If you use a free trial subscription key, you shouldn't
            // need to change the region.

            // Specify the Azure region
            computerVision.Endpoint = "https://eastus2.api.cognitive.microsoft.com";

            Console.WriteLine("Images being analyzed ...");
            //var t1 = AnalyzeRemoteAsync(computerVision, remoteImageUrl);
            //var t2 = AnalyzeLocalAsync(computerVision, localImagePath);
            var t2 = AnalyzeLocalFolderAsync(computerVision, localFolder);

            //Task.WhenAll(t1, t2).Wait(5000);
            Task.WhenAll(t2).Wait(5000);
            Console.WriteLine("Press ENTER to exit");
            Console.ReadLine();
        }

        // Analyze a remote image
        private static async Task AnalyzeRemoteAsync(ComputerVisionClient computerVision, string imageUrl)
        {
            if (!Uri.IsWellFormedUriString(imageUrl, UriKind.Absolute))
            {
                Console.WriteLine("\nInvalid remoteImageUrl:\n{0} \n", imageUrl);
                return;
            }

            ImageAnalysis analysis = await computerVision.AnalyzeImageAsync(imageUrl, features);
            DisplayResults(analysis, imageUrl);
        }

        // Analyze a local image
        private static async Task AnalyzeLocalAsync(ComputerVisionClient computerVision, string imagePath)
        {
            if (!File.Exists(imagePath))
            {
                Console.WriteLine("\nUnable to open or read localImagePath:\n{0} \n", imagePath);
                return;
            }

            using (Stream imageStream = File.OpenRead(imagePath))
            {
                ImageAnalysis analysis = await computerVision.AnalyzeImageInStreamAsync(imageStream, features);
                DisplayResults(analysis, imagePath);
            }
        }

        private static async Task AnalyzeLocalFolderAsync(ComputerVisionClient computerVision, string folder)
        {
            if (!Directory.Exists(folder))
            {
                Console.WriteLine("\nUnable to open local folder:\n{0} \n", folder);
                return;
            }

            foreach (string file in Directory.EnumerateFiles(folder))
            {
                await AnalyzeLocalAsync(computerVision, file);
            }
        }

        // Display the most relevant caption for the image
        private static void DisplayResults(ImageAnalysis analysis, string imageUri)
        {
            Console.WriteLine(imageUri);

            if (analysis.Description != null)
            {
                if (analysis.Description.Captions != null)
                {
                    Console.WriteLine("    Captions");

                    foreach (ImageCaption caption in analysis.Description.Captions)
                    {
                        Console.WriteLine($"        Caption: {caption.Text}, confidence: {caption.Confidence}");
                    }
                }

                if (analysis.Description.Tags != null)
                {
                    Console.WriteLine("    Description tags:");

                    foreach (string tag in analysis.Description.Tags)
                    {
                        Console.WriteLine($"        Tag: {tag}");
                    }
                }
            }

            if (analysis.Faces != null)
            {
                Console.WriteLine("    Faces:");

                foreach (FaceDescription face in analysis.Faces)
                {
                    Console.WriteLine($"        Gender: {face.Gender}, age: {face.Age}");
                }
            }

            if (analysis.Tags != null)
            {
                Console.WriteLine("    Image tags:");

                foreach (ImageTag tag in analysis.Tags)
                {
                    Console.WriteLine($"        Name: {tag.Name}, confidence: {tag.Confidence}");
                }
            }

            if (analysis.Categories != null)
            {
                Console.WriteLine("    Categories:");

                foreach (Category category in analysis.Categories)
                {
                    Console.WriteLine($"        Category: {category.Name}, score: {category.Score}");

                    if (category.Detail != null)
                    {
                        if (category.Detail.Celebrities != null)
                        {
                            Console.WriteLine("            Celebrities:");

                            foreach (CelebritiesModel celebrity in category.Detail.Celebrities)
                            {
                                Console.WriteLine($"                Celebrity: {celebrity.Name}, confidence: {celebrity.Confidence}");
                            }
                        }

                        if (category.Detail.Landmarks != null)
                        {
                            Console.WriteLine("            Landmarks:");

                            foreach (LandmarksModel landmark in category.Detail.Landmarks)
                            {
                                Console.WriteLine($"                Landmark: {landmark.Name}, confidence: {landmark.Confidence}");
                            }
                        }
                    }
                }
            }

            Console.WriteLine($"    Is adult: {analysis.Adult.IsAdultContent}, Adult score: {analysis.Adult.AdultScore}");
            Console.WriteLine($"    Is racy: {analysis.Adult.IsRacyContent}, Racy score: {analysis.Adult.RacyScore}");
        }
    }
}