class Importer
  class Mapper
    def initialize
      @map = {}
    end

    def []= klass,map
      @map[klass] = map
    end

    def [] klass,id
      @map.fetch(klass).fetch(id)
    end
  end
end
