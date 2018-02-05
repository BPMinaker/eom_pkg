function result=linear_analysis(result)
%% Copyright (C) 2011, Bruce Minaker
%% This file is intended for use with Octave.
%% linear_analysis.m is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2, or (at your option)
%% any later version.
%%
%% linear_analysis.m is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%%
%%--------------------------------------------------------------------

vpts=length(result);  %% Number of points to plot
wpts=round(1500/vpts);
%w=2*pi*logspace(-1,2,wpts);

%par
for i=1:vpts

% 	if(n>2000)  %% If it's really big, then forget it
% 		disp('Huge system. Stopping...');
% 		return;
% 	end

	n=size(result{i}.eom.state_space.a,1);

	if(n>0)  %% If it's possible, do eigenvalues
		[vec_tmp,val_tmp]=eig(result{i}.eom.state_space.a,result{i}.eom.state_space.e);  %% Find the eigen for this speed

		val_tmp=diag(val_tmp);

		result{i}.math.val=val_tmp(isfinite(val_tmp));  %% Discard modes with Inf or Nan vals
		result{i}.math.vect=vec_tmp(:,isfinite(val_tmp));

		m=size(result{i}.math.val,1);
		vec=1e-6*round(result{i}.math.vect(1:m,:)*1e6);

		if(vpts<10)
			%cond(vec_tmp)
			r=rank(vec);
			if(r<m)
				disp('Vectors are not unique!');
				if(r==(m-1))
					disp('Trying to replace redundant vector...');

					for j=1:m
						temp=vec;
						temp(:,j)=[];
						t=rank(temp);
						if(t==r)
							bb=j;
						end
					end
					result{i}.math.vect(:,bb)=pinv(result{i}.eom.state_space.a-result{i}.math.val(bb)*result{i}.eom.state_space.e)*(result{i}.eom.state_space.e*result{i}.math.vect(:,bb));
				end
			end
		end

		w_nat=abs(result{i}.math.val);  %% Find equiv. freq.
		wlim=w_nat(w_nat>0);
		maxw(i)=max(w_nat(isfinite(w_nat)));  %% Find max frequency for span of frequency analysis
		minw(i)=min(wlim);  %% Find min non-zero frequency

		result{i}.eom.modes=result{i}.eom.phys*result{i}.math.vect;  %% Convert vector to physical coordinates

		for j=1:size(result{i}.eom.modes,2)  %% For each mode
			if(norm(result{i}.eom.modes(:,j))>0)  %% Check for non-zero displacement modes
				[~,k]=max(abs(result{i}.eom.modes(:,j)));  %% Find max entry 
				result{i}.eom.modes(:,j)=result{i}.eom.modes(:,j)/result{i}.eom.modes(k,j);  %% Scale motions to unity by diving by max value, but not abs of max, as complex possible
			end
		end

		[result{i}.centres,result{i}.axis]=roll_centre(result{i}.eom.modes,result{i}.data.bodys);

		if(exist('OCTAVE_VERSION','builtin'))
			result{i}.math.ss_min=minreal(ss(result{i}.eom.state_space,'explicit'));
			zrs=@(x) zero(x);
		else
			result{i}.math.ss_min=minreal(result{i}.eom.state_space,[],0);  %% Minimize the realization
			zrs=@(x) tzero(x);
		end

		result{i}.math.zros=zrs(result{i}.math.ss_min);

%		temp=result{i}.math.zros;
%		temp=temp(temp>0);
%		temp=temp(temp<1e7);

%		if(isempty(temp))
%			minz(i)=minw(i);
%			maxz(i)=maxw(i);
%		else
%			minz(i)=min(temp);
%			maxz(i)=max(temp);
%		end
	end
end

minw=floor(log10(min(minw)/2/pi));
if(minw<-2)
	minw=-2;
end
maxw=ceil(log10(max(maxw)/2/pi));

w=2*pi*logspace(minw,maxw,wpts);

%par
for i=1:vpts
%	result{i}.math.w=w;
	n=size(result{i}.eom.state_space.a,1);
	[nout,nin]=size(result{i}.eom.state_space.d);

%	result{i}.math.ss_resp=zeros(nout,nin);

	if(nin*nout*n>0 && nin*nout<16)

		result{i}.math.w=w;
		result{i}.math.freq_resp=freqresp(result{i}.math.ss_min,w)+eps;  %% add small offset to fix -Inf

		if(exist('OCTAVE_VERSION','builtin'))
%			[fr,result{i}.math.w]=frdata(result{i}.math.ss_min);
%			result{i}.math.freq_resp=fr+eps;  %% add small offset to fix -Inf

			for j=1:nout
				for k=1:nin
					result{i}.math.ss_resp(j,k)=dcgain(minreal(dss(result{i}.eom.state_space.a, result{i}.eom.state_space.b(:,k),result{i}.eom.state_space.c(j,:), result{i}.eom.state_space.d(j,k),result{i}.eom.state_space.e),1e-9));
				end
			end
		else
%			[fr,result{i}.math.w]=freqresp(result{i}.math.ss_min);
%			result{i}.math.freq_resp=fr+eps;  %% add small offset to fix -Inf
			result{i}.math.ss_resp=dcgain(result{i}.math.ss_min);  %% Find steady state gains
		end

		result{i}.math.hankel_svd=hsvd(result{i}.eom.state_space);
	else
		result{i}.math.freq_resp=[];
		result{i}.math.ss_resp=[];
		result{i}.math.hankel_svd=[];
	end
	
	
end

end %% Leave

