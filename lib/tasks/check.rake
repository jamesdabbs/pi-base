namespace :check do
  desc 'Check for Counterexamples consistency and new proofs'
  task :email => :environment do
    # Check for discrepancies from Counterexamples
    print "Checking for discrepancies ... "
    diffs = Trait::Table::Checker.new.check
    CheckMailer.report(diffs).deliver unless diffs.empty?
    puts "done. Found #{diffs}."

    # Check for provable facts
    Theorem.all.each { |t| t.explore }
  end

  desc "Check and print readible diffs"
  task :print => :environment do
    diffs = Trait::Table::Checker.new.check.map(&:first).reject(&:deduced).group_by(&:space)
    diffs.each do |space, traits|
      puts "#{space.name} ( #{space.id} )"
      e, ne = traits.partition { |t| t.description.empty? }
      puts "  Empty descriptions"
      e.each { |t| puts "    - #{t.id} ) #{t.property} = #{t.value}" }
      puts "  Non-empty Descriptions"
      ne.each do |t|
        puts "    - #{t.id} ) #{t.property} = #{t.value}"
        puts "      #{t.description}"
      end
      puts
    end
  end
end
