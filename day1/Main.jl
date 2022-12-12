function part1()
    max = 0
    curr = 0
    open("input.txt") do f
        while !eof(f)
            s = readline(f)
            if isempty(s)
                max = Base.max(max, curr)
                curr = 0
            else
                curr += parse(Int64, s)
            end
        end
    end
    println("answer: " * string(max))
end

#part1()

function part2()
    top1 = 0
    top2 = 0
    top3 = 0
    curr = 0
    open("input.txt") do f
        while !eof(f)
            s = readline(f)
            if isempty(s)
                if curr >= top1
                    tmp1 = top1
                    tmp2 = top2
                    top1 = curr
                    top2 = tmp1
                    top3 = tmp2
                elseif curr >= top2
                    tmp1 = top2
                    top2 = curr
                    top3 = tmp1
                elseif curr > top3
                    top3 = curr
                end
                curr = 0
            else
                curr += parse(Int64, s)
            end
        end
    end
    println("answer: " * string(top1 + top2 + top3))
end

part2()