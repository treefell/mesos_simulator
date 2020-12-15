needed criteo-mesos fork, mesos_command_module and mesos-wrapme

to make cpuset work you need a file /etc/mesos-wrapme-cpus.json 
with {\"available\":[0, 3], \"allocatable\":[0, 3]}" 
allocatable should show all the cpu, and available are all the cpu usable


