classdef connect < item
	properties
		location;  %% Location of nodes (1, 2, or 3)
		body={'ground'};  %% Names of bodies to connect (1, 2, or 3)
		body_number=0;
		forces=0;  %% Number of forces transmitted
		moments=0;  %% Number of moments transmitted
		axis=[0;0;0];  %% Direction vector
		twist=0;  %% Flag for tension or torsion
		radius;
	end
	methods
		function obj=connect(varargin)
			%disp('connect constructor');
			obj@item(varargin{1},varargin{2:end});
		end

		function out=len(obj)
			n=length(obj);
			out=zeros(n,1);
			for i=1:n
				switch(size(obj(i).location,2))
					case 1
						out(i)=0;
					case 2
						out(i)=norm(obj(i).location(:,2)-obj(i).location(:,1)); 
					otherwise
						error('%s\n','Length undefined.')
				end
			end
		 end

		function obj=find_radius(obj,cg_locations)
			%disp('radius')
			for i=1:length(obj)
				%obj(i).name
				if(size(obj(i).location,2)==size(obj(i).body_number,1))  %% If number of locations equals number of body_numbers
					obj(i).radius=obj(i).location-cg_locations(:,obj(i).body_number);
				else
					obj(i).radius(:,1)=obj(i).location-cg_locations(:,obj(i).body_number(1));
					obj(i).radius(:,2)=obj(i).location-cg_locations(:,obj(i).body_number(2));
				end
			end
		end 

		function obj=find_bodynum(obj,names)
			%disp('body_num')
			for i=1:length(obj)
				%obj(i).name
				[match,idx]=ismember(obj(i).body,names);
				if(sum(match)<length(match))
					error('Found item "%s" that is not attached to a body.\n',in(i).name);
				end
				obj(i).body_number=idx';
			
				if(isa(obj(i),'app_load'))  %% If in(i) is an app_load
					[match,idx]=ismember(obj(i).frame,names);
					if(sum(match)<length(match))
						error('Found item "%s" with unknown reference frame.\n',obj(i).name);
					end
					obj(i).frame_number=idx';
				end
			end
		end

		function out=unit(obj)
			switch(size(obj.location,2))
				case 1
					if(norm(obj.axis)>0)
						out=obj.axis/norm(obj.axis);
					else
						error('%s\n','Axis must have finite length.')
					end
				case 2
					out=(obj.location(:,2)-obj.location(:,1))/obj.length;
				case 3
					ux=det([1 1 1;obj.location(2:3,:)]);
					uy=det([obj.location(1,:);1 1 1;obj.location(3,:)]);
					uz=det([obj.location(1:2,:);1 1 1]);
					out=[ux;uy;uz]/norm([ux;uy;uz]);
				otherwise
					error('%s\n','Unit undefined.')
			end
		end
		function out=nu(obj)
			out=null(obj.unit');  %% Find directions perp to axis
			if(~(round(obj.unit'*cross(out(:,1),out(:,2)))==1))  %% Make sure it's right handed
				out=circshift(out,[0,1]);
			end
		end
		function out=r(obj)
			out=[obj.nu obj.unit];  %% Build the rotation matrix
		end
		function out=local(obj)
			out=obj.r'*obj.location;  %%  Coordinates of location in local frame
		end
		
		 %b1=[];  %%  To build Jacobian
		 %b2=[];
	 end
end




%             switch(size(obj.location,2))
% 
%                 case 1  %% If the item has one node
%     %               obj.rolling_unit=[0;0;0];
%                     if(norm(obj.axis)>0)
%                         obj.unit=obj.axis/norm(obj.axis);  %% Normalize any non-unit axis vectors
%                     end
%     %                 if(isfield(obj,'rolling_axis'))
%     %                     if(norm(obj.rolling_axis)>0)
%     %                         obj.rolling_unit=obj.rolling_axis/norm(obj.rolling_axis);
%     %                     end
%     %                 end
% 
%                 case 2  %% If the item has two nodes
%                     tempvec=obj.location(:,2)-obj.location(:,1); %% Vector from location1 to location2
%                     obj.length=norm(tempvec); %% New entry 'length' is the magnitude of the vector from location1 to location2
%                     if(obj.length>0)
%                         obj.unit=tempvec/obj.length; %% New entry 'unit' is the unit vector from location1 to location2
%                      end
%                      obj.forces=~obj.twist;
%                      obj.moments=obj.twist;
% 
% 
%                 case 3 %% If the item has three nodes
%                     %% find the normal to the triangle, but use Newell method rather than null()
%                     ux=det([1 1 1;obj.location(2:3,:)]);
%                     uy=det([obj.location(1,:);1 1 1;obj.location(3,:)]);
%                     uz=det([obj.location(1:2,:);1 1 1]);
%                     obj.unit=[ux;uy;uz]/norm([ux;uy;uz]);
%                 
%             end
%             obj.nu=null(obj.unit');  %% Find directions perp to axis
%             if(~(round(obj.unit'*cross(obj.nu(:,1),obj.nu(:,2)))==1))  %% Make sure it's right handed
%                 obj.nu=circshift(obj.nu,[0,1]);
%             end
% 
%             obj.r=[obj.nu obj.unit];  %% Build the rotation matrix
%             %% Find the locations in the new coordinate system, z is the same for all points in planar element
%             obj.local=obj.r'*obj.location;
%         end
%     end



%             
      

   
