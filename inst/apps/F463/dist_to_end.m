function [value,isterminal,direction]=dist_to_end(t,z)

global params

frame=z(1:13);  %% Pull out frame motions
z=z(17:end);
x=z(1:end/2)'*params.l_orth;

temp=2*atan2(frame(7),frame(4));  %% only when we know rotation is only about z
 %% compute chassis x coordinate
value=frame(1)+cos(temp)*x(6*params.chassnum-5)-sin(temp)*x(6*params.chassnum-4)+eps;

% if the time is too short, or the y distance is too big, ignore
if(t<1 || frame(2)>10)
	value=10;
end
%value

isterminal=1;
direction=1;

end
