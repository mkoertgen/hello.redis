using System;
using System.IO;
using CommandLine;
using StackExchange.Redis;

namespace hello.redis.dotnet
{
    internal class Program
    {
        public static int Main(string[] args)
        {
            return Parser.Default.ParseArguments<UploadOptions, LookupOptions>(args)
                .MapResult((UploadOptions opts) => Upload(opts), (LookupOptions opts) => Lookup(opts), errors => 1);
        }

        // ReSharper disable ClassNeverInstantiated.Local
        // ReSharper disable UnusedAutoPropertyAccessor.Local
        [Verb("upload", HelpText = "Upload GeoIP csv file into redis.")]
        private class UploadOptions
        {
            [Option('r', "redis", HelpText = "Redis Url.")]
            public string RedisUrl { get; set; }

            [Option('c', "csv", HelpText = "CSV File to be processed.")]
            public string CsvFile { get; set; }
        }

        [Verb("lookup", HelpText = "Lookup an IP from redis.")]
        private class LookupOptions
        {
            [Option('r', "redis", HelpText = "Redis Url.")]
            public string RedisUrl { get; set; }

            [Option('i', "ip", HelpText = "Ip to look up.")]
            public string Ip { get; set; }
        }
        // ReSharper restore ClassNeverInstantiated.Local
        // ReSharper restore UnusedAutoPropertyAccessor.Local

        private static int Upload(UploadOptions opts)
        {
            var url = opts.RedisUrl ?? GetEnv("REDIS_URL", "localhost:6379");
            var csvFile = opts.CsvFile ?? GetEnv("GEOIP_CSV", "GeoIPCountryWhois.csv");

            var conn = ConnectionMultiplexer.Connect($"{url}, allowadmin=true");
            var geoIp = new GeoIp(() => conn.GetDatabase());
            using (var reader = new StreamReader(csvFile))
            {
                Console.WriteLine($"Importing '{csvFile}...");
                var count = geoIp.ImportGeoLiteLegacyAsync(reader).Result;
                Console.WriteLine($"Imported {count} GeoIP Records.");
            }
            return 0;
        }

        private static int Lookup(LookupOptions opts)
        {
            var url = opts.RedisUrl ?? GetEnv("REDIS_URL", "localhost:6379");
            var ip = opts.Ip ?? GetEnv("LOOKUP_IP", "1.1.2.245");
            var conn = ConnectionMultiplexer.Connect($"{url}, allowadmin=true");
            var geoIp = new GeoIp(() => conn.GetDatabase());
            var lookup = geoIp.LookupAsync(ip).Result;
            Console.WriteLine($"Looked up country for {ip}: '{lookup.Name}'");
            return 0;
        }

        private static string GetEnv(string name, string defaultValue)
        {
            var value = Environment.GetEnvironmentVariable(name);
            return value ?? defaultValue;
        }
    }
}
