mutable struct Monkey
    id::Int
    items::Vector{Int}
    operation
    test
    onTrue
    onFalse
    buf::Vector{Int}
    total::Int
    Monkey(id::Int, items::Vector{Int}, operation,
        test, onTrue, onFalse) = new(id, items, operation, test,
        onTrue, onFalse, [], 0)
end


function process(m::Monkey)
    m.total += length(m.items)
    for i in m.items
        n = convert(Int, floor(m.operation(i) / 3))
        if m.test(n)
            m.onTrue(n)
        else
            m.onFalse(n)
        end
    end
    m.items = []
end

function add_to_buf(m::Monkey, i::Int)
    append!(m.items, [i])
end

function complete(m::Monkey)
    #m.items = []
end


function input()
    monkeys = Vector{Monkey}([
        Monkey(0,
            [83, 88, 96, 79, 86, 88, 70],
            x -> x * 5,
            x -> x % 11 == 0,
            x -> add_to_buf(monkeys[3], x),
            x -> add_to_buf(monkeys[4], x)
        ),
        Monkey(1,
            [59, 63, 98, 85, 68, 72],
            x -> x * 11,
            x -> x % 5 == 0,
            x -> add_to_buf(monkeys[5], x),
            x -> add_to_buf(monkeys[1], x)
        ),
        Monkey(2,
            [90, 79, 97, 52, 90, 94, 71, 70],
            x -> x + 2,
            x -> x % 19 == 0,
            x -> add_to_buf(monkeys[6], x),
            x -> add_to_buf(monkeys[7], x)
        ), Monkey(3,
            [97, 55, 62],
            x -> x + 5,
            x -> x % 13 == 0,
            x -> add_to_buf(monkeys[3], x),
            x -> add_to_buf(monkeys[7], x)
        ),
        #4
        Monkey(4,
            [74, 54, 94, 76],
            x -> x * x,
            x -> x % 7 == 0,
            x -> add_to_buf(monkeys[1], x),
            x -> add_to_buf(monkeys[4], x)
        ),
        #5
        Monkey(5,
            [58],
            x -> x + 4,
            x -> x % 17 == 0,
            x -> add_to_buf(monkeys[8], x),
            x -> add_to_buf(monkeys[2], x)
        ),
        #6
        Monkey(6,
            [66, 63],
            x -> x + 6,
            x -> x % 2 == 0,
            x -> add_to_buf(monkeys[8], x),
            x -> add_to_buf(monkeys[6], x)
        ),
        #7
        Monkey(7,
            [56, 56, 90, 96, 68],
            x -> x + 7,
            x -> x % 3 == 0,
            x -> add_to_buf(monkeys[5], x),
            x -> add_to_buf(monkeys[2], x)
        ),
    ])
end


function test_input()
    monkeys = Vector{Monkey}([
        Monkey(0,
            [79, 98],
            x -> x * 19,
            x -> x % 23 == 0,
            x -> add_to_buf(monkeys[3], x),
            x -> add_to_buf(monkeys[4], x)
        ),
        Monkey(1,
            [54, 65, 75, 74],
            x -> x + 6,
            x -> x % 19 == 0,
            x -> add_to_buf(monkeys[3], x),
            x -> add_to_buf(monkeys[1], x)
        ),
        Monkey(2,
            [79, 60, 97],
            x -> x * x,
            x -> x % 13 == 0,
            x -> add_to_buf(monkeys[2], x),
            x -> add_to_buf(monkeys[4], x)
        ), Monkey(3,
            [74],
            x -> x + 3,
            x -> x % 17 == 0,
            x -> add_to_buf(monkeys[1], x),
            x -> add_to_buf(monkeys[2], x)
        ),
    ])
end

function part1()
    monkeys = input()
    for _ in 1:20
        for m in monkeys
            process(m)
        end
        for m in monkeys
            complete(m)
        end
    end

    scores = collect(sort(map(x -> x.total, monkeys)))

    println(scores[end-1] * scores[end])
end

part1()