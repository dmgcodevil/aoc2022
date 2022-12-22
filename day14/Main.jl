struct Point
    x::Int
    y::Int
    Point(s::String) = begin
        arr = split(s, ",")
        new(parse(Int, arr[1]), parse(Int, arr[2]))
    end

    Point(x::Int, y::Int) = new(x, y)

end

function move(p::Point, x::Int, y::Int)::Point
    Point(p.x + x, p.y + y)
end

function load(path)::Set{Point}
    points = Set{Point}()
    open(path) do f
        while !eof(f)
            line = readline(f)
            arr = split(line, " -> ")
            for i in 1:length(arr)-1
                p1 = Point(string(arr[i]))
                p2 = Point(string(arr[i+1]))
                push!(points, p1)
                push!(points, p2)
                if p1.x == p2.x
                    min_y = min(p1.y, p2.y)
                    max_y = max(p1.y, p2.y)
                    for y in min_y+1:max_y-1
                        push!(points, Point(p1.x, y))
                    end
                elseif p1.y == p2.y
                    min_x = min(p1.x, p2.x)
                    max_x = max(p1.x, p2.x)
                    for x in min_x+1:max_x-1
                        push!(points, Point(x, p1.y))
                    end
                else
                    throw(DomainError(string(p1) * " -> " * string(p2),
                        "illegal input"))
                end
            end
        end
    end
    points
end

const moves = [
    [0, 1],  # down
    [-1, 1], #  left
    [1, 1]   # rignt
]

function fall(p::Point, min_x::Int, max_y::Int)::Bool
    p.x < min_x || p.y > max_y
end

function part1()
    points = load("input.txt")

    min_x = typemax(Int)
    max_y = 0

    for p in points
        min_x = min(min_x, p.x)
        max_y = max(max_y, p.y)
    end

    println("min x: " * string(min_x))
    println("max y: " * string(max_y))

    count = 0

    while (true)
        p = Point(500, 0)
        while (true)
            proceed = false
            for m in moves
                next = move(p, m[1], m[2])
                # println("p: " * string(p) * "next: " * string(next))
                if !in(next, points)
                    # println("next: not in" * string(next))
                    p = next
                    proceed = true
                    break
                end
            end
            if !proceed
                # println("settle: " * string(p))
                push!(points, p)
                count += 1
                break
            end
            if fall(p, min_x, max_y)
                # println("fall: " * string(p))
                println("res: " * string(count))
                return
            end

        end
    end
end

function part2()
    points = load("input.txt")

    min_x = typemin(Int)
    max_y = 0

    for p in points
        max_y = max(max_y, p.y)
    end
    max_y += 2

    println("min x: " * string(min_x))
    println("max y: " * string(max_y))

    count = 0

    while (true)
        p = Point(500, 0)
        while (true)
            proceed = false
            for m in moves
                next = move(p, m[1], m[2])
                # println("p: " * string(p) * "next: " * string(next))
                if !in(next, points) && next.y != max_y
                    # println("next: not in" * string(next))
                    p = next
                    proceed = true
                    break
                end
            end
            if !proceed
                # println("settle: " * string(p))
                push!(points, p)
                count += 1
                if p.x == 500 && p.y == 0
                    println("res2: " * string(count))
                return
                end
                break
            end
            # if fall(p, min_x, max_y)
            #     # println("fall: " * string(p))
            #     println("res: " * string(count))
            #     return
            # end

        end
    end
end

part2()