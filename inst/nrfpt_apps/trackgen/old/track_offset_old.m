function [offset,dpsi]=track_offset(pos,theta,distance)


global params;

% load track data
track=params.course(:,1:2);
tracklen=size(track,1);

%if(isempty(idx))
%     idx=2;
%end

while(distance>params.course(end,3))
	distance=distance-params.course(end,3);
end
idx=round(distance/5)+1;

rot_mtx=[cos(theta) sin(theta); -sin(theta) cos(theta)];

d_last=norm(track(idx,:)-pos');  %% Find distance to last point

%% Find closest point by looking ahead
d_next=d_last;  %% Choose to make loop eval at least once
nidx=idx;  %% Start looking at current idx
while(d_next<=d_last) %%&& nidx<tracklen-2)  %% If the next point is closer than the last, keep looking forward
	d_last=d_next;  
	nidx=nidx+1;
	if(nidx>tracklen)
		nidx=1;
	end
	d_next=norm(track(nidx,:)-pos');
end

del=nidx-1-idx;  %% Number of points we move forward
idx=nidx-1;  %% If the last nidx broke the loop, it was one step too far forward, but reset idx

if(idx>1 && del==0)  %% Now check behind also, if we didn't move forward
	d_next=d_last;  %% Choose to make loop eval once
	nidx=idx;
	while(d_next<=d_last) %% && nidx>1)
		d_last=d_next;
		nidx=nidx-1;
		if(nidx<1)
			nidx=tracklen;
		end
		d_next=norm(track(nidx,:)-pos');  %% If the next point is closer than the last, keep looking forward
	end
	idx=nidx+1;  %% If the last nidx broke the loop, it was one step too far back, but reset idx
	if(idx>tracklen)
		idx=1;
	end
end

pta=idx+1;  %% Make sure point ahead is not after end
if(pta>tracklen)
	pta=1;
end
ptb=idx-1;  %% Make sure point behind is not before start
if(ptb<1)
	ptb=tracklen;
end

pta
idx
ptb

temp=[track(pta,1:2);track(idx,1:2);track(ptb,1:2)];  %% Gather three points, one ahead, closest, and one behind
temp=(rot_mtx*(temp'-[pos pos pos]))';  %% Covert to vehicle coordinate system

p=polyfit(temp(:,1),temp(:,2),2);  %% Fit a parabola through them

offset=polyval(p,0);  %% Calculate offset

pp=polyder(p);  %% Derivative to get slope fn

dpsi=atan(polyval(pp,0));  %% Calculate slope  (assumes small angles)

end  %% Leave




%  if idx==1
%      trgt0=rot_mtx*(track(end+1-idx,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(track(end-idx,:)'-pos);  %% Orient closest point in moving frame
%  elseif idx==2
%      trgt0=rot_mtx*(track(end+1-idx,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(track(end-idx,:)'-pos);  %% Orient closest point in moving frame
%  else
%      trgt0=rot_mtx*(track(idx-1,:)'-pos);  %% Orient closest point in moving frame
%      trgt0b=rot_mtx*(track(idx-2,:)'-pos);  %% Orient closest point in moving frame
%  end
%  trgt=rot_mtx*(track(idx,:)'-pos);  %% Orient closest point in moving frame
%  trgt2=rot_mtx*(track(idx+1,:)'-pos);  %% Orient next closest point in moving frame
%  trgt3=rot_mtx*(track(idx+2,:)'-pos);  %% One more point to allow cubic interpolation
%  
%  trgt4_x=interp1(params.course(:,3),params.course(:,1),params.course(idx,3)+d_lat,'pchip','extrap');
%  trgt4_y=interp1(params.course(:,3),params.course(:,2),params.course(idx,3)+d_lat,'pchip','extrap');
%  trgt4=rot_mtx*([trgt4_x trgt4_y]'-pos);  %% Orient point at lateral preview distance in moving frame
%  offset=interp1([trgt0b(1); trgt0(1); trgt(1); trgt2(1); trgt3(1)],[trgt0b(2); trgt0(2); trgt(2); trgt2(2); trgt3(2)],0,'pchip','extrap'); % offset error
%  trgt1=rot_mtx*([0 offset]'); % closest point on track, interpolated

%temp=trgt4-trgt1;
%psi1=atan2(temp(2),temp(1))+theta; % desired yaw angle using preview distance

