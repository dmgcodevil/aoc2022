# using Pkg
# Pkg.add("DataStructures");
using DataStructures;

const moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]

function can_move(from::Char, to::Char)::Bool
    if (to == 'E')
        return from + 1 == 'z' || from == 'z'
    end
    return from == 'S' || from + 1 == to || from >= to
end

function find_start(grid::Vector{Vector{Char}},
    points::Set{Char})::Vector{Vector{Int}}
    res = Vector{Vector{Int}}()
    for i in eachindex(grid)
        for j in eachindex(grid[i])
            if in(grid[i][j], points)
                append!(res, [[i, j]])
            end
        end
    end
    return res
end

function load(path)::Vector{Vector{Char}}
    grid = Vector{Vector{Char}}()
    open(path) do f
        while !eof(f)
            line = readline(f)
            append!(grid, [collect(line)])
        end
    end
    return grid
end

function test_input()
    return load("test-input.txt")
end

function input()
    return load("input.txt")
end

function shortest(grid::Vector{Vector{Char}}, start::Array{Int})::Int
    m = length(grid)
    n = length(grid[1])
    visited = zeros(Int, m, n)
    for row in eachrow(visited)
        fill!(row, typemax(Int))
    end
    visited[start[1], start[2]] = 0
    q = Queue{Array{Int}}()
    enqueue!(q, [start[1], start[2], 0])

    while !isempty(q)
        size = length(q)
        while (size > 0)
            p = dequeue!(q)
            i = p[1]
            j = p[2]
            steps = p[3]
            if grid[i][j] == 'E'
                return steps
            end
            for move in moves
                x = i + move[1]
                y = j + move[2]
                if x >= 1 && x <= m && y >= 1 && y <= n && steps + 1 < visited[x, y] &&
                   can_move(grid[i][j], grid[x][y])
                    visited[x, y] = steps + 1
                    enqueue!(q, [x, y, steps + 1])
                end
            end
            size -= 1
        end
    end
    return -1
end

function part1()
    grid = input()
    for s in find_start(grid, Set{Char}(['S']))
        println(shortest(grid, s))
    end
end

function part2()
    grid = input()
    res = typemax(Int)
    for s in find_start(grid, Set{Char}(['S', 'a']))
        tmp = shortest(grid, s)
        if tmp != -1
            res = min(res, tmp)
        end
    end
    println(res)
end

part2()
