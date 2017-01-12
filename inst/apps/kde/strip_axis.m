function p_out=strip_axis(syst,p_in)

% GPL
% Build the positions vector using important components
%-------------------------------------------------------------------------------------------------------------------------

len_r=6*(syst.data.nbodys-1);
len_p=3*(syst.data.nrigid_points+syst.data.nflex_points+syst.data.nloads);
len_pi=6*(syst.data.nrigid_points+syst.data.nflex_points)+3*syst.data.nloads;
len_l=6*(syst.data.nlinks+syst.data.nsprings+syst.data.nbeams);

%  p_in
%  pause()

p_out=zeros(size(p_in,1),len_r+len_p+len_l);

% body items
p_out(:,1:len_r)=p_in(:,1:len_r);

% point items
for i=1:syst.data.nrigid_points
	p_out(:,len_r+3*i+[-2:0])=p_in(:,len_r+6*i+[-5:-3]);
end
for i=1:syst.data.nflex_points
	p_out(:,len_r+3*syst.data.nrigid_points+3*i+[-2:0])=p_in(:,len_r+6*syst.data.nrigid_points+6*i+[-5:-3]);
end

p_out(:,len_r+3*(syst.data.nrigid_points+syst.data.nflex_points)+1:len_r+len_p)=p_in(:,len_r+6*(syst.data.nrigid_points+syst.data.nflex_points)+1:len_r+len_pi);

% line items
p_out(:,len_r+len_p+1:end)=p_in(:,len_r+len_pi+1:end);

%  p_out
%  pause()

end %% Leave

