mutable struct Node
    const name::String
    const child::IdDict{String,Node}
    const parent::Union{Node,Nothing}
    const file::Bool
    size::Int
end

function create(curr::Node, name::String, file::Bool, size::Int)
    if !haskey(curr.child, name)
        n = Node(name, IdDict{String,Node}(), curr, file, size)
        curr.child[name] = n
    end
    curr.child[name]
end

mutable struct FileSystem
    const root::Node
    curr::Node
    nodes::IdDict{String,Node}
    function FileSystem()
        n = Node("", IdDict{String,Node}(), nothing, false, 0)
        new(n, n, IdDict{String,Node}())
    end
end

function cd(fs::FileSystem, name::String)
    if ".." == name
        fs.curr = fs.curr.parent
    elseif "/" == name
        fs.curr = fs.root
    else
        if !haskey(fs.curr.child, name)
            create(fs.curr, name, false, 0)
        end
        fs.curr = fs.curr.child[name]
    end
end

function show(fs::FileSystem)
    show(fs.root, 1)
end

function show(n::Node, depth::Int)
    if n.file
        println(repeat(" ", depth) * "- " * n.name * " (file, size=$(n.size))")
    else
        println(repeat(" ", depth) * "/" * n.name * " (dir)")
    end

    for (_, c) in n.child
        show(c, depth * 2)
    end
end

fs = FileSystem()

# show(fs)
# cd(fs, "a")
# cd(fs, "b")
# cd(fs, "c")
# show(fs)

# println("curr: " * fs.curr.name)
# cd(fs, "..")
# println("curr: " * fs.curr.name)

function calc_size(fs::FileSystem, prefix::String, node::Node)::Int
    path = prefix * node.name
    size = 0
    if node.file
        fs.nodes[prefix*node.name] = node
        return node.size
    end
    if haskey(fs.nodes, path)
        size = fs.nodes[path]
    else
        for (_, c) in node.child
            size += calc_size(fs, path * "/", c)
        end
    end
    node.size = size
    fs.nodes[path] = node
    size
end

function part1()
    open("input.txt") do f
        while !eof(f)
            line = readline(f)
            parts = split(line, " ")
            cmd = ""
            if "\$" == parts[1]
                cmd = parts[2]
                if "cd" == cmd
                    # println("cd " * parts[3])
                    cd(fs, string(parts[3]))
                end
                # we can also check if cmd == "ls"    
            elseif "dir" == parts[1]
                create(fs.curr, string(parts[2]), false, 0)
            else
                # println("create file: " * string(parts[2]))
                create(fs.curr, string(parts[2]), true, parse(Int, parts[1]))
            end
        end
    end

    calc_size(fs, "", fs.root)
    used = fs.root.size

    free = 70000000 - used

    # println(values(fs.nodes))

    println("used: " * string(used))
    println("free: " * string(free))

    dirs = filter(x -> !x.file, collect(values(fs.nodes)))
    sort!(dirs, by=x -> x.size)
    for dir in dirs
        println("$(dir.name) $(dir.size)")
    end
    for dir in dirs
        if free + dir.size >= 30000000
            println("delete: " * dir.name * ", size=" * string(dir.size))
            break
        end
    end
    println(count)
end

part1()