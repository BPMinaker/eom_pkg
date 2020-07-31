function the_system=input_ex_10_dof(varargin)
the_system.name='10 dof Model';
the_system.item={};


	item.type='body';
	item.mass=1;

for i=1:5
	item.name=['lower block ' num2str(i)];
	item.location=[i;0;0];
	the_system.item{end+1}=item;

	item.name=['upper block ' num2str(i)];
	item.location=[i;1;0];
	the_system.item{end+1}=item;
end

%% Constrain the bodies to one translation in x, and no rotations

item={};
item.type='rigid_point';
item.forces=2;
item.moments=3;
item.axis=[1;0;0];
item.body1='';
item.body2='ground';

for i=1:5
	item.name=['lower slider ' num2str(i)];
	item.body1=['lower block ' num2str(i)];
	item.location=[i;0;0];
	the_system.item{end+1}=item;

	item.name=['upper slider ' num2str(i)];
	item.body1=['upper block ' num2str(i)];
	item.location=[i;1;0];
	the_system.item{end+1}=item;
end


%% Add flex_points to connect bodies, aligned with x-axis

item={};
item.type='flex_point';
item.stiffness=[1;0];
item.forces=1;
item.moments=0;
item.axis=[1;0;0];
	
for i=1:4
	item.name=['lower spring ' num2str(i)];
	item.body1=['lower block ' num2str(i)];
	item.body2=['lower block ' num2str(i+1)];
	item.location=[i+0.5;0;0];
	the_system.item{end+1}=item;

	item.name=['upper spring ' num2str(i)];
	item.body1=['upper block ' num2str(i)];
	item.body2=['upper block ' num2str(i+1)];
	item.location=[i+0.5;1;0];
	the_system.item{end+1}=item;

end

item.name='lower spring 0';
item.body1='lower block 1';
item.body2='ground';
item.location=[0.5;0;0];
the_system.item{end+1}=item;


item.name='lower spring 5';
item.body1='lower block 5';
item.body2='ground';
item.location=[5.5;0;0];
the_system.item{end+1}=item;

item.name='upper spring 0';
item.body1='upper block 1';
item.body2='ground';
item.location=[0.5;1;0];
the_system.item{end+1}=item;

item.name='upper spring 5';
item.body1='upper block 5';
item.body2='ground';
item.location=[5.5;1;0];
the_system.item{end+1}=item;

item={};

item.type='actuator';
item.name='actuator 1';
item.body1='lower block 2';
item.body2='upper block 4';
item.location1=[2;0.5;0];
item.location2=[4;0.5;0];
the_system.item{end+1}=item;

item={};
item.type='sensor';
item.name='sensor 1';
item.body1='lower block 4';
item.body2='upper block 2';
item.location1=[4;0.5;0];
item.location2=[2;0.5;0];
the_system.item{end+1}=item;

