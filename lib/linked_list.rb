class Node
  attr_accessor :value, :next

  def initialize(value = nil)
    @value = value
    @next = nil
  end

  def ==(other)
    if other.is_a?(Node)
      @value == other.value
    else
      @value == other
    end
  end
end

class LinkedList
  include Enumerable

  attr_reader :size, :head, :tail

  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  def append(value)
    node = Node.new(value)

    if @tail
      @tail.next = node
      @tail = node
    else
      @head = @tail = node
    end

    @size += 1
  end

  def prepend(value)
    node = Node.new(value)

    if @head
      node.next = @head
      @head = node
    else
      @head = @tail = node
    end

    @size += 1
  end

  def at(index)
    current = @head
    i = 0

    while i < index && current != nil
      current = current.next
      i += 1
    end

    current
  end

  def pop
    return if @size <= 0

    node = @tail
    @size -= 1
    @head = nil if node == @head

    @tail = at(size - 1)

    if @tail
      @tail.next = nil
    end

    node.value
  end

  def each
    current = @head
    while current != nil
      yield(current.value)
      current = current.next
    end
  end

  def contains?(valueToCheck)
    each { |value| return true if value == valueToCheck }
    false
  end

  def find(valueToFind)
    each_with_index { |value, index| return index if value == valueToFind }
    nil
  end

  def to_s
    result = reduce("") {|res, value| res + "( #{value} ) -> "}
    result += "nil"
  end
end
