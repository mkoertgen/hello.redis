using System;
using System.Net;

namespace hello.redis.dotnet
{
    public static class IpAddressExtensions
    {
        public static long ToNumber(this IPAddress ip)
        {
            var num = (uint)IPAddress.NetworkToHostOrder(BitConverter.ToInt32(ip.GetAddressBytes(), 0));
            return num;
        }
    }
}