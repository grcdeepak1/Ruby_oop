require 'pry'
# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
	DONE_MARKER = 'X'
	UNDONE_MARKER = ' '

	attr_accessor :title, :description, :done

	def initialize(title, description='')
		@title = title
		@description = description
		@done = false
	end

	def done!
		self.done = true
	end

	def done?
		done
	end

	def undone!
		self.done = false
	end

	def to_s
		"[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
	end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
  	raise TypeError, 'can only add Todo objects' unless todo.instance_of? Todo
  	@todos << todo
  end
  alias_method :<<, :add

  def size
  	@todos.size
  end

  def first
  	@todos.first
  end

  def last
  	@todos.last
  end

  def item_at(idx)
  	@todos.fetch(idx)
  end

  def mark_done_at(idx)
  	item_at(idx).done!
  end

  def mark_undone_at(idx)
  	item_at(idx).undone!
  end

  def shift
  	@todos.shift
  end

  def pop
  	@todos.pop
  end

  def remove_at(idx)
  	@todos.delete(item_at(idx))
  end

  def to_s
  	text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
  end

  def to_a
    @todos
  end

  def done?
    @todos.all? {|todo| todo.done? }
  end

  def each
  	@todos.each do |todo|
  		yield(todo)
  	end
  	self
  end

  def select
  	list = TodoList.new(title)
  	each do |todo|
  	  list.add(todo) if yield(todo)
    end
    list
  end

  def find_by_title(title)
  	each do |todo|
  		return todo if todo.title == title
  	end
  	nil
  end

  def all_done
  	return select { |todo| todo.done? }
  end

  def all_not_done
  	return select { |todo| todo.done? == false }
  end

  def mark_done(title)
  	find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
  	each { |todo| todo.done! }
  end

  def mark_all_undone
  	each { |todo| todo.undone! }
  end

  def count
    return @todos.count
  end
end

# given
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")


# ---- Adding to the list -----

# add
list.add(todo1)                 # adds todo1 to end of list, returns list
list.add(todo2)                 # adds todo2 to end of list, returns list
list.add(todo3)                 # adds todo3 to end of list, returns list

# # ---- Outputting the list -----

# # to_s
# list.to_s

# # ---- Interrogating the list -----
# #binding.pry
# # size
# list.size                       # returns 3

# # first
# list.first                      # returns todo1, which is the first item in the list

# # last
# list.last                       # returns todo3, which is the last item in the list

# result1 = list.each do |todo|
#   					puts todo                   # calls Todo#to_s
# 					end

# puts result1.inspect

# todo1.done!
# results = list.select { |todo| todo.done? }    # you need to implement this method
# puts results.inspect

# result1 = list.find_by_title("Buy milk")
# result2 = list.find_by_title("milk")
# puts result1.inspect
# puts result2.inspect

# result1 = list.all_done
# result2 = list.all_not_done
# puts result1.inspect
# puts result2.inspect

# result1 = list.mark_done("Clean room")
# list.to_s

# result2 = list.mark_all_done
# list.to_s

# result3 = list.mark_all_undone
# list.to_s