local function UltraEncrypt(code)
    local seed = math.random(10000, 99999)
    local key1 = math.random(1, 255)
    local key2 = math.random(1, 255)
    
    local parts = {}
    local encoded = {}
    
    for i = 1, #code do
        local char = string.byte(code, i)
        local encrypted = bit32.bxor(bit32.bxor(char, key1), key2)
        local offset = (i * seed) % 256
        
        table.insert(encoded, string.format("0x%X", encrypted + offset))
        key1 = (key1 + char) % 256
        key2 = (key2 + key1) % 256
    end
    
    table.insert(parts, string.format("local _=%d;", seed))
    table.insert(parts, string.format("local __=%d;", key1))
    table.insert(parts, string.format("local ___=%d;", key2))
    table.insert(parts, "local ____={")
    table.insert(parts, table.concat(encoded, ","))
    table.insert(parts, "};")
    
    table.insert(parts, [[
        local _____="";
        for ______,_______ in ipairs(____) do
            local ________=tonumber(_______,16)-(______*_)%256;
            local _________=bit32.bxor(bit32.bxor(________,__),___);
            _____=_____..string.char(_________);
            __=(__+_________)%256;
            ___=(___+__)%256;
        end
        local __________=loadstring or load;
        __________(_____)();
    ]])
    
    local result = table.concat(parts, "")
    
    pcall(function()
        setclipboard(result)
    end)
    
    return result
end





-- example
UltraEncrypt(print(1))
