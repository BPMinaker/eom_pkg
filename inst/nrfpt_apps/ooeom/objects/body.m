classdef body < item
	properties
		p_location=[0;0;0];
		p_orientation=[0;0;0];
		p_mass=0;
		p_momentsofinertia=[0;0;0];
		p_productsofinertia=[0;0;0];
		p_velocity=[0;0;0];
		p_angular_velocity=[0;0;0]; 
		p_x3d='';
		p_vrml='';
	end
	methods
		function obj=body(varargin)
			obj@item(varargin{1},varargin{2:end});
		end
		function mtx=inertia(obj)
			for i=1:length(obj);
				mtx=diag(obj(i).p_momentsofinertia);  %% Put inertia on diagonal
				mtx(1,2)=-obj(i).p_productsofinertia(1);  %% Put -ve cross products in
				mtx(2,1)=-obj(i).p_productsofinertia(1);
				mtx(2,3)=-obj(i).p_productsofinertia(2);
				mtx(3,2)=-obj(i).p_productsofinertia(2);
				mtx(1,3)=-obj(i).p_productsofinertia(3);
				mtx(3,1)=-obj(i).p_productsofinertia(3);
			end
		end
		function mtx=mass_mtx(obj)
			mtx=[];
			for i=1:length(obj)
				mtx=blkdiag(mtx,obj(i).p_mass*eye(3),obj(i).inertia);  %% Stack mass and inertia terms
			end
		end
		function vec=location(obj)
			vec=obj.p_location;
		end
		function vec=orientation(obj)
			vec=p_orientation;
		end
		function scal=mass(obj)
			scal=obj.p_mass;
		end
		function vec=velocity(obj)
			vec=obj.p_velocity;
		end
		function vec=angular_velocity(obj)
			vec=obj.p_angular_velocity;
		end
		function str=x3d(obj)
			str=obj.p_x3d;
		end
		function str=vrml(obj)
			str=obj.p_vrml;
		end
	end
end


%             if(isfield(in,'location'))  %% If the input has a location field
%                 validateattributes(in.mass,{'numeric'},{'nonempty'},'body');  %% Make sure it's a 3 row vector
%                 obj.mass=in.mass;  %% Then copy it
%             end

