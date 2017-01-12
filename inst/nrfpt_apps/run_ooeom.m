function varargout=run_ooeom(varargin)

%movefile(['apps' filesep() 'ooeom'],['apps' filesep() 'a_ooeom']);

%try
	varargout=run_eom(varargin{:});
%catch
	disp('failed');
%end

movefile(['apps' filesep() 'a_ooeom'],['apps' filesep() 'ooeom']);

