using CsvHelper.Configuration;

namespace hello.redis.dotnet
{
    public sealed class GeoLiteLegacyMap : ClassMap<IpCountry>
    {
        public GeoLiteLegacyMap()
        {
            Map(m => m.MinIpAddress).Index(0);
            Map(m => m.MaxIpAddress).Index(1);
            Map(m => m.MinIpNumber).Index(2);
            Map(m => m.MaxIpNumber).Index(3);
            Map(m => m.Code).Index(4);
            Map(m => m.Name).Index(5);
        }
    }
}