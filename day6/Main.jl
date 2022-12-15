

function getmarker(n_distinct::Int)::Int
    i = 1
    ans = -1
    map = IdDict{Char,Int}()
    open("input.txt") do f
        line = readline(f)
        chars = collect(line)
        for j in eachindex(chars)
            if length(map) == n_distinct
                ans =  j - 1
                break
            end
            if haskey(map, chars[j])
                k = map[chars[j]]
                while i <= k
                    delete!(map, chars[i])
                    i += 1
                end
            end
            map[chars[j]] = j
        end
    end
    ans
end


println(getmarker(14))

# s = "abc"
# c=collect(s)[1]
# set=Set{Char}()
# push!(set, c)
# println(set)