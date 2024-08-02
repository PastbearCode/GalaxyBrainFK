gbf = {}

function gbf.load()
    memory = {}
    pointer = 1
    output_buffer = ""
    for i = 1, 30000 do
        memory[i] = 0
    end
end

local function input()
    local char = io.read(1)
    if char then
        return string.byte(char)
    else
        return 0 -- EOF or no input
    end
end

function gbf.compile(code)
    local ip = 1
    local loopStack = {}

    while ip <= #code do
        local char = code[ip]
        if char == ">" then
            pointer = pointer + 1
            if pointer > #memory then pointer = 1 end
        elseif char == "<" then
            pointer = pointer - 1
            if pointer < 1 then pointer = #memory end
        elseif char == "+" then
            memory[pointer] = (memory[pointer] + 1) % 256
        elseif char == "-" then
            memory[pointer] = (memory[pointer] - 1) % 256
        elseif char == "," then
            memory[pointer] = input()
        elseif char == "." then
            io.write(string.char(memory[pointer]))
        elseif char == "*" then
            memory[pointer] = memory[pointer] * memory[pointer-1]
        elseif char == "/" then
            if memory[pointer-1] ~= 0 then
                memory[pointer] = memory[pointer] / memory[pointer-1]
            end
        elseif char == "^" then
            memory[pointer] = memory[pointer]^memory[pointer-1]
        elseif char == "§" then
            memory[pointer] = tointeger(math.sqrt(memory[pointer]))
        elseif char == ":" then
            for i=1,pointer do
                io.write(string.char(memory[i]))
            end
        elseif char == "~" then
            memory[pointer] = memory[pointer]*memory[pointer]
        elseif char == "[" then
            if memory[pointer] == 0 then
                local loopDepth = 1
                while loopDepth > 0 do
                    ip = ip + 1
                    if code[ip] == "[" then
                        loopDepth = loopDepth + 1
                    elseif code[ip] == "]" then
                        loopDepth = loopDepth - 1
                    end
                end
            else
                table.insert(loopStack, ip)
            end
        elseif char == "]" then
            if memory[pointer] ~= 0 then
                ip = loopStack[#loopStack] - 1
            else
                table.remove(loopStack)
            end
        end
        ip = ip + 1
    end
end

function gbf.start(gbfString)
    gbf.load()
    local gbfCode = {}
    for i = 1, #gbfString do
        gbfCode[i] = string.sub(gbfString, i, i)
    end
    gbf.compile(gbfCode)
end

return gbf
