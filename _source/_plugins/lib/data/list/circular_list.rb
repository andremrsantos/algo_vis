module DataStructure::List

  class CircularList < ListBase
    def initialize
      clear
    end

    def shift_right
      @start = @start.next
    end

    def shift_left
      @start = @start.last
    end

    def append(key)
      if empty?
        init(key)
      else
        node = DoubleLinkNode.new(key, start_node, end_node)
        end_node.next = node
        start_node.last = node
      end
      @size += 1
    end

    def shift
      if size == 0
        clear
      else
        size -= 1
        tmp = start_node
        end_node.next = tmp.next
        start_node.next.last = tmp.last
        tmp.key
      end
    end

    def contains?(key)
      current = start_node
      begin
        return true if current.key == key
        current = current.next
      end until current == start_node
      false
    end

    def each
      unless empty?
        current = start_node
        begin
          yield current.key
          current = current.next
        end until current == start_node
      end
      self
    end

    def concat(*items)
      items.each { |item| concat_item(item) }
      self
    end

    protected

    def init(key)
      node = DoubleLinkNode.new(key, nil, nil)
      node.last = node
      node.next = node

      @start = node
    end

    def concat_item(item)

      case item
      when DoubleLinkNode || CircularList
        l_start = item.start_node
        l_end = item.end_node

        l_start.last = end_node
        l_end.next = start_node

        end_node.next = l_start
        start_node.last = l_end
      when Enumerable
        item.each { |i| append(i) }
      when Comparable
        append(item)
      else
        throw ArgumentError "List is not compatible"
      end

    end

    def end
      @start.last
    end

    alias_method :unshift, :append
    alias_method :pop, :shift
  end

end