abstract type AbsractShape end

struct Rock <: AbsractShape end
struct Scissors <: AbsractShape end

struct Paper <: AbsractShape end

score(::Rock) = 1
score(::Paper) = 2
score(::Scissors) = 3

const ROCK = Rock()
const PAPER = Paper()
const SCISSORS = Scissors()

Base.isless(a::AbsractShape, b::AbsractShape) = false
Base.isless(a::Rock, b::Paper) = true
Base.isless(a::Paper, b::Scissors) = true
Base.isless(a::Scissors, b::Rock) = true

shapes = IdDict(
    "A" => ROCK, "B" => PAPER, "C" => SCISSORS,
    "X" => ROCK, "Y" => PAPER, "Z" => SCISSORS
)

winDict = IdDict(
    ROCK => PAPER,
    PAPER => SCISSORS,
    SCISSORS => ROCK
)

looseDict = IdDict(
    PAPER => ROCK,
    SCISSORS => PAPER,
    ROCK => SCISSORS
)

function part1()
    ans = 0
    open("input.txt") do f
        while !eof(f)
            s = readline(f)
            arr = split(s)
            a = shapes[string(arr[1])]
            b = shapes[string(arr[2])]
            ans += score(b)
            if b > a
                # I won
                ans += 6
            elseif b == a
                ans += 3
            end
        end
    end
    println(ans)
end

function part2()
    ans = 0
    open("input.txt") do f
        while !eof(f)
            s = readline(f)
            arr = split(s)
            a = shapes[string(arr[1])]
            res = string(arr[2])
            b = a # draw
            if res == "X" # loose
                b = looseDict[a]
            elseif res == "Z" # win
                b = winDict[a]
            end
            ans += score(b)
            if b > a
                # I won
                ans += 6
            elseif b == a
                ans += 3
            end
        end
    end
    println(ans)
end

part2()