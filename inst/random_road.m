function [x,z]=random_road(varargin)

class=3;
L=100; % max wavelength [m], also equals road length
B=0.05; % shortest wavelength [m]

switch(nargin)
	case 1
		class=varargin{1};
	case 2
		class=varargin{1};
		L=varargin{2};
	case 3
		class=varargin{1};
		L=varargin{2};
		B=varargin{3};
end

% class is an integer from 3 - 9, where class=3 is an A-B road (smooth), class=9 is G-H road (rough) 

if(class<3)
	class=3;
	disp('Warning: class out of range, resetting to minimum value (3)');
end

if(class>9)
	class=9;
	disp('Warning: class out of range, resetting to maximum value (9)');
end

N=L/B; % number of frequencies
deltan=1/L; % spatial frequency interval

n=(deltan:deltan:N*deltan); % frequency span

phi=rand(1,N)*2*pi; % random phase lag for each frequency

a=sqrt(deltan)*(2^class)*1e-3*(0.1./n); % amplitude of each frequency, based on psd content

x=0:B/10:L; % road coordinate

z=zeros(size(x)); % road vertical

for i=1:length(n) % sum for each frequency included
	z=z+a(i)*cos(2*pi*n(i)*x+phi(i));
end

end %% Leave
