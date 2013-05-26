class ReplaceMathDelimiters < ActiveRecord::Migration
  def update obj, prop
    obj.send :"#{prop}=", obj.send(prop).gsub(/\\\(|\\\)/, '$')
  end

  def change

    [Space, Property].each do |model|
      model.all.each do |obj|
        update obj, :name
        update obj, :description
        obj.save!
      end
    end

    [Trait, Theorem].each do |model|
      model.where("`description` LIKE '%\(%'").each do |obj|
        update obj, :description
        obj.save!
      end
    end

  end
end
