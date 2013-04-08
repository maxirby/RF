class House < ActiveRecord::Base
  #flag = 2 normal first fill database; 3 = fake; 4 = sold; 5 = new;
  attr_accessible :counter, :description, :flag, :title
end
