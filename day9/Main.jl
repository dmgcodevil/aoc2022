

DIRS = IdDict(
    "U" => [-1, 0],
    "D" => [1, 0],
    "L" => [0, -1],
    "R" => [0, 1]
)
DEBUG_MODE = false

function debug(s::Any)
    if DEBUG_MODE
        println(s)
    end
end

# checks if a connected to b
function connected(a::Array{Int}, b::Array{Int})::Bool
    for m in [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
        if a[1] + m[1] == b[1] && a[2] + m[2] == b[2]
            return true
        end
    end
    false
end

# connects a to b
function connect(a::Array{Int}, b::Array{Int})
    debug("connect $a -> $b")
    i = a[1] - b[1]
    j = a[2] - b[2]

    if i >= 1 && j == 0
        #up
        a[1] -= 1
        debug("move: U")
    elseif i < 0 && j == 0
        #down
        a[1] += 1
        debug("move: D")
    elseif i == 0 && j >= 1
        # left
        a[2] -= 1
        debug("move: L")
    elseif i == 0 && j < 0
        # right
        a[2] += 1
        debug("move: R")
    elseif i > 0 && j > 0
        # top-left
        a[1] -= 1
        a[2] -= 1
        debug("move: TL")
    elseif i > 0 && j < 0
        # top-right
        a[1] -= 1
        a[2] += 1
        debug("move: TR")
    elseif i < 0 && j > 0
        # botto-left
        a[1] += 1
        a[2] -= 1
        debug("move: BL")
    elseif i < 0 && j < 0
        # bottom-right
        a[1] += 1
        a[2] += 1
        debug("move: BR")
    end
end


function move(h::Array{Int}, t::Array{Int}, dir::String, steps::Int, visited::Set{String})
    if steps == 0
        return
    end
    m = DIRS[dir]
    h[1] += m[1]
    h[2] += m[2]
    push!(visited, string(t[1]) * "," * string(t[2]))

    while !connected(t, h)
        connect(t, h)
        push!(visited, string(t[1]) * "," * string(t[2]))
    end
    move(h, t, dir, steps - 1, visited)

end

function move2(rope::Vector{Array{Int}}, dir::String, steps::Int, visited::Set{String})
    if steps == 0
        return
    end
    m = DIRS[dir]
    head = first(rope)
    tail = last(rope)
    head[1] += m[1]
    head[2] += m[2]
    push!(visited, string(tail[1]) * "," * string(tail[2]))


    for i in 2:10
        a = rope[i]
        b = rope[i-1]
        while !connected(a, b)
            connect(a, b)
        end
    end
    push!(visited, string(tail[1]) * "," * string(tail[2]))
    move2(rope, dir, steps - 1, visited)

end


function part1()
    h = [5, 1]
    t = [5, 1]
    visited = Set{String}()
    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            parts = split(line, " ")
            debug("process: " * line)
            move(h, t, string(parts[1]), parse(Int, parts[2]), visited)
            debug("h: $h, t: $t")
            debug(visited)
            debug("====================")
        end
    end
    debug(visited)
    println(length(visited))
end

function write(out::IOStream, m::Int, n::Int, rope::Vector{Array{Int}})
    m = Array{Char}(undef, m, n)
    fill!(m, '.')
    for i in eachindex(rope)
        p = rope[i]
        if i == 1
            m[p[1], p[2]] = 'H'
        elseif i == 10
            m[p[1], p[2]] = 'T'
        else
            m[p[1], p[2]] = Char('0' + i)
        end
    end

    for r in eachrow(m)
        write(out, join(r))
        write(out, "\n")
    end
    write(out, "\n\n")
end

function part2()
    rope = Vector{Array{Int}}()
    for _ in 1:10
        append!(rope, [[16, 12]])
    end
    visited = Set{String}()
    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            parts = split(line, " ")
            debug("process: " * line)
            move2(rope, string(parts[1]), parse(Int, parts[2]), visited)
            debug(visited)
        end
    end
    debug(visited)
    println(length(visited))
end

part1()
part2()