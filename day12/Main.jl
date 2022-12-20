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

function find_start(grid::Vector{Vector{Char}})
    for i in eachindex(grid)
        for j in eachindex(grid[i])
            if grid[i][j] == 'S'
                return (i, j)
            end
        end
    end
    throw(DomainError((i, j), "'S' not found"))
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

function part1()
    grid = input()
    m = length(grid)
    n = length(grid[1])
    visited = zeros(Int, m, n)
    for row in eachrow(visited)
        fill!(row, typemax(Int))
    end
    start = find_start(grid)
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
                println(steps)
                return
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

end

part1()
