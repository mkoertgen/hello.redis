using System;
using System.IO;
using System.Threading.Tasks;
using StackExchange.Redis;

namespace hello.redis.dotnet
{
    internal class Program
    {
        public static async Task Main()
        {
            var url = GetEnv("REDIS_URL", "localhost:6379");
            var conn = ConnectionMultiplexer.Connect($"{url}, allowadmin=true");

            // based on https://github.com/jittuu/RGeoIP, adapted for CsvHelper 6+
            var geoIp = new GeoIp(() => conn.GetDatabase());
            var csvFile = GetEnv("GEOIP_CSV", "GeoIPCountryWhois.csv");
            using (var reader = new StreamReader(csvFile))
            {
                var count = await geoIp.ImportGeoLiteLegacyAsync(reader);
                Console.WriteLine($"Imported {count} GeoIP Records.");
            }

            var ip = GetEnv("LOOKUP_IP", "1.1.2.245");
            var country = await geoIp.LookupAsync(ip);
            Console.WriteLine($"Looked up country for {ip}: '{country}'");
        }

        private static string GetEnv(string name, string defaultValue)
        {
            var value = Environment.GetEnvironmentVariable(name);
            return value ?? defaultValue;
        }
    }
}
