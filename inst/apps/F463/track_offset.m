function [offset,dpsi,u_ref,curv]=track_offset(pos,theta,distance,vx)

global params;

% load track data
%tracklen=size(params.course,1);  %% Find number of rows
idx=round(distance/5)+1;  %% Use distance to find approximate location (5 is ds)
rot_mtx=[cos(theta) sin(theta); -sin(theta) cos(theta)];  %% Build rotation matrix
d_last=norm(params.course(idx,1:2)-pos');  %% Find distance to last point

%% Find closest point by looking ahead
d_next=d_last;  %% Choose to make loop eval at least once
nidx=idx;  %% Start looking at current idx
while(d_next<=d_last) %%&& nidx<tracklen-2)  %% If the next point is closer than the last, keep looking forward
	d_last=d_next;  
	nidx=nidx+1;
	d_next=norm(params.course(nidx,1:2)-pos');  %% Compute distance from track point to current point
end

del=nidx-1-idx;  %% Number of points we move forward
idx=nidx-1;  %% If the last nidx broke the loop, it was one step too far forward, but reset idx

if(idx>1 && del==0)  %% Now check behind also, if we didn't move forward
	d_next=d_last;  %% Choose to make loop eval once
	nidx=idx;
	while(d_next<=d_last) %% && nidx>1)
		d_last=d_next;
		nidx=nidx-1;
		d_next=norm(params.course(nidx,1:2)-pos');  %% If the next point is closer than the last, keep looking forward
	end
	idx=nidx+1;  %% If the last nidx broke the loop, it was one step too far back, but reset idx
end

ptb=idx-1;  %% Make sure point behind is not before start?
indc=[ptb idx];

d_ahead=5+0.5*vx;  %% Look ahead distance

ni=ceil(d_ahead/5);  %% Number of points (how to know 5?, fix me...)

pta=idx+1;

for i=1:ni  %% Add points to index
	indc=[indc pta];
	pta=pta+1;
end
if(indc(1)==0)
	indc=indc+1;
end

pts=[0;0.1;0.2;0.3;0.4;0.6;0.8;1]*d_ahead;

temp=params.course(indc,1:2);
temp=(rot_mtx*(temp'-repmat(pos,1,ni+2)))';  %% Convert to vehicle coordinate system

p=polyfit(temp(:,1),temp(:,2),2);  %% Fit a curve through them
offset=polyval(p,pts);  %% Calculate offset

temp(:,2)=params.course(indc,5);  %% Find desired angle
p=polyfit(temp(:,1),temp(:,2),2);  %% Fit a parabola through them
dpsi=polyval(p,pts)-theta;
%theta

%[10 10 6 2 0.8 0.16 0.04 0.01]/15.5135*dpsi

temp(:,2)=params.course(indc,6);  %% Find desired speeds
p=polyfit(temp(:,1),temp(:,2),2);  %% Fit a parabola through them
u_ref=polyval(p,0);


temp(:,2)=params.course(indc,4);  %% Find desired curvature
p=polyfit(temp(:,1),temp(:,2),2);  %% Fit a parabola through them
curv=polyval(p,0);

end  %% Leave



%  if idx==1
%      trgt0=rot_mtx*(params.course(end+1-idx,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(params.course(end-idx,:)'-pos);  %% Orient closest point in moving frame
%  elseif idx==2
%      trgt0=rot_mtx*(params.course(end+1-idx,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(params.course(end-idx,:)'-pos);  %% Orient closest point in moving frame
%  else
%      trgt0=rot_mtx*(params.course(idx-1,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(params.course(idx-2,:)'-pos);  %% Orient closest point in moving frame
%  end
%  trgt=rot_mtx*(params.course(idx,:)'-pos);  %% Orient closest point in moving frame
%  trgt2=rot_mtx*(params.course(idx+1,:)'-pos);  %% Orient next closest point in moving frame
%  trgt3=rot_mtx*(params.course(idx+2,:)'-pos);  %% One more point to allow cubic interpolation
%  
%  trgt4_x=interp1(params.course(:,3),params.course(:,1),params.course(idx,3)+d_lat,'pchip','extrap');
%  trgt4_y=interp1(params.course(:,3),params.course(:,2),params.course(idx,3)+d_lat,'pchip','extrap');
%  trgt4=rot_mtx*([trgt4_x trgt4_y]'-pos);  %% Orient point at lateral preview distance in moving frame
%  offset=interp1([trgt0b(1); trgt0(1); trgt(1); trgt2(1); trgt3(1)],[trgt0b(2); trgt0(2); trgt(2); trgt2(2); trgt3(2)],0,'pchip','extrap'); % offset error
%  trgt1=rot_mtx*([0 offset]'); % closest point on track, interpolated

%temp=trgt4-trgt1;
%psi1=atan2(temp(2),temp(1))+theta; % desired yaw angle using preview distance

