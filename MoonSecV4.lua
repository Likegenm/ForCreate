local function QuantumEncrypt(code)
    math.randomseed(tick())
    
    local keys = {}
    for i=1,8 do keys[i]=math.random(1,65535) end
    
    local chunks = {}
    for i=1,#code,16 do
        table.insert(chunks,code:sub(i,i+15))
    end
    
    local encrypted_chunks = {}
    local chunk_keys = {}
    
    for i,chunk in ipairs(chunks) do
        local chunk_key = {}
        for j=1,4 do chunk_key[j]=math.random(1,4294967295) end
        chunk_keys[i]=chunk_key
        
        local encrypted = {}
        for j=1,#chunk do
            local char = string.byte(chunk,j)
            for k=1,4 do
                char = bit32.bxor(char,bit32.extract(chunk_key[k],(j-1)*8,8))
            end
            table.insert(encrypted,char)
        end
        encrypted_chunks[i]=encrypted
    end
    
    local key_obf = {}
    for i=1,#keys do
        key_obf[i] = string.format("0x%08X",keys[i]*7919%4294967296)
    end
    
    local chunk_data = {}
    for i,chunk in ipairs(encrypted_chunks) do
        local chunk_str = {}
        for j,val in ipairs(chunk) do
            local obf_val = bit32.bxor(val,keys[(i+j)%#keys+1])
            table.insert(chunk_str,string.format("0x%02X",obf_val))
        end
        table.insert(chunk_data,"{"..table.concat(chunk_str,",").."}")
    end
    
    local chunk_key_data = {}
    for i,keys in ipairs(chunk_keys) do
        local key_str = {}
        for j,key in ipairs(keys) do
            table.insert(key_str,string.format("0x%08X",key))
        end
        table.insert(chunk_key_data,"{"..table.concat(key_str,",").."}")
    end
    
    local output = {
        "local _={",
        table.concat(key_obf,","),
        "};",
        "local __={",
        table.concat(chunk_key_data,","),
        "};",
        "local ___={",
        table.concat(chunk_data,","),
        "};",
        [[
        local ____=function(a,b,c)
            for d=1,4 do
                a=bit32.bxor(a,bit32.extract(b[d],(c-1)*8,8))
            end
            return a
        end
            
        local _____=""
        for ______,_______ in ipairs(___) do
            for _________,__________ in ipairs(_______) do
                local ___________=tonumber(__________,16)
                local ____________=bit32.bxor(___________,_[(______+_________)%#_+1])
                local _____________=____(____________,__[______],_________)
                _____=_____..string.char(_____________)
            end
        end
            
        local ______________=loadstring or load
        local _______________=______________(_____)
        if _______________ then _______________() end
        ]]
    }
    
    local final = table.concat(output,"")
    
    pcall(function()
        setclipboard(final)
    end)
    
    return final
end





--[[ example 
QuantumEncrypt(print(1))
]]
