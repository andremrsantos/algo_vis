module DataStructure::Heap

  class FibonacciHeap < HeapBase

    def initialize(type = :min)
      # Define the kind of Heap to be implemented: Min or Max
      @comparator = COMPARATOR[type] || COMPARATOR[:min]

      clear
    end

    def push(key, value = key)
      raise DataStructure::IndexTakenError index if contains?(key)

      node = FibonacciNode.new(key, value)

      if @next.nil?
        @next = node
      else
        @next.link(node)
        @next = node if compare(node.value, @next.value)
      end
      @size += 1
      @keys[key] = node
      self
    end

    alias_method :insert, :push
    alias_method :<<, :push

    def pop
      return nil if empty?

      removed = @next
      if size == 1
        clear
      else
        # Adding childs to root list
        if @next.has_child?
          # Remove their parent
          @next.each_child { |node| node.parent = nil }

          if @next.self_linked?
            @next = @next.child
          else
            @next.link(@next.child)
          end
        end
        # Deslocate head to right
        @next = @next.right
        @size -= 1
        removed.pop

        consolidate
      end
      @keys[removed.key] = nil

      removed.key
    end

    alias_method :remove, :pop

    def change_key(key, new_value)
      raise NoSuchElementError key unless contains?(key)

      if compare(new_value, get(key))
        rise(key, new_value)
      else
        sink(key, new_value)
      end
    end

    def peek
      @next and @next.value
    end

    alias_method :next, :peek

    def contains?(index)
      !@keys[index].nil?
    end

    def get(index)
      @keys[index].value
    end

    def clear
      @next = nil
      @size = 0
      @keys = {}
      nil
    end

    def empty?
      @next.nil?
    end

    def merge!(other)
      unless other.kind_of? Heap::FibonacciHeap
        raise ArgumentError 'Can only merge to FibonacciHeap'
      end

      other_root = other.instance_variable_get('@next')
      if other_root
        @keys = @keys.merge(other.instance_variable_get('@keys'))
        @next.link(other_root)

        @next = other_root if compare(other_root.value, @next.value)
      end
      @size += other.size
    end

    def to_s
      return '' if @next.nil?
      str = ''
      @next.each_sibling { |node| str << node.to_s }
      str
    end

    protected

    def consolidate
      roots = []
      @next.each_sibling { |node| roots << node }

      top = @next
      degrees = []

      roots.each do |root|

        top = root if compare(root.value, top.value)
        degree = root.degree

        if degrees[degree].nil?
          degrees[degree] = root
        else
          until degrees[degree].nil?
            other = degrees[degree]
            smaller, larger = if compare(other.value, root.value)
                                [root, other]
                              else
                                [other, root]
                              end
            larger.add(smaller)
            degrees[degree] = nil
            root = larger
            degree += 1
          end
          degrees[degree] = root
          top = root if top.value == root.value
        end

      end

      @next = top
    end

    def rise(key, new_value)
      node = @keys[key]

      node.value = new_value
      parent = node.parent

      if parent && compare(new_value, parent.value)
        cut(node)
        cascade_cut(parent)
      end

      @next = node if compare(new_value, @next.value)
    end

    def cut(node)
      parent = node.parent
      parent.degree -= 1

      if parent.degree == 0
        parent.child = nil
      elsif parent.child == node
        parent.child = node.right
      end

      node.pop
      node.parent = nil
      node.marked = false
      @next.link(node)
    end

    def cascade_cut(node)
      parent = node.parent
      return nil if parent.nil?

      if node.marked
        cut(node)
        cascade_cut(parent)
      else
        node.marked = true
      end
    end

    def sink(key, new_value)
      removed = @keys[key]
      removed.parent = nil
      removed.degree = 0
      removed.value = new_value

      # clear father
      removed.each_child { |node| node.parent = nil } if removed.has_child?

      @next.link(removed.child)
      removed.child = nil
      removed.pop
      @next.link(removed)

      consolidate
    end

    class FibonacciNode
      attr_accessor :parent, :child, :left, :right,
                    :key, :value, :degree, :marked

      def initialize(key, value)
        self.key = key
        self.value = value
        self.degree = 0
        self.marked = false
        self.right = self
        self.left = self
      end

      def add(node)
        node.pop
        node.parent = self

        if child.nil?
          self.child = node
        else
          self.child.link(node)
        end

        self.degree += 1
        self.marked = false
      end

      alias_method :<<, :add

      def link(node)
        self.right.left = node.left
        node.left.right = self.right

        node.left = self
        self.right = node
      end

      def pop
        # Remove the node from its list
        left.right = right
        right.left = left

        # Make it self linked
        self.left = self.right = self
      end

      def has_child?
        !child.nil?
      end

      def self_linked?
        right == self
      end

      def each_sibling
        yield self
        sibling = right
        until sibling == self
          yield sibling
          sibling = sibling.right
        end
      end

      def each_child
        return nil unless has_child?

        yield child
        sibling = child.right
        until sibling == child
          yield sibling
          sibling = sibling.right
        end
      end

      def to_s(lvl = 0)
        str = '| ' * lvl
        str << "\\_ ([#{key}] --> #{value})\n"
        each_child { |child| str << child.to_s(lvl + 1) }
        str
      end
    end
  end

end