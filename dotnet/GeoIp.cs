using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using CsvHelper;
using StackExchange.Redis;

namespace hello.redis.dotnet
{
    public class GeoIp
    {
        private readonly Func<IDatabase> _redis;

        public GeoIp(Func<IDatabase> redis)
        {
            _redis = redis ?? throw new ArgumentNullException(nameof(redis));
        }

        public async Task<int> ImportGeoLiteLegacyAsync(TextReader reader)
        {
            using (var csv = new CsvReader(reader))
            {
                csv.Configuration.RegisterClassMap(new GeoLiteLegacyMap());
                csv.Configuration.HasHeaderRecord = false;

                var result = await ImportAsync(csv.GetRecords<IpCountry>());
                return result;
            }
        }

        public async Task<int> ImportAsync(IEnumerable<IpCountry> ipCountries)
        {
            var count = 0;
            foreach (var r in ipCountries)
            {
                var fields = new[]{
                    new HashEntry("code", r.Code),
                    new HashEntry("country", r.Name),
                    new HashEntry("min", r.MinIpAddress),
                    new HashEntry("max", r.MaxIpAddress)
                };
                await _redis().HashSetAsync("geoip:" + r.Code, fields);

                var name = r.Code + ":" + count.ToString();
                await _redis().SortedSetAddAsync("geoip:index", name, r.MaxIpNumber);

                count++;
            }

            return count;
        }

        public Task<long> CountAsync()
        {
            return _redis().SortedSetLengthAsync("geoip:index");
        }

        public Task<IpCountry> LookupAsync(string ipAddress)
        {
            return LookupAsync(IPAddress.Parse(ipAddress));
        }

        public async Task<IpCountry> LookupAsync(IPAddress ip)
        {
            var num = ip.ToNumber();
            var values = await _redis().SortedSetRangeByScoreAsync("geoip:index", start: num, exclude: Exclude.Stop, take: 1);
            if (values.Length > 0)
            {
                string key = values[0];
                var hashes = await _redis().HashGetAllAsync("geoip:" + key.Substring(0, 2));

                var country = new IpCountry()
                {
                    Code = hashes.First(h => h.Name == "code").Value,
                    Name = hashes.First(h => h.Name == "country").Value,
                    MinIpAddress = hashes.First(h => h.Name == "min").Value,
                    MaxIpAddress = hashes.First(h => h.Name == "max").Value
                };

                country.MinIpNumber = IPAddress.Parse(country.MinIpAddress).ToNumber();
                country.MaxIpNumber = IPAddress.Parse(country.MaxIpAddress).ToNumber();

                return country;
            }


            return null;
        }
    }
}