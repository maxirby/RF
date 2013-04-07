class House < ActiveRecord::Base
  #flag = 2 normal; 3 = fake; 4 = sold
  attr_accessible :counter, :description, :flag, :title
end
