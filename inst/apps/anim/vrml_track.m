function vrml_track(track,t,frame,path)

tracklen=size(track,2);
track=[track;zeros(1,tracklen)];  %% Add zeros for z coordinate

for i=1:(tracklen)/2  %% Take four nodes for each piece of track, two new, two old
	nodes(:,i)=[2*i+[-2;0;1;-1];-1];
end
nodes(2,end)=0;  %% Wrap around to start
nodes(3,end)=1;

s=vrml_ifs([0;0;0],[0;0;1;0],track,nodes);  % define track surface


lcn=frame(1:3,:);  %% find location/orientation of track origin in reference frame's moving coordinates
e0=frame(4,:);
e=frame(5:7,:);

%angle=2*atan2(frame(7,:),frame(4,:));  %% Only for z rotation

%  size(angle,2)
%for i=1:size(angle,2)
%  	angle(i)
%  	if(angle(i)<0)
%  		angle(i)=angle(i)+2*pi;
%  	end
%end



for i=1:size(lcn,2)
	rot_mtx=(2*e0(i)^2-1)*eye(3)+2*e(:,i)*e(:,i)'-2*e0(i)*skew(e(:,i));
  	lcnp(:,i)=-rot_mtx*lcn(:,i);
end

angle=-2*real(acos(e0));

for i=1:size(e,2)
	if(norm(e(:,i))>0)
		e(:,i)=e(:,i)/norm(e(:,i));
	else
		e(:,i)=[0;0;1];
	end
end

rtnp=[e;angle];
%  t=0:10;
%  lcnp=zeros(3,11);
%  rtnp=[zeros(2,11);ones(1,11);t];
%  rtnp(4,8:11)=rtnp(4,8:11)-2*pi;

scl=ones(3*size(t));
s_mov=vrml_motion(t/t(end),lcnp,rtnp,scl,'road',s);  % animate track motion

s=[vrml_frame('scale',0.2) sprintf(s)];
save_vrml([path filesep() 'track'],s_mov);  % save


