require_relative '../lib/linked_list'

RSpec.describe LinkedList do
  let(:list) { described_class.new }
  example_values = Proc.new do
    list.append(2)
    list.append(3)
    list.append(4)
  end

  describe "starts out empty with size 0" do
    it "head is nil" do
      expect(list.head).to be nil
    end

    it "tail is nil" do
      expect(list.tail).to be nil
    end

    it "size is 0" do
      expect(list.size).to eq(0)
    end
  end

  describe "#append" do
    describe "adds node to empty list," do
      before { list.append(2) }

      it "head is node with that value" do
        expect(list.head.value).to eq(2)
      end

      it "tail is node with that value" do
        expect(list.tail.value).to eq(2)
      end

      it "size is 1" do
        expect(list.size).to eq(1)
      end
    end

    describe "adds multiple nodes to list in succession" do
      before(&example_values)

      it "head is first appended node" do
        expect(list.head.value).to eq(2)
      end

      it "tail is last appended value" do
        expect(list.tail.value).to eq(4)
      end

      it "size is the number of nodes" do
        expect(list.size).to eq(3)
      end

      it "nodes are linked properly" do
        aggregate_failures do
          expect(list.head.next.value).to eq(3)
          expect(list.head.next.next).to eq(list.tail)
        end
      end

      it "tail points to nil" do
        expect(list.tail.next).to be nil
      end
    end
  end

  describe "#prepend" do
    describe "adds node to empty list," do
      before { list.append(2) }

      it "head is node with that value" do
        expect(list.head.value).to eq(2)
      end

      it "tail is node with that value" do
        expect(list.tail.value).to eq(2)
      end

      it "size is 1" do
        expect(list.size).to eq(1)
      end
    end

    describe "adds multiple nodes to list in succession" do
      before do
        list.prepend(2)
        list.prepend(3)
        list.prepend(4)
      end

      it "head is last prepended node" do
        expect(list.head.value).to eq(4)
      end

      it "tail is first prepended value" do
        expect(list.tail.value).to eq(2)
      end

      it "size is the number of nodes" do
        expect(list.size).to eq(3)
      end

      it "nodes are linked properly" do
        aggregate_failures do
          expect(list.head.next.value).to eq(3)
          expect(list.head.next.next).to eq(list.tail)
        end
      end

      it "tail points to nil" do
        expect(list.tail.next).to be nil
      end
    end
  end

  describe "#at" do
    it "returns nil if list is empty" do
      expect(list.at(0)).to be nil
    end

    describe "returns node at given index" do
      before(&example_values)

      it "index 0 is head" do
        expect(list.at(0)).to eq(list.head)
      end

      it "last index is tail" do
        expect(list.at(2)).to eq(list.tail)
      end

      it "higher index than list length returns nil" do
        expect(list.at(list.size)).to be nil
      end
    end
  end

  describe "#pop" do
    it "leaves size unchanged for empty list" do
      list.pop
      list.pop

      expect(list.size).to eq(0)
    end

    describe "removes last element" do
      before(&example_values)

      it "returns removed element" do
        expect(list.pop).to eq(4)
      end

      it "returns nil when no more elements to pop" do
        3.times { list.pop }
        expect(list.pop).to be nil
      end

      it "reassigns the tail" do
        list.pop
        expect(list.tail).to equal(list.head.next)
      end

      it "makes the new tail point to nil" do
        list.pop
        expect(list.tail.next).to be nil
      end

      it "decrements the list size" do
        list.pop
        expect(list.size).to eq(2)
      end

      it "removes head and tail when last element is popped" do
        3.times { list.pop }
        aggregate_failures do
          expect(list.head).to be nil
          expect(list.tail).to be nil
        end
      end
    end
  end

  describe "#each" do
    before(&example_values)

    it "iterates over all elements" do
      elements = []
      list.each { |value| elements << value }

      expect(elements).to eq([2, 3, 4])
    end
  end

  describe "#contains?" do
    before(&example_values)

    it "gives same result as include?" do
      aggregate_failures do
        expect(list.contains?(2)).to eq(list.include?(2))
        expect(list.contains?(10)).to eq(list.include?(10))
      end
    end
  end

  describe "#find" do
    before(&example_values)

    it "returns index of found value" do
      expect(list.find(4)).to eq(2)
    end

    it "returns nil if element not found" do
      expect(list.find(10)).to be nil
    end
  end

  describe "#to_s" do
    before(&example_values)

    it "returns a string representation of the list" do
      expect(list.to_s).to eq("( 2 ) -> ( 3 ) -> ( 4 ) -> nil")
    end
  end

  describe "#insert_at" do
    before(&example_values)

    describe "inserting at index of size works like append" do
      before { list.insert_at(5, list.size) }

      it "tail points to new node" do
        expect(list.tail.value).to eq(5)
      end

      it "new node is properly connected" do
        expect(list.head.next.next.next).to equal(list.tail)
      end
    end

    describe "inserting at index 0 works like prepend" do
      before { list.insert_at(1, 0) }

      it "head points to new node" do
        expect(list.head.value).to eq(1)
      end

      it "new node is properly connected" do
        expect(list.head.next.value).to eq(2)
      end
    end

    describe "inserting in middle" do
      before { list.insert_at(10, 1) }

      it "new node is connected properly" do
        aggregate_failures do
          expect(list.head.next.value).to eq(10)
          expect(list.head.next.next.value).to eq(3)
        end
      end

      it "size gets incremented" do
        expect(list.size).to eq(4)
      end
    end
  end

  describe "#remove_at" do
    before(&example_values)

    describe "removing at end of list works like pop" do
      it "returns removed element" do
        expect(list.remove_at(list.size - 1)).to eq(4)
      end

      it "returns nil when no more elements to pop" do
        3.times { list.remove_at(list.size - 1) }
        expect(list.remove_at(list.size - 1)).to be nil
      end

      it "reassigns the tail" do
        list.remove_at(list.size - 1)
        expect(list.tail).to equal(list.head.next)
      end

      it "makes the new tail point to nil" do
        list.remove_at(list.size - 1)
        expect(list.tail.next).to be nil
      end

      it "decrements the list size" do
        list.remove_at(list.size - 1)
        expect(list.size).to eq(2)
      end

      it "removes head and tail when last element is popped" do
        3.times { list.remove_at(list.size - 1) }
        aggregate_failures do
          expect(list.head).to be nil
          expect(list.tail).to be nil
        end
      end
    end

    describe "removing at index 0" do
      it "returns removed element" do
        expect(list.remove_at(0)).to eq(2)
      end

      it "reassigns the head" do
        expect(list.head.value).to eq(2)
      end
    end

    describe "removing at middle index" do
      it "returns removed element" do
        expect(list.remove_at(1)).to eq(3)
      end

      it "correctly connects the nodes" do
        list.remove_at(1)
        expect(list.head.next.value).to eq(4)
      end
    end
  end
end
