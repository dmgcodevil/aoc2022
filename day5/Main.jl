
mutable struct Stack
    crates::Vector{Char}
end

function remove_last!(s::Stack, n::Int)::Vector{Char}
    res = s.crates[end-n+1:end]
    s.crates = s.crates[begin:end-n]
    res
end

function add!(s::Stack, v::Vector{Char})
    append!(s.crates, v)
end

function move!(from::Stack, to::Stack, n::Int)
    add!(to, reverse(remove_last!(from, n)))
end

function part1()
    height = 8
    weight = 9
    step = 4 # from current label to the next
    stacks = [Stack([]) for _ = 1:weight]
    open("input.txt") do f
        h = 0
        while h < height
            i = 2
            line = readline(f)
            for j in 1:weight
                label = line[i]
                if label != ' '
                    add!(stacks[j], [label])
                end
                i += step
            end
            h += 1
        end
        readline(f) # skip index footer
        readline(f)
        for s in stacks
            reverse!(s.crates) # just b/c I'm too lazy (hint: use stack)
        end
        while !eof(f)
            line = readline(f)
            parts = split(line)
            amount = parse(Int, parts[2])
            from = parse(Int, parts[4])
            to = parse(Int, parts[6])
            move!(stacks[from], stacks[to], amount)
        end
    end
    res = ""
    for s in stacks
        res *= string(last(s.crates))
    end
    println(res)
end

part1()
