function the_system=input_ex_eig_set(varargin)
the_system.item={};

%%--------------------------------------------------------------------


%% Add the unsprung mass, along the z-axis
body.type='body';
body.name='unsprung';
body.mass=10;
body.location=[0;0;0.3];
the_system.item{end+1}=body;

%% Add another identical rigid body, along the z-axis
body.name='sprung';
body.mass=10;
body.location=[0;0;0.6];
the_system.item{end+1}=body;


%% Constrain unsprung mass to translation in z-axis, no rotation
point.type='rigid_point';
point.name='slider one';
point.body1='unsprung';
point.body2='ground';
point.location=[0;0;0.3];
point.forces=2;
point.moments=3;
point.axis=[0;0;1];
the_system.item{end+1}=point;

%% Constrain sprung mass to translation in z-axis, no rotation
point.name='slider two';
point.body1='sprung';
point.body2='ground';
point.location=[0;0;0.6];
the_system.item{end+1}=point;

%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='$u_1$';
item.body1='unsprung';
item.body2='ground';
item.gain=1;
item.location1=[0.0;0;0.3];
item.location2=[0.0;0;0];
the_system.item{end+1}=item;
item={};


%% Add external force between unsprung mass and ground (represents ground motion)
item.type='actuator';
item.name='$u_2$';
item.body1='sprung';
item.body2='unsprung';
item.gain=1;
item.location1=[0.0;0;0.6];
item.location2=[0.0;0;0.3];
the_system.item{end+1}=item;
item={};


%% Add measure between ground and sprung mass
item.type='sensor';
item.name='$y_1$';
item.body1='unsprung';
item.body2='ground';
item.location1=[0;0.05;0.3];
item.location2=[0;0.05;0];
the_system.item{end+1}=item;

%% Add measure between unsprung and sprung mass
item.type='sensor';
item.name='$y_2$';
item.body1='sprung';
item.body2='unsprung';
item.location1=[0;0.05;0.6];
item.location2=[0;0.05;0.3];
the_system.item{end+1}=item;


