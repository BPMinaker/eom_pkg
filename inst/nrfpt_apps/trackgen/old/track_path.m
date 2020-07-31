function xy=track_path(track,varargin)

npts=size(track,2);  %% Find length of track vector
if mod(npts,2)==1  %% Must be even
	disp('Track definition error');
	return
end
nelem=npts/2-1;  %% Find number of track elements

path=[zeros(2,npts)];  %% Define the path on the track
if(nargin()>1)
	if((size(varargin{1},1)==2)&&(size(varargin{1},2)==npts))
		path=varargin{1};
	end
end

normal=zeros(2,npts/2);  %% Find normal unit vector to each cross line

for i=1:npts/2
	temp=track(:,2*i-1)-track(:,2*i);  %% Find the track cross line
	normal(:,i)=temp/norm(temp);  %% Normalize
    normal(:,i)=[-normal(2,i);normal(1,i)];  %% Rotate 90 degrees
end

s=-1:0.2:0.8;
xy=zeros(2,nelem*length(s));

for i=1:nelem
	elem=track(:,2*i+[-1:2]);  %% Take four track points
	theta=path(2,i);  %% Look up angle at this point
	r=[cos(theta) -sin(theta); sin(theta) cos(theta)];  %% Rotate the normal vector
	[txy tdxy]=map([-1;path(1,i)],elem);  %% Find the mapping of the slope at the start of the element
	temp=tdxy\r*normal(:,i);  %% Find the unit vector in st coordinates
	a=path(:,i);  %% Look up the track cross point
	a(2)=temp(2)/temp(1);  %% Find the slope

	theta=path(2,i+1);  %% Repeat for end of element
	r=[cos(theta) -sin(theta); sin(theta) cos(theta)];
	[txy tdxy]=map([1;path(1,i+1)],elem);
	temp=tdxy\r*normal(:,i+1);
	b=path(:,i+1);
	b(2)=temp(2)/temp(1);

	pp=hermite([a;b]);  %% Find the interpolating polynomial
	t=polyval(pp,s);  %% Evaluate it at points in the element

	for j=1:length(s)
		[xy(:,length(s)*(i-1)+j) temp]=map([s(j);t(j)],elem);  %% Map the 10 points back to xy space
	end
end

