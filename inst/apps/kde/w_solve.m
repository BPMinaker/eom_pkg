function p_dot=w_solve(t,p,syst,actuator_number,direction)
% GPL goes here

%global count;
%count = count +1

%fprintf(1,'.'); %% User feedback

syst=system_update(syst,p); % Update current element locations
syst.eom.rigid=rigid_constraint(syst.data,0);

u_act=point_line_jacobian(syst.data.actuators,syst.data.nbodys);  %% Constrain all actuators
n=actuator_number;  %% Find current actuator
temp=1:syst.data.nactuators;  %% Build list of all actuators
n2=temp([1:n-1,n+1:end]);  %% Build a list of all actuators except the current one

init_vel=null([syst.eom.rigid.cnsrt_mtx;u_act(n2,:)]); %% Lock all other actuators, find the possible velocities that satisfy

v=zeros(3,2);
vb=zeros(6,2);
for i=1:2  %% For each end of the actuator
	if(syst.data.actuators(n).body_number(i)<syst.data.nbodys)  %% If the body at that end is not ground
		vb(:,i)=init_vel(6*(syst.data.actuators(n).body_number(i)-1)+[1:6],1);  %% Find the velocities of that body
		if(syst.data.actuators(n).twist==0)
			v(:,i)=vb(1:3,i)+cross(vb(4:6,i),syst.data.actuators(n).radius(:,i));
		else
			v(:,i)=vb(4:6,i);
		end
	else
		v(:,i)=zeros(3,1);  %% Ground has zero velocity
	end
end

%% Scale the body velocities so that the current actuator speed is constant
scale=(dot(v(:,2)-v(:,1),syst.data.actuators(n).unit));
vel=direction*syst.data.actuators(n).travel/scale*init_vel(:,1);

p_dot=d_state(syst,vel);  %% Find the velocities of all the relevant points

end  %% Leave
