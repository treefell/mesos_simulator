needed criteo-mesos fork, mesos_command_module and mesos-wrapme

to make cpuset work you need a file /etc/mesos-wrapme-cpus.json 
with {\"available\":[0, 3], \"allocatable\":[0, 3]}" 
allocatable should show all the cpu, and available are all the cpu usable

Change the "values" for Resource Estimator and QoSController to other script
for the greedy one the script should be in mesos-wrapme which is a gem you
will need to build and install 
