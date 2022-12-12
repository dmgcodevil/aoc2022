
#2-4 -> {2,4}
function parse_range(s::String)::Array{Int}
    arr = split(s, "-")
    [parse(Int, arr[1]), parse(Int, arr[2])]
end

# checks if r1 fully covers r2
function iscover(r1::Array{Int}, r2::Array{Int})::Bool
    r1[1] <= r2[1] && r1[2] >= r2[2]
end

# checks of r1 overlaps with r2
function isoverlap(r1::Array{Int}, r2::Array{Int})
    r1[1] <= r2[1] && r1[2] >= r2[1]
end

function part1()
    res = 0
    open("input.txt") do f
        while !eof(f)
            ranges = split(readline(f), ",")
            r1 = parse_range(string(ranges[1]))
            r2 = parse_range(string(ranges[2]))
            if iscover(r1, r2) || iscover(r2, r1)
                res += 1
            end    
        end
    end
    println("answer: " * string(res))
end

function part2()
    res = 0
    open("input.txt") do f
        while !eof(f)
            ranges = split(readline(f), ",")
            r1 = parse_range(string(ranges[1]))
            r2 = parse_range(string(ranges[2]))
            if isoverlap(r1, r2) || isoverlap(r2, r1)
                res += 1
            end    
        end
    end
    println("answer: " * string(res))
end
# part1()

part2()



