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
                if islowercase(ch)
                    res += ch - 'a' + 1
                else
                    res += ch - 'A' + 27
                end
            end
        end
    end
    println("answer: " * string(res))
end

part1()