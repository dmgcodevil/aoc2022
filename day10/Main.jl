abstract type AbstactOp end

struct Noop <: AbstactOp
    cycles::Int
    Noop() = new(1)
end

struct Add <: AbstactOp
    x::Int
    cycles::Int
    Add(x) = new(x, 2)
end

mutable struct Reg
    x::Int
    Reg() = new(1)
end

function cycles(op::Noop)
    op.cycles
end

function cycles(op::Add)
    op.cycles
end


function exec(r::Reg, ::AbstactOp)
end

function exec(r::Reg, add::Add)
    r.x += add.x
end

CYCLES = Set{Int}([20, 60, 100, 140, 180, 220])

struct Node{T}
    x::T
    next::Union{Node{T},Nothing}
    Node{T}(x::T) where {T} = new(x, nothing)
    Node{T}(x::T, next::Node{T}) where {T} = new(x, next)
end

function part1()
    ops = Vector{AbstactOp}()
    r = Reg()
    res = 0

    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            op = Noop()
            if line != "noop"
                op = Add(parse(Int, split(line, " ")[2]))
            end
            append!(ops, [op])
        end
    end
    i = 1
    next = cycles(ops[i])
    println(ops)
    for tick in 1:220
        if in(tick, CYCLES)
            println("tick: " * string(r.x))
            res += (tick * r.x)
        end
        if tick == next
            exec(r, ops[i])
            i += 1
            next += cycles(ops[i])
        end

    end
    println(res)
end

function load_ops()
    ops = Vector{AbstactOp}()
    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            op = Noop()
            if line != "noop"
                op = Add(parse(Int, split(line, " ")[2]))
            end
            append!(ops, [op])
        end
    end
    ops
end


function part1()
    ops = load_ops()
    r = Reg()
    res = 0
    i = 1
    next = cycles(ops[i])
    cycle = 1
    while i <= length(ops)
        if in(cycle, CYCLES)
            res += (cycle * r.x)
        end
        if cycle == next
            exec(r, ops[i])
            i += 1
            if i <= length(ops)
                next += cycles(ops[i])
            end
        end
        cycle += 1
    end
    println(res)
end

function part2()
    ops = load_ops()
    r = Reg()
    screen = Vector{Vector{Char}}([[]])
    i = 1
    next = cycles(ops[i])
    cycle = 1
    while i <= length(ops)
        pos = length(last(screen))
        line = last(screen)
        if pos == r.x - 1 || pos == r.x || pos == r.x + 1
            append!(line, ['#'])
        else
            append!(line, ['.'])
        end
        if length(last(screen)) == 40
            append!(screen, [[]])
        end
        if cycle == next
            exec(r, ops[i])
            i += 1
            if i <= length(ops)
                next += cycles(ops[i])
            end
        end
        cycle += 1
    end
    for line in screen
        println(join(line))
    end
end

#part2()
part1()
