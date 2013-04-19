module DataStructure
  module List

    class ListBase
      attr_reader :size

      alias_method :add, :append
      alias_method :remove, :shift

      alias_method :peek, :first

      def initialize
        throw NotImplementedError 'Abstract class, please use an child'
      end

      def clear
        @start = nil
        @end = nil
        @size = 0
      end

      def empty?
        @size <= 0
      end

      def first
        @start.nil? ? nil : @start.key
      end

      def last
        @end.nil? ? nil : @end.key
      end

      protected

      SingleLinkNode = Struct.new(:key, :next)
      DoubleLinkNode = Struct.new(:key, :next, :last)
      # Must implement the following operations:
      # - add
      # - remove
      # - contains? (key)
      # - get
      # - size
    end

  end
end