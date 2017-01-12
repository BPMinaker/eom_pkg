function obj=copy_parms(obj,in)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

deprecated={'location1','location2','location3','body','body1','body2','body3','actuator'};  %% List of deprecated fields
replacement={'location','location','location','body','body','body','body','actuator'};  %% New fieldnames to replace them with
ind=[1 2 3 1 1 2 3 1];  %% The index where they now should be stored
props=fieldnames(in);  %% Get the properties
numprops=length(props);  %% Count the number of properties

for i=1:numprops  %% For each attribute
	odf=strcmp(deprecated,props{i});  %% Check against list of deprecated attributes
	deprec=sum(odf);  %% Find if attribute matched any 
	idx=find(odf);  %% Find which one
	if(deprec)  %% If the attribute is deprecated
		 switch class(in.(props{i}))  %% Check what type of data was stored in the field
			case 'double'  %% For doubles, use a matrix
				%disp('double')
				%replacement{idx}
				obj.(replacement{idx})(:,ind(idx))=in.(props{i});  %% Copy into replacement attribute, make vectors into matrix
			case 'char'  %% For characters, use a cell
				%disp('char')
				%replacement{idx}
				obj.(replacement{idx}){ind(idx)}=in.(props{i});  %% Copy into replacement attribute, make strings into cells  
			otherwise
				error('%s\n','Found deprecated field of invalid type.');  %% Don't know what to do
		end
	elseif(sum(strcmp(props{i},fieldnames(obj))) && ~deprec)  %% isprop not defined in Octave yet as of v4.0
		obj.(props{i})=in.(props{i});  %% Copy the property as defined
	elseif(~strcmp(props{i},'type'))
		disp(['Warning: "' in.name '" has an unexpected attribute "' props{i} '"!']);
		disp('Ignoring attribute and attempting to continue...');
	end
end

end  %% Leave
