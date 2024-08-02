function love.load()
    gbf = require 'gbfCompiler'
    gbf.load()
    code = love.filesystem.read("code.gbf")
    gbf.start(code)
end