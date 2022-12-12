
function getscore(ch::Char)::Int
    if islowercase(ch)
        ch - 'a' + 1
    else
        ch - 'A' + 27
    end
end

function part1()
    res = 0
    open("input.txt") do f
        while !eof(f)
            s = readline(f)
            mid::Int = length(s) / 2
            a = collect(Set(s[begin:mid]))
            b = collect(Set(s[mid+1:end]))
            errors = ∩(a, b)
            for ch in errors
                res += getscore(ch)
            end
        end
    end
    println("answer: " * string(res))
end

function part2()
    res = 0
    open("input.txt") do f
        while !eof(f)
            a = Set(collect(readline(f)))
            b = Set(collect(readline(f)))
            c = Set(collect(readline(f)))
            res += getscore(first(∩(∩(a, b), c)))
        end
    end
    println("answer: " * string(res))
end

#  part1()
part2()