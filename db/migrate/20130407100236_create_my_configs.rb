class CreateMyConfigs < ActiveRecord::Migration
  def change
    create_table :my_configs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
  def self.up
    # MyConfig.create!(:name => "counter", :value => "0");
  end

  def self.down
    # MyConfig.delete_all
  end
end
