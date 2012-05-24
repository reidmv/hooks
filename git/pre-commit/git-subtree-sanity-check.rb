#!/usr/bin/env ruby

MODULE_PATTERNS = [
  %r{^modules/internal/\w+/},
  %r{^modules/public/\w+/},
  %r{^data/},
  %r{^manifests/}
]

def owning_module(path)
  MODULE_PATTERNS.each do |pattern|
    result = path.match(pattern) || next
    return result[0]
  end
  :"(superproject)"
end

def reject(module1, module2)
  puts '.-------------------------------------------- Cross Module Commit ---'
  puts '| COMMIT REJECTED!'
  puts "| Module 1: #{module1}"
  puts "| Module 2: #{module2}"
  puts '| Citation: Attempt to make commits referencing two seperate modules'
  puts '| Solution: Do not make commits which reference more than one module.'
  puts '|           When making changes to multiple modules, make multiple'
  puts '|           commits.'
  puts '|'
  puts '| Module Patterns Are:'
  MODULE_PATTERNS.each do |pattern|
    puts "|   #{pattern.inspect.sub('/', '').sub(/\/$/, '').gsub('\/','/')  }"
  end
  puts '`--------------------------------------------------------------------'
end

module1 = nil
IO.popen("git diff --cached --name-only").each do |path|
  module1 ||= owning_module(path)
  module2   = owning_module(path)
  if module1 != module2
    reject(module1, module2)
    exit 1
  end
end
