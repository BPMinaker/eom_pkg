function the_system=baja_revised_alt(tf,varargin)

the_system=baja_revised(tf,varargin);


for i=1:length(the_system.item)
	if(strcmp( the_system.item{i}.name ,'Left link'))
		n=i;
	end
end
the_system.item{n}.body2='Chassis';

for i=1:length(the_system.item)
	if(strcmp( the_system.item{i}.name ,'Right link'))
		n=i;
	end
end
the_system.item{n}.body2='Chassis';

for i=1:length(the_system.item)
	if(strcmp( the_system.item{i}.name ,'Anti roll bar'))
		n=i;
	end
end
k=the_system.item{n}.stiffness;
the_system.item{n}.stiffness=2*k;