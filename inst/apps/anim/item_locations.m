function pout=item_locations(result,pout)
%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% item_locations.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% item_locations.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% This function computes the locations of the connector item endpoints from body position time history

	temp=[pout;zeros(6,size(pout,2))];  %% Add zeros for ground for now
	enda=zeros(3,size(pout,2));
for j=1:result{1}.data.nrigid_points
	bnum1=result{1}.data.rigid_points(j).body_number(1);  %% Find body numbers
	bnum2=result{1}.data.rigid_points(j).body_number(2);
	for k=1:size(pout,2)
		end1=temp(6*bnum1+(-5:-3),k)+(eye(3)+skew(temp(6*bnum1+(-2:0),k)))*result{1}.data.rigid_points(j).radius(:,1);  %% Find end locations
		end2=temp(6*bnum2+(-5:-3),k)+(eye(3)+skew(temp(6*bnum2+(-2:0),k)))*result{1}.data.rigid_points(j).radius(:,2);
		enda(:,k)=(end1+end2)/2;
	end
	pout=[pout;enda];  %% Add rigid_point locations to output
end

for j=1:result{1}.data.nflex_points
	bnum1=result{1}.data.flex_points(j).body_number(1);  %% Find body numbers
	bnum2=result{1}.data.flex_points(j).body_number(2);
	for k=1:size(pout,2)
		end1=temp(6*bnum1+(-5:-3),k)+(eye(3)+skew(temp(6*bnum1+(-2:0),k)))*result{1}.data.flex_points(j).radius(:,1);  %% Find end locations
		end2=temp(6*bnum2+(-5:-3),k)+(eye(3)+skew(temp(6*bnum2+(-2:0),k)))*result{1}.data.flex_points(j).radius(:,2);
		enda(:,k)=(end1+end2)/2;
	end
	pout=[pout;enda];  %% Add flex_point locations to output
end

for j=1:result{1}.data.nloads
	bnum=result{1}.data.loads(j).body_number;  %% Find body numbers
	for k=1:size(pout,2)
		end1(:,k)=temp(6*bnum+(-5:-3),k)+(eye(3)+skew(temp(6*bnum+(-2:0),k)))*result{1}.data.loads(j).radius;  %% Find end locations
	end
	pout=[pout;end1];  %% Add load end locations to output
end

for j=1:result{1}.data.nlinks
	bnum1=result{1}.data.links(j).body_number(1);  %% Find body numbers
	bnum2=result{1}.data.links(j).body_number(2);
	for k=1:size(pout,2)
		end1(:,k)=temp(6*bnum1+(-5:-3),k)+(eye(3)+skew(temp(6*bnum1+(-2:0),k)))*result{1}.data.links(j).radius(:,1);  %% Find spring end locations
		end2(:,k)=temp(6*bnum2+(-5:-3),k)+(eye(3)+skew(temp(6*bnum2+(-2:0),k)))*result{1}.data.links(j).radius(:,2);
	end
	pout=[pout;end1;end2];  %% Add link end locations to output
end

for j=1:result{1}.data.nsprings
	bnum1=result{1}.data.springs(j).body_number(1);  %% Find body numbers
	bnum2=result{1}.data.springs(j).body_number(2);
	for k=1:size(pout,2)
		end1(:,k)=temp(6*bnum1+(-5:-3),k)+(eye(3)+skew(temp(6*bnum1+(-2:0),k)))*result{1}.data.springs(j).radius(:,1);  %% Find spring end locations
		end2(:,k)=temp(6*bnum2+(-5:-3),k)+(eye(3)+skew(temp(6*bnum2+(-2:0),k)))*result{1}.data.springs(j).radius(:,2);
	end
	pout=[pout;end1;end2];  %% Add spring end locations to output
end

end  %% Leave
