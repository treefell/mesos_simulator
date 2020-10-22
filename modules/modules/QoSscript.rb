#!/bin/env ruby
require 'json'

def available(resourceUsage)
	total = resourceUsage['total'].select{|resource|
	  resource['type'] == 'SCALAR'}
	resourceUsage['executors'].each{|executor|
	  allocated = executor['allocated']
	  total.each{|totalres|

	    allocated.each{|allocres|
	      if totalres['name'] == allocres['name']
			totalres['scalar']['value'] = totalres['scalar']['value'] - allocres['scalar']['value']
	 	  end
	    }
      }
    }
	return total
end 

def addResources(total, allocated)
  total = total.select{|resource|
	resource['type'] == 'SCALAR'}.each{|totalres|
	  allocated.each{|freeres|
	  if totalres['name'] == freeres['name']
	  	totalres['scalar']['value'] = totalres['scalar']['value'] + freeres['scalar']['value']
	  end
	  }
	}
	return total
end


def resourceOverload(total)
  total.each{|resource|
	if resource['scalar']['value'].to_f <= 0
		return true
	end
  }
  return false
end



resourceUsageFile = ARGV[0]
output = ARGV[1]
resourceUsageTxt = File.read(resourceUsageFile)
parsed = JSON.parse(resourceUsageTxt)

availableRes = available(parsed)
puts "total ? " + parsed['total'].to_s
puts "available " + availableRes.to_s
puts "overload is "+ resourceOverload(availableRes).to_s

correctionsString = String.new
corrections = String.new
count = 0
isRevocable = false
usedResource = Hash.new

if parsed.has_key?('executors')
 if resourceOverload(available(parsed))
  parsed['executors'].each{|executor|
  	isrevocable = false
  	executor['allocated'].each{|resource|
		if resource.has_key?('revocable')
			isRevocable = true
			usedResource = resource
		end
  	}
    puts isRevocable 
	if isRevocable && resourceOverload(availableRes)
		#need to add up the resources to the total so we kill only the necessary resources
        availableRes = addResources(availableRes, executor['allocated'])
		puts "after addresources" +availableRes.to_s
		temp = Hash.new
		temp.store("executorId", executor['executorInfo']['executorId'])
		temp.store("frameworkId", executor['executorInfo']['frameworkId'])
		temp.store("containerId", executor['containerId'])
		if correctionsString.empty?
  			correctionsString = temp.to_json.to_s
		else
			correctionsString += ";"+temp.to_json.to_s
		end
	end
  }
  end
end
puts "corrections "+correctionsString
#File.write('qoscorrection', correctionsString)
#actual output = {QoScorrection}; {QoSCorrection}; ... 
#wished output = [{QoSCorrection}, {QoSCorrection}, ...]
File.write(output, correctionsString)
