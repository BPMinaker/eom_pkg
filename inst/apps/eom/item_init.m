function in=item_init(in,type)
%% Copyright (C) 2010, Bruce Minaker
%% This file is intended for use with Octave.
%% item_init.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% item_init.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

for i=1:length(in)
	if(isfield(in(i),'location'))

		switch(size(in(i).location,2))

			case 1  %% If the item has one node
				in(i).unit=[0;0;0];
				in(i).rolling_unit=[0;0;0];
				if(isfield(in(i),'axis'))
					if(norm(in(i).axis)>0)
						in(i).unit=in(i).axis/norm(in(i).axis);  %% Normalize any non-unit axis vectors
					end
				end
				if(isfield(in(i),'rolling_axis'))
					if(norm(in(i).rolling_axis)>0)
						in(i).rolling_unit=in(i).rolling_axis/norm(in(i).rolling_axis);
					end
				end

			case 2  %% If the item has two nodes
				tempvec=in(i).location(:,2)-in(i).location(:,1); %% Tempvec = vector from location1 to location2
				in(i).length=norm(tempvec); %% New entry 'length' is the magnitude of the vector from location1 to location2
				if(in(i).length>0)
					in(i).unit=tempvec/in(i).length; %% New entry 'unit' is the unit vector from location1 to location2
				else
					in(i).unit=[0;0;0];
				end
				if(isfield(in(i),'twist'))
					in(i).forces=~in(i).twist;
					in(i).moments=in(i).twist;
				end

			case 3 %% If the item has three nodes
				%% find the normal to the triangle, but use Newell method rather than null()
				ux=det([1 1 1;in(i).location(2:3,:)]);
				uy=det([in(i).location(1,:);1 1 1;in(i).location(3,:)]);
				uz=det([in(i).location(1:2,:);1 1 1]);
				in(i).unit=[ux;uy;uz]/norm([ux;uy;uz]);
		end

		in(i).nu=null(in(i).unit');  %% Find directions perp to beam axis
		if(~(round(in(i).unit'*cross(in(i).nu(:,1),in(i).nu(:,2)))==1))  %% Make sure it's right handed
			in(i).nu=circshift(in(i).nu,[0,1]);
		end

		in(i).r=[in(i).nu in(i).unit];  %% Build the rotation matrix
		%% Find the locations in the new coordinate system, z is the same for all points in planar element
		in(i).local=in(i).r'*in(i).location;
	end
end

for i=1:length(in) %% For each item
	if(isfield(in(i),'location') && isfield(in(i),'forces') && isfield(in(i),'moments'))

		a=in(i).unit;  %% Axis of constraint
		b=in(i).nu;  %% Plane of constraint

		switch(in(i).forces)
			case 3 %% For 3 forces, i.e. ball joint
				in(i).b1=[eye(3), zeros(3) ]; %% 
			case 2 %% For 2 forces, i.e. cylindrical or pin joint
				in(i).b1=[b', zeros(2,3) ];
			case 1 %% For 1 force, i.e. planar
				in(i).b1=[a' 0 0 0];
			case 0 %% For 0 forces
				in(i).b1=zeros(0,6);
			otherwise
				error('Error.  Item is defined incorrectly.');
		end

		switch(in(i).moments)
			case 3 %% For 3 moments, i.e. no rotational degrees of freedom
				in(i).b2=[zeros(3), eye(3)];
			case 2 %% For 2 moments, i.e. 1 rotational degree of freedom, i.e. Cylindrical joint
				in(i).b2=[zeros(2,3), b' ];
			case 1 %% For 1 moment, i.e. 2 rotational degrees of freedom, i.e. U-joint
				in(i).b2=[0 0 0 a'];
			case 0 %% For 0 moments, i.e. sherical joint
				in(i).b2=zeros(0,6);
			otherwise
				error('Error.  Item is defined incorrectly.');
		end
	end
end

if(ismember(type,{'triangle_3s','triangle_5s'}))
	for i=1:length(in)
		in(i).mod_mtx=in(i).modulus/(1-in(i).psn_ratio^2)*[1 in(i).psn_ratio 0; in(i).psn_ratio 1 0; 0 0 0.5-in(i).psn_ratio/2];
	end
end

type

if(ismember(type,{'wings','surfs'}))
	for i=1:length(in)
		if(in(i).area==0)
			in(i).area=in(i).span*in(i).chord;
		end
		in(i).qs=in(i).area*0.5*in(i).density*(in(i).airspeed)^2;
	end
end

end %% Leave

%% old code

%for i=1:length(in)
%	if(isfield(in(i),'travel') && isfield(in(i),'length')&& ~isscalar(in(i).travel))
%		in(i).travel=in(i).length/2;
%	end
%end

%%	if(isfield(in(i),'area') && isfield(in(i),'chord') && isfield(in(i),'span'))
%%	if(isfield(in(i),'modulus') && isfield(in(i),'psn_ratio'))
%%	if(isfield(in(i),'area') && isfield(in(i),'airspeed'))
