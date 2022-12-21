using DataStructures
abstract type Node end

struct IntNode <: Node
    x::Int
end

struct ListNode <: Node
    nodes::Vector{Node}
end

digits = Set{Char}([Char(x + '0') for x = 0:9])

tostring(n::IntNode)::String = string(n.x)

tostring(n::ListNode)::String = "[" * tostring(n.nodes) * "]"

add!(n::ListNode, i::Int) = append!(n.nodes, [IntNode(i)])

add!(a::ListNode, b::ListNode) = append!(a.nodes, [b])

function parselist(str::String)::Vector{Node}
    stack = Stack{Node}()
    res = Vector{Node}()
    i = 1
    while i <= length(str)
        if str[i] == '['
            push!(stack, ListNode([]))
            i += 1
        elseif str[i] == ']'
            n = pop!(stack)
            if length(stack) == 0
                append!(res, [n])
            else
                add!(first(stack), n)
            end
            i += 1
        elseif in(str[i], digits)
            number = ""
            while in(str[i], digits)
                number *= str[i]
                i += 1
            end
            add!(first(stack), parse(Int, number))
        else
            i += 1
        end
    end
    return res
end

function tostring(l::Vector{Node})::String
    res = Vector{String}()
    for x in l
        append!(res, [tostring(x)])
    end
    join(res, ",")
end

compare(a::IntNode, b::IntNode)::Int =
    if a.x == b.x
        0
    elseif a.x < b.x
        -1
    else
        1
    end

function compare(a::Vector{Node}, b::Vector{Node})
    i = 1
    j = 1
    cmp = 0
    while i <= length(a) && j <= length(b)
        cmp = compare(a[i], b[j])
        if cmp != 0
            break
        end
        i += 1
        j += 1
    end
    if cmp == 0
        if length(a) == length(b)
            0
        elseif length(a) < length(b)
            -1
        else
            1
        end
    else
        cmp
    end
end

compare(a::Vector{Node}, b::ListNode) = compare(a, b.nodes)

compare(a::ListNode, b::Vector{Node}) = compare(a.nodes, b)

compare(a::ListNode, b::ListNode) = compare(a.nodes, b.nodes)

compare(a::IntNode, b::ListNode) = compare(ListNode([a]), b.nodes)

compare(a::ListNode, b::IntNode) = compare(a, ListNode([b]))

isless(a::ListNode, b::ListNode) = compare(a, b) == -1

function load(path::String)::Vector{Tuple{Node,Node}}
    res = Vector{Tuple{Node,Node}}()
    open(path) do f
        while !eof(f)
            a = ListNode(parselist(readline(f)))
            b = ListNode(parselist(readline(f)))
            append!(res, [(a, b)])
            readline(f)
        end
    end
    return res
end

function part1()
    pairs = load("input.txt")
    res = 0
    for i in eachindex(pairs)
        if isless(pairs[i][1], pairs[i][2])
            res += i
            # println(i)
        end
    end
    println(res)

end

function part2()
    pairs = load("input.txt")
    all = Vector{Node}()
    for pair in pairs
        append!(all, [pair[1], pair[2]])
    end
    sort!(all, lt=(x, y) -> isless(x, y))

    # for n in all
    #     println(tostring(n))
    # end

    res = 0
    x = -1
    y = -1
    for i in eachindex(all)
        s = tostring(all[i])
        if s == "[[[2]]]"
            x = i
        elseif s == "[[[6]]]"
            y = i
        end
        if x != -1 && y != -1
            res = x * y
            break
        end
    end
    println(res)
end

# part1()
part2()