module owlchain.crypto.hex;

import std.exception:enforce;
import owlchain.base.types:uint256;
import wrapper.sodium.utils:sodium_hex2bin,sodium_bin2hex;
import std.stdio:writefln;

string binToHex(in ubyte[] bin)
{
    return sodium_bin2hex(bin);
}
alias toHex = binToHex;

string hexAbbrev(in ubyte[] bin)
{
    size_t sz = bin.length;
    if (sz > 3)
    {
        sz = 3;
    }
    return binToHex(bin[0 .. sz]);
}

ubyte[] hexToBin(in string hex,string ignore=null)
{
    ubyte[] bin = new ubyte[hex.length];
    size_t  bin_len;
    string  hex_end;
    enforce(sodium_hex2bin(bin, hex, ignore, bin_len, hex_end) == 0);
    bin = bin[0 .. bin_len];
    return bin;
}
alias toBin = hexToBin;

@("hex")
@system
unittest{

    ubyte[][] binData = [
        cast(ubyte[]) x"12",
        cast(ubyte[]) x"12 34",
        cast(ubyte[]) x"12 34 56",
        cast(ubyte[]) x"12 34 56 78",
        cast(ubyte[]) x"12 34 56 78 90",
        cast(ubyte[]) x"12 34 56 78 90 ab",
        cast(ubyte[]) x"12 34 56 78 90 ab cd",
        cast(ubyte[]) x"12 34 56 78 90 AB CD EF"
    ];

    foreach(ubyte[] bin; binData){
        auto b1 = bin.toHex.toBin; // auto b1 = toBin(toHex(bin));
        assert(bin == b1);
    }

    assert(toHex(cast(ubyte[])x"12 34") == "1234");
    assert(toBin("12:34:56", ":") == x"12 34 56");

    writefln("hexToBin(binToHex((bin)) is done");
}
