function strs=load_defln(strs,result)
%% Copyright (C) 2015, Bruce Minaker
%% This file is intended for use with Octave.
%% load_defln.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% load_defln.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

strs.preload=['%%%%%% Preload\n' 'num name type fx fy fz fxyz \n'];
strs.defln=['%%%%%% Deflection\n' 'num name type x y z \n'];

rnd=1e-5;

j=0;

for i=1:result{1}.data.nrigid_points
	j=j+1;
	item=result{1}.data.rigid_points(i);
	pload=rnd*round([item.b1;item.b2]'*item.preload/rnd);
	frc=pload(1:3);
	mmt=pload(4:6);
	strs.preload=[strs.preload '{' num2str(j) '} {' item.name '}'];
	strs.preload=[strs.preload ' force'];
	strs.preload=[strs.preload sprintf(' %4.8e',frc,norm(frc)) '\n'];
	strs.preload=[strs.preload '{} {} moment'];
	strs.preload=[strs.preload sprintf(' %4.8e',mmt,norm(mmt)) '\n'];
end

for i=1:result{1}.data.nflex_points
	j=j+1;
	item=result{1}.data.flex_points(i);
	pload=rnd*round([item.b1;item.b2]'*item.preload/rnd);
	frc=pload(1:3);
	mmt=pload(4:6);
	strs.preload=[strs.preload '{' num2str(j) '} {' item.name '}'];
	strs.preload=[strs.preload ' force'];
	strs.preload=[strs.preload sprintf(' %4.8e',frc,norm(frc)) '\n'];
	strs.preload=[strs.preload '{} {} moment'];
	strs.preload=[strs.preload sprintf(' %4.8e',mmt,norm(mmt)) '\n'];
end

for i=1:result{1}.data.nsprings
	j=j+1;
	item=result{1}.data.springs(i);
	pload=rnd*round([item.b1;item.b2]'*item.preload/rnd);
	mag=rnd*round(item.preload/rnd);
	frc=pload(1:3);
	mmt=pload(4:6);
	strs.preload=[strs.preload '{' num2str(j) '} {' item.name '}'];
	if(item.twist==0)
		strs.preload=[strs.preload ' force'];
		strs.preload=[strs.preload sprintf(' %4.8e',frc,mag) '\n'];
	else
		strs.preload=[strs.preload ' moment'];
		strs.preload=[strs.preload sprintf(' %4.8e',mmt,mag) '\n'];
	end
end


for i=1:result{1}.data.nlinks
	j=j+1;
	item=result{1}.data.links(i);
	pload=rnd*round([item.b1;item.b2]'*item.preload/rnd);
	mag=rnd*round(item.preload/rnd);
	frc=pload(1:3);
	mmt=pload(4:6);
	strs.preload=[strs.preload '{' num2str(j) '} {' item.name '}'];
	if(item.twist==0)
		strs.preload=[strs.preload ' force'];
		strs.preload=[strs.preload sprintf(' %4.8e',frc,mag) '\n'];
	else
		strs.preload=[strs.preload ' moment'];
		strs.preload=[strs.preload sprintf(' %4.8e',mmt,mag) '\n'];
	end
end


for i=1:result{1}.data.nbeams
	j=j+1;
	item=result{1}.data.beams(i);
	l=item.length;
	pload=rnd*round(item.preload/rnd);
	D=[0 0 0 -1 0 0 0 1; 2/l 0 0 1 -2/l 0 0 1; 0 0 -1 0 0 0 1 0; 0 2/l -1 0 0 -2/l -1 0];  %% Relate the beam stiffness matrix to the deflection of the ends (diagonalize the typical beam stiffness matrix!)
	temp=diag((D'*pload))*[item.b1;item.b2;item.b1;item.b2];
	v1=temp(1,1:3)+temp(2,1:3);
	m1=temp(3,4:6)+temp(4,4:6);
	v2=temp(5,1:3)+temp(6,1:3);
	m2=temp(7,4:6)+temp(8,4:6);
	
	strs.preload=[strs.preload '{' num2str(j) '} {' item.name '}' ' shear' sprintf(' %4.8e',v1,norm(v1)) '\n'];
	strs.preload=[strs.preload '{} {} moment'  sprintf(' %4.8e',m1,norm(m1)) '\n'];
    strs.preload=[strs.preload '{} {} shear'  sprintf(' %4.8e',v2,norm(v2)) '\n'];
	strs.preload=[strs.preload '{} {} moment'  sprintf(' %4.8e',m2,norm(m2)) '\n'];

end

%%% Still to do - beam preloads %%%%%%%%%%%%%%%%%%%%%%%%%5

rnd=1e-8;

for i=1:result{1}.data.nbodys-1
	item=result{1}.data.bodys(i);
	strs.defln=[strs.defln '{' num2str(i) '} {' item.name '}' ' translation' sprintf(' %4.8e',rnd*round(result{1}.eom.preloads.defln(6*i+(-5:-3))/rnd)) '\n']; 
	strs.defln=[strs.defln '{ } { }' ' rotation' sprintf(' %4.8e',rnd*round(result{1}.eom.preloads.defln(6*i+(-2:0))/rnd)) '\n']; 
	
end



%	if(~(norm(frc)==0 && norm(mmt)>0))
%		strs.preload=[strs.preload ' force'];
%		strs.preload=[strs.preload sprintf(' %4.8e',frc,norm(frc)) '\n'];
%	end
%	if(norm(mmt)>0)
%		strs.preload=[strs.preload '{} {} moment'];
%		strs.preload=[strs.preload sprintf(' %4.8e',mmt,norm(mmt)) '\n'];
%	end


