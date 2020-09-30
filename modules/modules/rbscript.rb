#!/bin/env ruby
require 'json'

def createResource(resource) 
  resourceHash = Hash.new
  resourceHash.store('name', resource['name'])
  resourceHash.store('type', resource['type'])
  resourceHash.store('scalar', Hash['value', resource['scalar']['value']])
  return resourceLeftOver
end

#ratio must be equals or under 1
ratio = 0.25 
resourceUsageFile = ARGV[0]
output = ARGV[1]
File.write('tests', resourceUsageFile)
resourceUsageTxt = File.read(resourceUsageFile)
parsed = JSON.parse(resourceUsageTxt)
total = parsed['total']
if parsed.has_key?('executors') && parsed['executors'][0].has_key?('allocated') 
    allocated = parsed['executors'][0]['allocated']
  end
resourceLeftOver = Array.new
counter = 0
  puts allocated
  
  total.select{|resource| 
    resource['type'] == 'SCALAR'
  }.each{|resource|
    puts resource['name']
 
    if allocated
      allocated.select{|allocres|
        allocres['type'] == 'SCALAR'}
      allocated.each{|allocres|
        puts allocres['name']
        if allocres['name'] == resource['name']
          resourceLeftOver.push(Hash.new)
          resourceLeftOver[counter].store('name', allocres['name'])
          resourceLeftOver[counter].store('type', allocres['type'])
          puts "leftover: #{resource['scalar']['value'] - allocres['scalar']['value']}"
          value = resource['scalar']['value']*ratio - allocres['scalar']['value'] < 0 ? 0 : resource['scalar']['value']*ratio - allocres['scalar']['value']  
          resourceLeftOver[counter].store('scalar', Hash['value', value])
          puts "allocated resource: #{allocres['scalar']['value']}"
          puts "total resource: #{(resource['scalar']['value']*ratio)}"
          counter += 1
         end
      }
    else
      resourceLeftOver.push(Hash.new)
      resourceLeftOver[counter].store('name', resource['name'])
      resourceLeftOver[counter].store('type', resource['type'])
      resourceLeftOver[counter].store('scalar', Hash['value', (resource['scalar']['value']*ratio)])
      counter += 1
    end 
    }
   
resourceLeftOverString = resourceLeftOver.to_json.to_s

puts resourceLeftOverString
File.write(output, resourceLeftOverString)
