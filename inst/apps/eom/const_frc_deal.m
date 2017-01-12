function out=const_frc_deal(syst,verb)
%% Copyright (C) 2009 Bruce Minaker, Rob Rieveley
%% This file is intended for use with Octave.
%% const_frc_deal.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% cnst_frc_deal.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

%% Distribute preload solution results to individual items... order is important: rigids, then flex (Important because the contents of variable lambda are being shifted throughout the process)
if(verb); disp('Distributing constraint forces...'); end

lambda=syst.eom.preloads.lambda;
 
%  length(lambda)
%  syst.data.nrigid_points
%  syst.data.ntriangle_3s

%% Use the comma separated list where possible, but can't on point items, as the number of lambdas may change from point to point
if(syst.data.nlinks>0)
	temp=num2cell(lambda(1:syst.data.nlinks));
	[syst.data.links.preload]=temp{:};
	lambda=circshift(lambda,-syst.data.nlinks);
end

for i=1:syst.data.nrigid_points %% For each point item
	num=syst.data.rigid_points(i).forces+syst.data.rigid_points(i).moments; %% Num = the sum of the *number of* forces and moments in the point item
	syst.data.rigid_points(i).preload=lambda(1:num); %% Adds new entry 'preload' to the point item, sets it equal to the lambda
	lambda=circshift(lambda,-num); %% Performs a circular shift on lambda, equal to the number of forces and moments in the point item
end

if(syst.data.nsprings>0)
	temp=num2cell(lambda(1:syst.data.nsprings));
	[syst.data.springs.preload]=temp{:};
	lambda=circshift(lambda,-syst.data.nsprings);
end
    
for i=1:syst.data.nflex_points %% For each point item
	num=syst.data.flex_points(i).forces+syst.data.flex_points(i).moments; %% Num = the sum of the *number of* forces and moments in the point item
	syst.data.flex_points(i).preload=lambda(1:num); %% Adds new entry 'preload' to the point item, sets it equal to the lambda
	lambda=circshift(lambda,-num); %% Performs a circular shift on lambda, equal to the number of forces and moments in the point item
end

if(syst.data.nbeams>0)
	temp=num2cell(reshape(lambda(1:4*syst.data.nbeams),4,[]),1);
	[syst.data.beams.preload]=temp{:};
	lambda=circshift(lambda,-4*syst.data.nbeams);
end

if(syst.data.ntriangle_3s>0)
	temp=num2cell(reshape(lambda(1:3*syst.data.ntriangle_3s),3,[]),1);
	[syst.data.triangle_3s.preload]=temp{:};
	lambda=circshift(lambda,-3*syst.data.ntriangle_3s);
end

if(syst.data.ntriangle_5s>0)
	temp=num2cell(reshape(lambda(1:5*syst.data.ntriangle_5s),5,[]),1);
	[syst.data.triangle_5s.preload]=temp{:};
	lambda=circshift(lambda,-5*syst.data.ntriangle_5s);
end

if(syst.data.nwings>0)
	temp=num2cell(reshape(lambda(1:3*syst.data.nwings),3,[]),1);
	[syst.data.wings.preload]=temp{:};
%	lambda=circshift(lambda,-3*syst.data.nwings);  % Not needed unless we
%	add another item type
end

out=syst.data; %% Update the data variable with preloads

end %% Leave



%for i=1:syst.data.nbeams
%	syst.data.beams(i).preload=lambda(1:4); %% Adds new entry 'preload' to the item, sets it equal to the lambda
%	lambda=circshift(lambda,-4); %% Performs a circular shift on lambda, equal to the number of forces and moments in the item
%end

%for i=1:syst.data.ntriangle_3s
%	syst.data.triangle_3s(i).preload=lambda(1:6); %% Adds new entry 'preload' to the item, sets it equal to the lambda
%	lambda=circshift(lambda,-6); %% Performs a circular shift on lambda, equal to the number of forces and moments in the item
%end

%for i=1:syst.data.ntriangle_5s
%	syst.data.triangle_5s(i).preload=lambda(1:9); %% Adds new entry 'preload' to the item, sets it equal to the lambda
%	lambda=circshift(lambda,-9); %% Performs a circular shift on lambda, equal to the number of forces and moments in the item
%end

%for i=1:syst.data.nwings
%	syst.data.wings(i).preload=lambda(1:3); %% Adds new entry 'preload' to the item, sets it equal to the lambda
%	lambda=circshift(lambda,-3); %% Performs a circular shift on lambda, equal to the number of forces and moments in the item
%end
