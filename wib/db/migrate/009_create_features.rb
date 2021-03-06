class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.column :name, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :features
  end
end
