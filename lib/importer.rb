class Importer
  def initialize db
    @db, @mapper = db, Mapper.new
  end

  def run!
    raise unless Rails.env.development?

    process :value_sets, ValueSet do |v|
      {
        name:       :name,
        created_at: :created_at,
        updated_at: :updated_at
      }
    end

    process :values, Value do |v|
      {
        name:         :name,
        value_set_id: lookup(ValueSet, v[:value_set_id]),
        created_at:   :created_at,
        updated_at:   :updated_at
      }
    end

    process :spaces, Space do |s|
      {
        name:        :name,
        description: :description,
        created_at:  :created_at,
        updated_at:  :updated_at
      }
    end

    process :properties, Property do |p|
      {
        value_set_id: lookup(ValueSet, p[:value_set_id]),
        name:         :name,
        description:  :description,
        created_at:   :created_at,
        updated_at:   :updated_at
      }
    end

    process :traits, Trait do |t|
      {
        space_id:    lookup(Space, t[:space_id]),
        property_id: lookup(Property, t[:property_id]),
        value_id:    lookup(Value, t[:value_id]),
        description: :description,
        deduced:     :deduced,
        created_at:  :created_at,
        updated_at:  :updated_at
      }
    end

    process :theorems, Theorem do |t|
      {
        description: :description,
        created_at:  :created_at,
        updated_at:  :updated_at,
        antecedent:  :antecedent,
        consequent:  :consequent
      }
    end

    process :theorem_properties, TheoremProperty do |t|
      {
        theorem_id: lookup(Theorem, t[:theorem_id]),
        property_id: lookup(Property, t[:property_id]),
      }
    end

    process :proofs, Proof do |p|
      {
        trait_id:      lookup(Trait, p[:trait_id]),
        theorem_id:    lookup(Theorem, p[:theorem_id]),
        theorem_index: :theorem_index,
        created_at:    :created_at,
        updated_at:    :updated_at,
      }
    end

    process :assumptions, Assumption do |a|
      {
        proof_id: lookup(Proof, a[:proof_id]),
        trait_id: lookup(Trait, a[:trait_id])
      }
    end

    process :supporters, Supporter do |s|
      implied_id = begin
        lookup Trait, s[:implied_id]
      rescue
        next
      end

      {
        assumed_id: lookup(Trait, s[:assumed_id]),
        implied_id: implied_id
      }
    end

    process :users, User do |u|
      ks = u.keys.reject { |k| k == :id }
      Hash[ ks.zip ks ]
    end

    process :versions, PaperTrail::Version do |v|
      klass = v[:item_type].constantize
      {
        item_type:      :item_type,
        item_id:        lookup(klass, v[:item_id]),
        event:          :event,
        whodunnit:      :whodunnit,
        object:         :object,
        created_at:     :created_at,
        object_changes: :object_changes
      }
    end
  end

  private #----------

  def process table, klass, &block
    klass.delete_all

    table = @db[table] if table.is_a? Symbol

    Rails.logger.info "Importing #{table.count} #{klass} records"

    ids = []
    Buffer.new klass do |buffer|
      table.each do |obj|
        begin
          hash = block.call obj
        rescue => e
          puts "#{klass.name}: #{e}"
          next
        end
        next unless hash
        hash.each { |k,v| hash[k] = obj.fetch(v) if v.is_a? Symbol }

        buffer << klass.new(hash)
        ids    << obj[:id]
      end
    end

    @mapper[klass] = Hash[ ids.zip(klass.pluck :id) ]
  end

  def lookup klass,key
    @mapper[klass,key]
  end
end
