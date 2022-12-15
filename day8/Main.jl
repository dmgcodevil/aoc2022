function visible(h::Int,
    i::Int, j::Int, grid::Vector{Vector{Int}}, dir::Array{Int})::Bool
    if i <= 1 || i >= length(grid) || j <= 1 || j >= length(grid[1])
        return true
    end
    x = i + dir[1]
    y = j + dir[2]
    h > grid[x][y] && visible(h, x, y, grid, dir)
end

function count_trees(h::Int,
    i::Int, j::Int, grid::Vector{Vector{Int}}, dir::Array{Int})::Int
    if i <= 1 || i >= length(grid) || j <= 1 || j >= length(grid[1])
        return 0
    end
    x = i + dir[1]
    y = j + dir[2]
    if h > grid[x][y]
        1 + count_trees(h, x, y, grid, dir)
    else
        1
    end
end

function load_input()
    matrix = Vector{Vector{Int}}()
    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            trees = map(x -> parse(Int, x), collect(line))
            append!(matrix, [trees])
        end
    end
    matrix
end

function part1()
    matrix = load_input()
    count = 0
    m = length(matrix)
    n = length(matrix[1])
    for i in 1:m
        for j in 1:n
            if visible(matrix[i][j], i, j, matrix, [0, -1]) ||
               visible(matrix[i][j], i, j, matrix, [0, 1]) ||
               visible(matrix[i][j], i, j, matrix, [-1, 0]) ||
               visible(matrix[i][j], i, j, matrix, [1, 0])
                count += 1
            end
        end
    end
    println(count)
end

function part2()
    matrix = load_input()
    res = 0
    m = length(matrix)
    n = length(matrix[1])
    for i in 1:m
        for j in 1:n
            res = max(res, count_trees(matrix[i][j], i, j, matrix, [0, -1]) *
                           count_trees(matrix[i][j], i, j, matrix, [0, 1]) *
                           count_trees(matrix[i][j], i, j, matrix, [-1, 0]) *
                           count_trees(matrix[i][j], i, j, matrix, [1, 0]))
        end
    end
    println(res)
end

# part1()

part2()