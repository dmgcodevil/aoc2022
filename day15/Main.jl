# |x1 - x2| + |y1 - y2|


struct Point
    x::Int
    y::Int
    Point(s::String) = begin
        arr = split(s, ",")
        new(parse(Int, arr[1]), parse(Int, arr[2]))
    end

    Point(x::Int, y::Int) = new(x, y)

end

# (sensor, beacon)
function parse_point(s::String)::Tuple{Point,Point}
    #Sensor at x=8, y=7: closest beacon is at x=2, y=10
    arr = split(s, " ")
    sx = parse(Int, split(arr[3][1:end-1], "=")[2])
    sy = parse(Int, split(arr[4][1:end-1], "=")[2])
    bx = parse(Int, split(arr[9][1:end-1], "=")[2])
    by = parse(Int, split(arr[10], "=")[2])
    (Point(sx, sy), Point(bx, by))
end

function dist(p1::Point, p2::Point)
    abs(p1.x - p2.x) + abs(p1.y - p2.y)
end

struct Input
    sensors::Set{Point}
    beacons::Set{Point}
    distances::IdDict{Point,Int}
    pairs::Vector{Tuple{Point,Point}}
end

function load(path::String)::Input
    sensors = Set{Point}()
    beacons = Set{Point}()
    distaces = IdDict{Point,Int}() # sensor -> beacon distace
    pairs = Vector{Tuple{Point,Point}}()
    open(path) do f
        while !eof(f)
            line = readline(f)
            p = parse_point(line)
            append!(pairs, [p])
            sensor = p[1]
            beacon = p[2]
            push!(sensors, sensor)
            push!(beacons, beacon)
            distaces[sensor] = dist(sensor, beacon)
        end
    end
    Input(sensors, beacons, distaces, pairs)
end



function part1(path::String, y::Int)
    input = load(path)
    min_x = typemax(Int)
    max_x = 0

    all = union(input.sensors, input.beacons)
    println("input points count=" * string(length(all)))
    count = 0
    for p in all
        min_x = min(min_x, p.x)
        max_x = max(max_x, p.x)
    end

    max_dist = 0
    for d in values(input.distances)
        max_dist = max(max_dist, d)
    end

    min_x -= max_dist
    max_x += max_dist

    for x in min_x:max_x
        p = Point(x, y)
        if !in(p, input.beacons)
            for s in input.sensors
                if dist(s, p) <= get(input.distances, s, 0)
                    count += 1
                    break
                end
            end
        end
    end
    println(count)
end

part1("input.txt", 2000000)