function track = track_mesher(path,width)

delta_vec=diff(path)';  %% Find vectors from one point to next

u=zeros(2,length(path)-1);
for i=1:length(path)-1
	u(:,i)=delta_vec(:,i)/norm(delta_vec(:,i));  %% Find the unit vector 
end

u=[u(:,1) u u(:,end)];  %% Add entrance and run off

for i=1:length(path)
	temp=(u(:,i)+u(:,i+1))/2;  %% Find the average of this and the next unit vector
	temp=temp/(norm(temp));  %% Renormalize
	normal=[-temp(2);temp(1)];  %% Rotate 90 degrees

	track(:,2*i+[-1:0])=[path(i,:)'-width*normal/2 path(i,:)'+width*normal/2];  %% Add offsets to track centreline
end
