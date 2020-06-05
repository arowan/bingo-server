# require "./jsonable"
#
# module Bingo
#   class Row < JSONable
#     attr_reader :values
#
#     def initialize(values = [])
#       @values = values
#     end
#
#     def pick(array)
#       @values << array.shuffle!.pop
#     end
#
#     # def check(used)
#     #   (@values.compact - used).empty?
#     # end
#   end
# end
