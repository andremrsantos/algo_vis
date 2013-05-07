module DataStructure::Heap

  class BinaryHeap < HeapBase

    def initialize(type = :min)
      # Define the kind of Heap to be implemented: Min or Max
      @comparator = COMPARATOR[type] || COMPARATOR[:min]

      # Define working variables
      @queue = []
      @keys  = {}
      @size  = 0
    end

    def size
      return @size
    end

    def contains?(key)
      ! get(key).nil?
    end

    def insert(key, value = key)
      throw DataStructure::IndexTakenError key if contains?(key)

      @queue[size] = key
      @keys[key]   = { value: value, position: size }
      @size += 1
      swim
      self
    end

    alias_method :push, :insert

    def top
      @queue.first
    end

    def remove
      exchange(first, last)

      head = @queue.pop
      @size -= 1
      sink

      @keys.delete(head)
      head
    end

    alias_method :pop, :remove

    def change_key(key, new_value)
      throw DataStructure::NoSuchElementError key unless contains?(key)

      get(key)[:value] = new_value

      sink(position(key))
      swim(position(key))
    end

    def to_s
      node_to_s
    end

    private

    def get(key)
      @keys[key]
    end

    def key_at(node)
      @queue[node]
    end

    def value(key)
      get(key)[:value]
    end

    def position(key)
      get(key)[:position]
    end

    def first
      0
    end

    def last
      size - 1
    end

    def swim(node = last)
      while better_than_father?(node)
        father = father(node)
        exchange(node, father)
        node = father
      end
    end

    def better_than_father?(node)
      node > 0 && compare(node, father(node))
    end

    def father(node)
      (node-1)/2
    end

    def sink(node = first)
      while has_sons(node)
        son = next_son(node)
        if compare(son, node)
          exchange(son, node)
          node = son
        else
          break
        end
      end
    end

    def has_sons(node)
      (2*node + 1) < size
    end

    def next_son(node)
      son_a, son_b = sons(node)
      (son_b <= last && compare(son_b, son_a)) ? son_b : son_a
    end

    def sons(node)
      son = 2*node + 1
      [son, (son+1)]
    end

    def exchange(from, to)
      # Update Priority Queue
      tmp = @queue[from]
      @queue[from] = @queue[to]
      @queue[to] = tmp

      # Update Position
      get(key_at(from))[:position] = from
      get(key_at(to))[:position] = to
    end

    def compare(x, y)
      super(value(key_at(x)), value(key_at(y)))
    end

    def node_to_s(node=first, lvl=0)
      return '' if node >= size

      son_a, son_b = sons(node)
      str = '| '*lvl
      str << "\\_(#{@queue[node]}) #{value(@queue[node])}\n"
      str << node_to_s(son_a, lvl+1)
      str << node_to_s(son_b, lvl+1)
    end

  end

end